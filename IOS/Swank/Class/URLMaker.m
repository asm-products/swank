//
//  URLMaker.m
//  Swank
//
//  Created by Nik on 29/05/2015.
//  Copyright (c) 2015 Swank. All rights reserved.
//

#import "URLMaker.h"

@implementation URLMaker

+ (NSString*)encodedURLForQuery:(NSString*)query condition:(NSString*)condition listingType:(NSString*)listingType exact:(BOOL)exact {
    NSString *stopListingUrl=@"http://stoplisting.com/api/?swank&user_id=0&";
    
    NSString *queryParam = (exact) ? @"query=@" : @"query=";
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) query,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    return [NSString stringWithFormat:@"%@%@%@%@%@%@%@",stopListingUrl,queryParam,encodedString,@"&condition=",condition,@"&listingtype=",listingType];
}

@end
