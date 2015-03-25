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

            $scoreHelp = "";
            if ($score>=20 && $score<40) {
                $scoreHelp="(Acceptable. Longer Turnover and Average Profits)";
            } elseif ($score>=40 && $score<60) {
                $scoreHelp="(Average Turnover and Good Profits)";
            } elseif ($score>=60 && $score<80) {
                $scoreHelp="(Faster Turnover and Great Profits)";
            } elseif ($score>=80) {
                $scoreHelp="(Super Fast Turnover and Execellent Profits)";
            }
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

**Swank Score:** $score $scoreHelp

**Average Price:** $$avgPrice

**Turnover:** $turnOver

**Price Range:** $$priceRangeFrom-$$priceRangeTo
EOT;
        }

        return "**Nothing found for '$query'**";

    }
}