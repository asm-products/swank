//
//  SearchResult.m
//  Swank
//
//  Created by Nik on 28/05/2015.
//  Copyright (c) 2015 Swank. All rights reserved.
//

#import "SearchResult.h"

@implementation SearchResult

+ (NSArray *)indexedProperties {
    return @[@"query", @"searchDate"];
}

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"query":@"",
             @"exact":@NO,
             @"condition":@"",
             @"listingType":@"",
             @"imageUrl": @"",
             @"searchDate": [NSDate date],
             @"swankScore": @"0",
             @"averagePrice": @"0",
             @"turnover": @"0"};
}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
