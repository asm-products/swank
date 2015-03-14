<?php
/*
Created: 3/13/15 12:13 PM

Name: Swank Bot

Bot Rules: Can Only Make 1 call every 2 seconds
Check This Every 3 Minutes

list of related subreddits to run this bot in:

/r/Flipping 
/r/Amazon
/r/Barter
/r/BeerMoney
/r/Classifieds
/r/CraigsList
/r/DealsReddit
/r/DiscountedProducts
/r/DumpsterDiving
/r/Ebay
/r/eBayTreasures
/r/Frugal
/r/FulfillmentByAmazon
/r/gamecollecting
/r/HowMuchWouldYouPay
/r/RedditBay
/r/RedditExchange
/r/ThriftStoreHauls
/r/Thrifty
/r/WhatIsThisThing
/r/WhatsThisWorth
/r/YardSale
*/

//name of subreddits
//$sub_list = array("flipping","amazon","barter","beermoney","classifieds","craigslist","dealsreddit","discountedproducts","dumpsterdiving","ebay","ebaytreasures","frugal","fulfillmentbyamazon","gamecollecting","howmuchwouldyoupay","redditbay","redditexchange","thriftstorehauls","thrifty","whatisthisthing","whatsthisworth","yardsale","swankhunt");
$sub_list = array("swankhunt");


//connect to database (reddit database) use pdo.
//create table if not exists;

//login to reddit
include "../User.php";
$user = new User("swankbot", "MADHAXPASSWORD");






foreach($sub_list as $sub) {
	if ($user->isLoggedOn()) {
		//bring up subreddit
		include("../Subreddit.php");
		$subreddit = new Subreddit($sub);
		foreach($subreddit->getPosts("new") as comment) {

			//search for a matching comment to the phrase. (lower case both to match)
			// select * from table where comment id =? USE PDO.
			// fetch the count of the row. if it finds something, then continue/pass this comment.continue loop.
			
			//TRY LOOP:
				// if author of the comment is not the bot:
					// if the comment author is valid, (not deleted post), then continue
							// break down the "query" and get the search.
							//contact the swank api, and get a response
							break the json down into a mangeable post reply.
					// end if
				// end if
			// END TRY 
			// exception: if error, just CONTINUE;
			
			// save all comment ids that are looked up so use insert into that new table USE PDO
		
		} // end comment loop	
		
	}
	else
		exit;
}
?>