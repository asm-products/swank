<?php


namespace Swank\Services;


use Swank\Contracts\IPostGenerator;

class SwankPostGenerator implements IPostGenerator {

    /**
     * @inheritdoc
     */
    function createPostFor($swankResult, $query)
    {

        if ($swankResult['status']==200) {
            $title = $query;
            $score = $swankResult['swank_score'];
            //TODO
            //$scoreHelp = "Very sellable";
            $avgPrice = $swankResult['avg_price'];
            $turnOver = $swankResult['turnover_rate'];

            $priceRangeFrom = $avgPrice;
            $priceRangeTo = $avgPrice;
            foreach ($swankResult['results'] as $result) {
                $priceRangeFrom = min($priceRangeFrom,$result['sold_price']);
                $priceRangeTo = max($priceRangeTo,$result['sold_price']);
            }


            return <<<EOT
*$title*

**Swank Score:** $score

**Average Price:** $$avgPrice

**Turnover:** $turnOver

**Price Range:** $$priceRangeFrom-$$priceRangeTo
EOT;
        }

        return "**Nothing found for '$query'**";

    }
}