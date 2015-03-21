<?php

namespace Swank\Contracts;


interface IPhraseScanner {
    /**
     * Scans for a specific phrase or multiple phrases thereof within the given text
     *
     * @param string $text
     * @return mixed[] phrases found including tokenization of phrase or empty array if no phrase was found
     */
    function scanForPhrase($text);
}