<?php

namespace Swank\Contracts;


interface IPostStorage {
    /**
     * @param string $subreddit
     * @return string
     */
    function getLastPost($subreddit);

    /**
     * @param string $subreddit
     * @return string
     */
    function getLastComment($subreddit);

    /**
     * @param string $subreddit
     * @param string $postId
     * @param int $postTime
     */
    function finishedPost($subreddit, $postId, $postTime);

    /**
     * @param string $subreddit
     * @param string $postId
     * @param int $postTime
     */
    function workingPost($subreddit, $postId, $postTime);

    /**
     * @param string $subreddit
     * @param string $commentId
     * @param int $commentTime
     */
    function finishedComment($subreddit, $commentId, $commentTime);

    /**
     * @param string $postId
     * @return bool
     */
    function alreadyAnswered($postId);

    /**
     * Called on answered posts so that they won't be answered again
     *
     * @param string $postId the post that was answered
     *
     */
    function answeredPost($postId);
}