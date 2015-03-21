<?php


namespace Swank\Services;



use Swank\Contracts\IPostStorage;

class FilePostStorage implements IPostStorage {

    /**
     * @param string $filename the filename to store data to
     */
    public function __construct($filename) {
        $this->filename=$filename;
        $this->data=array();
        $this->readFile($filename);
    }

    /**
     * @inheritdoc
     */
    function getLastPost($subreddit)
    {
        if (isset($this->data[$subreddit]['lastId'])) {
            return $this->data[$subreddit]['lastId'];
        }

        return null;
    }

    function getLastComment($subreddit)
    {
        if (isset($this->data[$subreddit]['lastCommentId'])) {
            return $this->data[$subreddit]['lastCommentId'];
        }

        return null;
    }

    /**
     * @inheritdoc
     */
    function finishedPost($subreddit, $postId, $postTime)
    {
        if (isset($this->data[$subreddit]['lastTime'])) {
            //if post is older than already seen post, return
            if ($this->data[$subreddit]['lastTime']>$postTime) {
                return;
            }
        }

        $this->data[$subreddit]['lastTime']=$postTime;
        $this->data[$subreddit]['lastId']=$postId;

    }

    function finishedComment($subreddit, $commentId, $commentTime)
    {
        if (isset($this->data[$subreddit]['lastCommentTime'])) {
            //if post is older than already seen post, return
            if ($this->data[$subreddit]['lastCommentTime']>$commentTime) {
                return;
            }
        }

        $this->data[$subreddit]['lastCommentTime']=$commentTime;
        $this->data[$subreddit]['lastCommentId']=$commentId;

    }


    function answeredPost($postId) {
        $this->data['answered'][$postId]=true;
    }

    /**
     * @inheritdoc
     */
    function alreadyAnswered($postId)
    {
        return isset($this->data['answered'][$postId]);
    }

    private function readFile($filename)
    {
        if (file_exists($filename)) {
            $this->data=unserialize(file_get_contents($filename));
            if (!is_array($this->data)) {
                //something didn't work
                $this->data = array();
            }
        }
    }

    public function __destruct() {
        file_put_contents($this->filename, serialize($this->data));
    }

    function workingPost($subreddit, $postId, $postTime)
    {
        //not implemented
    }
}