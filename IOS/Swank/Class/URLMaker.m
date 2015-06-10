//
//  URLMaker.m
//  Swank
//
//  Created by Nik on 29/05/2015.
//  Copyright (c) 2015 Swank. All rights reserved.
//

#import "URLMaker.h"

@implementation URLMaker

+ (NSString*)encodedURLForQuery:(NSString *)query barcodeType:(NSString*)barcode condition:(NSString *)condition listingType:(NSString *)listingType exact:(BOOL)exact
{
    NSString *stopListingUrl=@"http://stoplisting.com/api/?swank&user_id=0&";
    
    NSString *queryParam = (barcode == nil && exact) ? @"query=@" : @"query=";
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) query,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    NSString *barcodeSuffix = (barcode != nil) ? [@"&barcodetype=" stringByAppendingString:barcode] : @"";
    
    return [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",stopListingUrl,queryParam,encodedString,@"&condition=",condition,@"&listingtype=",listingType,barcodeSuffix];
}

+ (NSString*)encodedURLForQuery:(NSString*)query condition:(NSString*)condition listingType:(NSString*)listingType exact:(BOOL)exact {
    return [self encodedURLForQuery:query barcodeType:nil condition:condition listingType:listingType exact:exact];
}

+ (NSString*)encodedURLForBarcodeQuery:(NSString*)query type:(NSString*)barcodeType condition:(NSString*)condition listingType:(NSString*)listingType {
    return [self encodedURLForQuery:query barcodeType:barcodeType condition:condition listingType:listingType exact:NO];
}

@end
