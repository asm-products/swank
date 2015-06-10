//
//  URLMaker.h
//  Swank
//
//  Created by Nik on 29/05/2015.
//  Copyright (c) 2015 Swank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLMaker : NSObject

+ (NSString*)encodedURLForQuery:(NSString*)query condition:(NSString*)condition listingType:(NSString*)listingType exact:(BOOL)exact;

+ (NSString*)encodedURLForBarcodeQuery:(NSString*)query type:(NSString*)barcodeType condition:(NSString*)condition listingType:(NSString*)listingType;

@end
