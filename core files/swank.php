<?
//......... This section comes from another file that validates the users search request and then brings in said data
// Swank Rank

if(isset($_GET['swank']) && isset($_GET['user_id']) && isset($_GET['query'])){
	include('swank.php'); //include swank
	
	// User Trial Version Ceiling Limit for free users.  true=permmited, false - search blocked
	$trialcheck = getTrialCheck($_GET['user_id'], $_GET['query']);
	if ($trialcheck === false) { //reject them
	
		echo '[{"status":"200","swank_score":"0","avg_price":"0.00","turnover_rate":"0.0 Day(s)","num_results":"1","results":[{"title":"Swank Trial Search Limit Reached. Upgrade Now To Remove These Limits.","image":"http://stoplisting.com/swanklimit.png","sold_date":"1970-01-01","sold_price":"0.00"}]}]';
		exit;
	} else {
		if (isset($_GET['barcodeType'])) {
			echo getSwankScore($_GET['query'], true, $_GET['condition'], $_GET['barcodeType'], $_GET['listingType'], $_GET['user_id'], $_GET['limit'], $_GET['mode']);   
		}	
		else if (isset($_GET['condition'])) {echo getSwankScore($_GET['query'], true, $_GET['condition'], NULL, $_GET['listingType'], $_GET['user_id'], $_GET['limit'], $_GET['mode']);} 
		else if ($_GET['searchType'] == "simple"){echo getSwankScore($_GET['query'], false);}
		else {echo getSwankScore($_GET['query'], true);}
		exit;
	}
}
?>

<?
// this is whats in swank.php
error_reporting(E_ALL);
ini_set('display_errors', '0');

// User Trial Version Ceiling Limit for free users.
function getTrialCheck($user_num, $query) {
	if ($user_num == '0') { //paid users, check nothing.
		return true;
	} else { //non-paid swank users or stoplisting customers.
		 //check user account for free or paid plan. 
		 
		include_once('../../dash/stoplisting/con/config.php');
		$row 	= mysql_query("SELECT plan from users where id = '".$user_num."' and status != '0'") or die(mysql_error());
		$data 	= mysql_fetch_object($row);
		if ($data->plan !== '1') {
			 // If it is paid, return and end check
			 return true;
		} else {
			 // If it is free, check the account for the daily limit which is imposed at 20
			$row2 	= mysql_query("SELECT id FROM `swank_log` WHERE `user_id`=".$user_num) or die(mysql_error());
			$data2 	= mysql_num_rows($row2);
			if ($data2 < 20) {
				 // If limit not met, let them search and add one to the limit
				 return true;
			} else {
				 // If limit is met, stop them and advertise
				 return false;
			}
		}	 
	}
}


