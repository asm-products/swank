<?php

namespace Swank\Services;


use Swank\Contracts\IPhraseScanner;

class SwankPhraseScanner implements IPhraseScanner
{

    /**
     * @inheritdoc
     */
    function scanForPhrase($text)
    {
        /* swank phrase is of the following form:
         * phrase= Swank: [{condition}: {ListingType}:]? "{query}" [,"{query}"]*
         * condition=used|new|both
         * listingType=BIN|Auction|both
         * query=[^"]+
         */

        $scanResult = array();

        //first case: all option specified
        $result = preg_match_all("/(^|\\s)Swank\\s*?:\\s*?(used|new|both)\\s*?:\\s*?(bin|auction|both)\\s*?:\\s*? (\"(.*?)\"(\\s*?,\\s*?\".*?\")*)/xi", $text, $match);
        if ($result) {
            //iterate over results
            for ($i = 0; $i < count($match[2]); $i++) {
                $condition = strtolower($match[2][$i]);
                $listingType = strtolower($match[3][$i]);

                switch($condition) {
                    case "new": $condition=1000;break;
                    case "used": $condition=3000;break;
                    case "both": $condition=1;break;
                    default:
                        $condition=3000; //used
                }

                switch($listingType) {
                    case "both":$listingType="ALL";break;
                    case "bin": $listingType="BIN";break;
                    case "auction": $listingType="AO";break;
                    default:
                        $listingType="BIN";
                }

                $queries = $match[4][$i];

                $this->addToScanResult($scanResult, $condition, $listingType, $queries);
            }
        }

        //second case: only query option specified
        $result = preg_match_all("/(^|\\s)Swank\\s*?:\\s*?(\"(.*?)\"(\\s*?,\\s*?\".*?\")*)/xi", $text, $match);
        if ($result) {
            $condition = "3000"; //used
            $listingType = "BIN"; //buy it now

            //iterate over results
            foreach ($match[2] as $queries) {
                $this->addToScanResult($scanResult, $condition, $listingType, $queries);
            }
        }

        return $scanResult;
    }

    /**
     * @param array $scanResult the array results are added to
     * @param string $condition the condition (used, new, both)
     * @param string $listingType the listing type (bin, auction, both)
     * @param string $queries the queries ("{query}","{query}",...)
     * @return array the scan result with added items
     */
    private function addToScanResult(&$scanResult, $condition, $listingType, $queries)
    {
        //split in case of mulitple queries
        preg_match_all("/\"(.*?)\"/xi", $queries, $queryMatch);
        for ($j = 0; $j < count($queryMatch[1]); $j++) {
            $query = $queryMatch[1][$j];

            //add to scanned result
            $scanResult[] = array(
                "condition" => $condition,
                "listingType" => $listingType,
                "query" => $query
            );
        }

        return $scanResult;
    }
}