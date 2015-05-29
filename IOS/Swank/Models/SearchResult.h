//
//  SearchResult.h
//  Swank
//
//  Created by Nik on 28/05/2015.
//  Copyright (c) 2015 Swank. All rights reserved.
//

#import <Realm/Realm.h>

@interface SearchResult : RLMObject

@property NSString *query;

@property BOOL exact;

@property NSString *condition;

@property NSString *listingType;

@property NSString *imageUrl;

@property NSDate *searchDate;

@property NSString *swankScore;

@property NSString *averagePrice;

@property NSString *turnover;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<SearchResult>
RLM_ARRAY_TYPE(SearchResult)
