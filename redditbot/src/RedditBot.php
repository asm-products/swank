<?php

namespace Swank;

use GuzzleHttp\Client;
use Swank\Contracts\IPhraseScanner;
use Swank\Contracts\IPostGenerator;
use Swank\Contracts\IPostStorage;


class RedditBot {
    private $requestsLeft=30;
    private $resetTime=0;

    public function __construct(IPhraseScanner $scanner, IPostGenerator $postGen, IPostStorage $storage, $user, $pass, $swankUser) {
        $this->scanner=$scanner;
        $this->postGenerator=$postGen;
        $this->storage=$storage;
        $this->swankUser=$swankUser;

        $this->client=$client=new Client(array(
            'base_url' => 'http://www.reddit.com',
            'defaults' => array(
                'headers' => array('User-Agent' => 'Swank Reddit Bot/1.0'),
                'cookies' => true
            )));

        $login = $client->createRequest('POST', '/api/login/'.urlencode($user));
        $login->getBody()->replaceFields(
            array(
                'api_type' => 'json',
                'user'     => $user,
                'passwd'   => $pass,
            )
        );

        $json=$this->sendRequest($login);

        $this->modhash=$json['json']['data']['modhash'];
    }

    public function scanPostIn($subreddit) {
        $params=array(
            'limit'         => 100
        );
        $scanForward=true;
        if (null !== $this->storage->getLastPost($subreddit)) {
            $params['before'] = $this->storage->getLastPost($subreddit);
            $scanForward=false;
        }

        $continue=true;
        $listing=array();
        while ($continue) {
            $continue = false;
            $submit=$this->client->createRequest('GET', '/r/'.urlencode($subreddit).'.json', array('query'=>$params));
            $json=$this->sendRequest($submit);

            $listing=array_merge($listing, $json['data']['children']);

            if ($scanForward) {
                if (isset($json['data']['after'])) {
                    $params['after'] = $json['data']['after'];
                    $continue = true;
                }
            } else {
                if (isset($json['data']['before'])) {
                    $params['before'] = $json['data']['before'];
                    $continue = true;
                }
            }

        }


        //now scan comments
        $continue=true;
        $params=array(
            'limit'         => 100
        );
        $scanForward=true;
        if (null !== $this->storage->getLastComment($subreddit)) {
            $params['before'] = $this->storage->getLastComment($subreddit);
            $scanForward=false;
        }
        while ($continue) {
            $continue = false;
            $submit=$this->client->createRequest('GET', '/r/'.urlencode($subreddit).'/comments.json', array('query'=>$params));
            $json=$this->sendRequest($submit);


            $listing=array_merge($listing, $json['data']['children']);

            if ($scanForward) {
                if (isset($json['data']['after'])) {
                    $params['after'] = $json['data']['after'];
                    $continue = true;
                }
            } else {
                if (isset($json['data']['before'])) {
                    $params['before'] = $json['data']['before'];
                    $continue = true;
                }
            }

        }


        $limit=3;
        foreach ($listing as $l) {
            $entry = $l['data'];
            $comment=$l['kind']=='t1';
            if (!$this->storage->alreadyAnswered($entry['name']) && (isset($entry['selftext']) || ($comment && isset($entry['body'])))) {
                $foundQueries = array_slice($this->scanner->scanForPhrase($comment?$entry['body']:$entry['selftext']),0,$limit);
                $this->storage->workingPost($subreddit, $entry['name'], $entry['created']);

                if (array_count_values($foundQueries)<=0) {
                    //simply mark as done
                    if ($comment) {
                        $this->storage->finishedComment($subreddit, $entry['name'], $entry['created']);
                    } else {
                        $this->storage->finishedPost($subreddit, $entry['name'], $entry['created']);
                    }
                }

                foreach ($foundQueries as $query) {
                     //do swank query
                    $future=$this->client->get('http://stoplisting.com/api/', array(
                        'future'=>true,
                        'query'=>array(
                            'swank'=>'',
                            'user_id'=>$this->swankUser,
                            'query'  =>$query['query'],
                            'condition'=>$query['condition'],
                            'listingType'=>$query['listingType'],
                        )
                    ));

                    $t=$this;
                    $future->then(function($response) use ($entry, $t, $query, $comment, $subreddit) {
                        $json=$response->json();
                        $t->submitPost($t->postGenerator->createPostFor($json[0], $query['query']), $entry['name']);
                        if ($comment) {
                            $t->storage->finishedComment($subreddit, $entry['name'], $entry['created']);
                        } else {
                            $t->storage->finishedPost($subreddit, $entry['name'], $entry['created']);
                        }
                    });
                }
            }

        }

    }

    private function submitPost($post, $replyId) {
        $submit = $this->client->createRequest('POST','/api/comment');
        $submit->getBody()->replaceFields(
            array(
                'thing_id'      => $replyId,
                'text'          =>$post,
                'uh'            => $this->modhash,
            )
        );

        $this->sendRequest($submit);
        $this->storage->answeredPost($replyId);
    }

    private function sendRequest($request) {
        if ($this->requestsLeft<=0 && time()<$this->resetTime) {
            //wait until reddit allows for more requests
            time_sleep_until($this->resetTime);
        }
        $response=$this->client->send($request);

        if ($response->hasHeader('X-Ratelimit-Remaining')) {
            $this->requestsLeft = $response->getHeader('X-Ratelimit-Remaining');
            $this->resetTime = time() + (int)$response->getHeader('X-Ratelimit-Reset');
        }

        $json=$response->json();

        if (isset($json['data']['modhash'])) {
            $this->modhash=$json['data']['modhash'];
        }
        return $json;
    }


}


