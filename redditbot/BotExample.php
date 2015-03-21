<?php

use Swank\Services\FilePostStorage;
use Swank\Services\SwankPhraseScanner;
use Swank\Services\SwankPostGenerator;

require_once('vendor/autoload.php');

$redditUser='';
$redditPass='';
$swankUserId='';

$bot=new \Swank\RedditBot(new SwankPhraseScanner(), new SwankPostGenerator(), new FilePostStorage('storage/redditScanBot'), $redditUser, $redditPass, $swankUserId);

$bot->scanPostIn('sandboxtest');