// Get Swank Score
function getSwankScore($search, $all_info = NULL, $condition = NULL, $barcodeType = NULL, $listingType = NULL, $user_id = 0, $limit = NULL, $mode = NULL) {
	require_once("../../dash/ebay/finding.php");
	include_once('../../dash/stoplisting/con/config.php');
	$ebay = new ebay();
	
	if (is_null($barcodeType)) {
		//$nostring = $search."NO:Pack,LOT,Toy,Game BOY:"; //takes this format, or it can take No:Pack format
		if(stripos($search, "no:") !== false) {
			$negative_string = explode("no:", strtolower($search));
			$search 	 = $negative_string[0]; //takes everything before the negative term
			$nostring 	 = $negative_string[1]; //takes the list of the negative terms.
		} 	
	
		$responseType = "findCompletedItemsResponse";
		$result=$ebay->findProduct('findCompletedItems', $search, 83, $condition, NULL, $listingType);
	} else {		
		$auth_key = "Vv47S1x8y2On2Ps7";
		$app_key  = "/z6CFFg+nu/G";
		
		$results = json_decode(file_get_contents('https://digit-eyes.com/gtin/v2_0/?&upcCode='.$search.'&app_key='.$app_key.'&auth_key='.$auth_key.'&signature='.base64_encode(hash_hmac('sha1', $search, $auth_key, $raw_output = true)).'&language=en&field_names=description'), true);
		
		if ($results['return_message'] == "Success") {
			$barcodeType = NULL;
			$responseType = "findCompletedItemsResponse";
			$result=$ebay->findProduct('findCompletedItems', $results['description'], 83, $condition, NULL, $listingType);
		} else {
			//error regular barcode search
			// all numeric i.e ISBN, UPC, EAN
			$responseType = "findItemsByProductResponse";
			$result=$ebay->findProduct('findItemsByProduct', $search, 83, $condition, $barcodeType, $listingType); 
		}	
	}	
	$total_entries = $result[''.$responseType.''][0]['paginationOutput'][0]['totalEntries'][0];
	if ($total_entries < 1) { // no results
		$issue ='"note":"OSNF-AC",'; // original search not found, search All condition based results
		if (is_null($barcodeType)) {
			$result=$ebay->findProduct('findCompletedItems', $search, 83, 1, NULL, $listingType);	
		} else {
			$result=$ebay->findProduct('findItemsByProduct', $search, 83, 1, $barcodeType, $listingType); 
		}
		
		$total_entries = $result[''.$responseType.''][0]['paginationOutput'][0]['totalEntries'][0];
		if ($total_entries < 1) { // no results still
			$issue ='"note":"OSNF-AC+ALT",'; // original search not found, All condition & All Listing Type based results
			if (is_null($barcodeType)) {
				$result=$ebay->findProduct('findCompletedItems', $search, 83, 1, NULL, "ALL");	
			} else {
				$result=$ebay->findProduct('findItemsByProduct', $search, 83, 1, $barcodeType, "ALL"); 
			}
			$total_entries = $result[''.$responseType.''][0]['paginationOutput'][0]['totalEntries'][0];
			if ($total_entries < 1) { // no results still
				if (is_null($barcodeType)) {
						$issue ='"note":"OSNF-EXT",'; // original search not found, search EXACT
						$search = "@".$search; // exact search 
						$responseType = "findCompletedItemsResponse";
						$result=$ebay->findProduct('findCompletedItems', $search, 83, $condition, NULL, $listingType);
					
					$total_entries = $result[''.$responseType.''][0]['paginationOutput'][0]['totalEntries'][0];
					if ($total_entries < 1) { // no results
						$issue ='"note":"OSNF-EXT+AC",'; // original search not found, search EXACT, search All condition based results
							$result=$ebay->findProduct('findCompletedItems', $search, 83, 1, NULL, $listingType);	
						$total_entries = $result[''.$responseType.''][0]['paginationOutput'][0]['totalEntries'][0];
						if ($total_entries < 1) { // no results still
							$issue ='"note":"OSNF-EXT+AC+ALT",'; // original search not found, search EXACT, All condition & All Listing Type based results
							$result=$ebay->findProduct('findCompletedItems', $search, 83, 1, NULL, "ALL");	
							$total_entries = $result[''.$responseType.''][0]['paginationOutput'][0]['totalEntries'][0];
							if ($total_entries < 1) { // no results still
								return '[{"status":"404","swank_score":"0","error":"0 results"}]';
							}
						}
					}
				}	
			}
		}
	}
	
	// Calculation Time:
	$price			= 0; 
	$diff			= 0;
	$swank_points 		= 0;
	$swank_points_calc1 	= 0;
	$swank_points_calc2 	= 0;
	$swank_points_calc3 	= 0;
	$avg_sale_time 		= array();
	$temp			= array();
	
	
	if (!isset($nostring)) {
		foreach($result[''.$responseType.''][0]['searchResult'][0]['item'] as $value2){
			$stime			= '';
			$etime			= '';
			$temp['title'][]	= $value2['title'][0];
			$temp['price'][]	= $value2['sellingStatus'][0]['convertedCurrentPrice'][0]['__value__'];
			$stime			= explode('T', $value2['listingInfo'][0]['startTime'][0]);
			$temp['start_date'][]	= trim($stime[0]);
			$etime			= explode('T', $value2['listingInfo'][0]['endTime'][0]);
			$temp['end_date'][]	= trim($etime[0]);
			$temp['image'][]	= $value2['galleryURL'][0];
		}
	} else {
		//http://stackoverflow.com/questions/6284553/using-an-array-as-needles-in-strpos?rq=1 - By Binyamin
		function strposa($haystack, $needle, $offset=0) {
		    if(!is_array($needle)) $needle = array($needle);
		    foreach($needle as $query) {
		        if(stripos($haystack, $query, $offset) !== false) return true; // stop on first true result
		    }
		    return false;
		}

		//Check the No:Pack,Lot, ETC Negative Keywords
		$negative_terms  	= explode(",", $negative_string[1]);
		$negative_terms  	= array_map("trim", $negative_terms);
		$nt 			= count($negative_terms)-1;
		$negative_terms[$nt] 	= rtrim($negative_terms[$nt], ":");
		
		foreach($result[''.$responseType.''][0]['searchResult'][0]['item'] as $value2){
			$test_terms = strposa($value2['title'][0], $negative_terms);
			if ($test_terms === false) { // if item is not in the array of negative terms
				$stime			= '';
				$etime			= '';
				$temp['title'][]	= $value2['title'][0];
				$temp['price'][]	= $value2['sellingStatus'][0]['convertedCurrentPrice'][0]['__value__'];
				$stime			= explode('T', $value2['listingInfo'][0]['startTime'][0]);
				$temp['start_date'][]	= trim($stime[0]);
				$etime			= explode('T', $value2['listingInfo'][0]['endTime'][0]);
				$temp['end_date'][]	= trim($etime[0]);
				$temp['image'][]	= $value2['galleryURL'][0];
			}
		}
	}
	
	$qualify_num = 0;
	// Calculation #1 Recent Buys - 33 points
	foreach($temp['end_date'] as $value){
			if ($diff>32) {break;}
			$qualify_num++;
			if ($swank_points_calc1 < 33) {
				// Difference between the end date and todays date
				$date1 = new DateTime(date("Y-m-d H:i:s")); //todays date
				$date2 = new DateTime($value);
				
				$diff = $date2->diff($date1)->format("%a");
				
				if($diff==0){
					$swank_points_calc1 += 3;
				}
				if($diff==1){	
					$swank_points_calc1 += 1.5;
				}
				if($diff>1 && $diff<=7){	
					$swank_points_calc1 += .5;
				}
				if($diff>7 && $diff<=31){ //within the month	
					$swank_points_calc1 += .4;
				}
				if (count($avg_sale_time) < 15 ) {
					$avg_sale_time[] = $diff+1; 
				}
				if ($diff>32) { // stop operation if no recent buys within month range
				 break;
				} 
			} else {$swank_points_calc1 = 33;} //impose limit
	}
	
	
	for($i=0;$i < $qualify_num; $i++) {
		$price 	+= $temp['price'][$i];
	}
	
	if (array_sum($avg_sale_time) > 0) {
		$average_time 	= number_format(array_sum($avg_sale_time) / count($avg_sale_time), 1); 
	} else {$average_time = "N/A";}
	$avg_price	= $price/$qualify_num;
	$avg_profit	= round($avg_price*.85);
	
	
	// Calculation #2 - calculate swank for average profit 24 points possible
	switch(true){
		case($avg_profit>=100):
		$swank_points_calc2+=24;
		break;
		case($avg_profit>=75):
		$swank_points_calc2+=17;
		break;
		case($avg_profit>=50):
		$swank_points_calc2+=13;
		break;
		case($avg_profit>=30):
		$swank_points_calc2+=7;
		break;
		case($avg_profit>=20):
		$swank_points_calc2+=6;
		break;
		case($avg_profit>=10):
		$swank_points_calc2+=4;
		break;
		case($avg_profit>=5):
		$swank_points_calc2+=2;
		break;
	}

	$latest_price 	= $temp['price'][0];
	$latest_profit	= round($latest_price*.85);

	// Calculation #3 - calculate swank for latest profit 11.5 points possible
	switch(true){
		case($latest_profit>=150):
			$swank_points_calc2+=11.5;
		break;
		case($latest_profit>=100):
			$swank_points_calc2+=11;
		break;
		case($latest_profit>=75):
			$swank_points_calc2+=8;
		break;
		case($latest_profit>=50):
			$swank_points_calc2+=5.5;
		break;
		case($latest_profit>=30):
			$swank_points_calc2+=3.3;
		break;
		case($latest_profit>=20):
			$swank_points_calc2+=2.2;
		break;
		case($latest_profit>=10):
			$swank_points_calc2+=1.1;
		break;
	}

	// Calculation #4 - Latest 6 Price Point Percentage Trends 33 points possible
	
	if ($total_entries > 1) {
		$secondary_combo_avg	= (($temp['price'][1] + $temp['price'][2] + $temp['price'][3]+ $temp['price'][4] + $temp['price'][5] + $temp['price'][6])/6);
		$secondary_avg_profit	= $secondary_combo_avg*.85;
		$price_trend 		= round((($latest_profit-$secondary_avg_profit)/$secondary_avg_profit)*100);
	
		if ($price_trend > 0) {
			//positive percentage trend
			$swank_points_calc3	= round($price_trend/6);
			if ($swank_points_calc3 > 33) {$swank_points_calc3 = 33;} // limit cap
		} else {
			//negative percentage trend
			$swank_points_calc3	= round($price_trend/75);
			if ($swank_points_calc3 < -15) {$swank_points_calc3 = -15;} // limit cap
		}
	} else {$swank_points_calc3 = 0;}
	
	
	// Calculation #5 - calculate swank for Turnaround time 20 points curve possible curve only applicable if there are enough listings to warrant a true average time.
	if ($total_entries >= 5) {
		$swank_points_calc4 = round(20 / $average_time); // Grading Curve Based on Turnaround Time 20 points possible divided by average turn around time.
	} else {$swank_points_calc4 = 0;}
	
	$swank_points =	$swank_points_calc1+$swank_points_calc2+$swank_points_calc3+$swank_points_calc4; // Final Swank Score
	// if swank result is valid - status change.
	if (is_numeric($swank_points)) {$status=200;} 
	else {$status=503;}
	if ($swank_points <=0) {$swank_points=0;}
	if ($all_info == NULL) {
		return '[{"status":"'.$status.'","swank_score":"'.$swank_points.'"}]';
	} else {		
			$swank_result = '[{
			
			"status":"
				'.$status.'",
			"swank_score":"
				'.min($swank_points, 100).'",
			"avg_price":"
				'.number_format($avg_price, 2).'",
			"turnover_rate":"
				'.$average_time.' Day(s)",
			"num_results":"'.$total_entries.'",
			'.$issue.'
			"results":[';	
			if(!isset($_GET['limit']) && is_null($limit)) {
			$limit = 15;
			} else {
			$limit = $_GET['limit'];
			}
			if(!isset($_GET['mode']) && is_null($mode)) {
                $tmpItems=array();
                for($i=0;$i < count($temp['price']); $i++) {
                    if (($total_entries >= 4) && ($i == $limit)) {
                        break;
                    }
                    $tmpItems[]=$result['' . $responseType . ''][0]['searchResult'][0]['item'][$i]['itemId'][0];
                }

                //make query
                $tmpItems=$ebay->getPhotosLite($tmpItems);

                // Regular Large HD MODE
                for($i=0;$i < count($temp['price']); $i++) {
                    if (($total_entries >= 4) && ($i == $limit)) {break;}
                    //return print_r($ebay->getPhotoLite($result[''.$responseType.''][0]['searchResult'][0]['item'][$i]['itemId'][0]));

                    $swank_result .= '{"title":"'.str_replace(chr(34), chr(39), $temp['title'][$i]).'","image":"'. $tmpItems[$result['' . $responseType . ''][0]['searchResult'][0]['item'][$i]['itemId'][0]].'","sold_date":"'.$temp['end_date'][$i].'","sold_price":"'.number_format($temp['price'][$i], 2).'"},';
                }
			} else {
				// Low Thumbnail List Mode
				for($i=0;$i < count($temp['price']); $i++) {
					if (($total_entries >= 4) && ($i == $limit)) {break;}
						$swank_result .= '{"title":"'.str_replace(chr(34), chr(39), $temp['title'][$i]).'","image":"'.$temp['image'][$i].'","sold_date":"'.$temp['end_date'][$i].'","sold_price":"'.number_format($temp['price'][$i], 2).'"},';
				}
			}
			
			$swank_result  = rtrim($swank_result, ",");
			$swank_result .= ']}]';
			
			$row 	= mysql_query('INSERT INTO `swank_log`(`id`, `user_id`, `search`, `condition`, `score`, `date_searched`) VALUES ("", "'.$_GET['user_id'].'", "'.$search.'", "'.$condition.'", "'.min($swank_points, 100).'", NOW())') or die(mysql_error());
			//return print_r($result[''.$responseType.''][0]['searchResult'][0]['item']);
			return str_replace(array("\n", "\t", "\r"), '', $swank_result);
	}
}

/*
if(isset($_GET['user_id']) && isset($_GET['query'])){
	if (isset($_GET['barcodeType'])) {echo getSwankScore($_GET['query'], true, $_GET['condition'], $_GET['barcodeType'], $_GET['listingType']);exit;}	
	else if (isset($_GET['condition'])) {echo getSwankScore($_GET['query'], true, $_GET['condition'], NULL, $_GET['listingType']);exit;} 
	else if ($_GET['searchType'] == "simple"){echo getSwankScore($_GET['query'], false);exit;}
	else {echo getSwankScore($_GET['query'], true);exit;}
}*/

// Swank Rank
if(isset($_GET['user_id']) && isset($_GET['query'])){
	// User Trial Version Ceiling Limit for free users.  true=permmited, false - search blocked
	$trialcheck = getTrialCheck($_GET['user_id'], $_GET['query']);
	if ($trialcheck !== true) { //reject them
		echo '[{"status":"200","swank_score":"0","avg_price":"0.00","turnover_rate":"0.0 Day(s)","num_results":"1","results":[{"title":"Swank Trial Search Limit Reached. Upgrade Now To Remove These Limits.","image":"http://stoplisting.com/swanklimit.png","sold_date":"1970-01-01","sold_price":"0.00"}]}]';
		exit;
	} else {
		if (isset($_GET['barcodeType'])) {
			echo getSwankScore($_GET['query'], true, $_GET['condition'], $_GET['barcodeType'], $_GET['listingType'], $_GET['user_id'],$_GET['limit'],$_GET['mode']);   
		}	
		else if (isset($_GET['condition'])) {echo getSwankScore($_GET['query'], true, $_GET['condition'], NULL, $_GET['listingType'], $_GET['user_id'],$_GET['limit'],$_GET['mode']);} 
		else if ($_GET['searchType'] == "simple"){echo getSwankScore($_GET['query'], false);}
		else {echo getSwankScore($_GET['query'], true);}
		exit;
	}
}


?>