<?php

namespace Swank\Contracts;


interface IPostGenerator {
    /**
     * Creates a post based on swank result
     *
     * @param array $swankResult the swank result
     * @param string $query the actual query used with swank
     * @return string post based on swank result and query
     */
    function createPostFor($swankResult, $query);
}