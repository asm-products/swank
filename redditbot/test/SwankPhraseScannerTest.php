<?php


class SwankPhraseScannerTest extends \PHPUnit_Framework_TestCase {

    function testSwankScanner() {
        $scanner=new \Swank\Services\SwankPhraseScanner();

        $this->assertNotNull($scanner);

        $text=<<<'EOT'
swank:used:bin:"query1"
swank:used:auction:"query1"
swank:used:both:"query1"
swank:new:bin:"query1"
swank:new:auction:"query1"
swank:new:both:"query1"
swank:both:both:"query1"
this should not be foundswank:new:bin:"query2"
swank:"query3"
swank:"multi1","multi2"
swank:"multi3","multi4" swank:"multi5","multi6" swank:"multi7","multi8"
swank:
"multiLine1",
"multiLine2"
"this is not scanned"
EOT;

        $results=$scanner->scanForPhrase($text);

        $this->assertSame(18,count($results));
    }
}
