//
//  searchResults.h
//  PDFView
//
//  Created by Admin on 03/12/14.
//  Copyright (c) 2014 youngjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface searchResults : NSObject
    @property (strong,nonatomic)  NSString *_swank;
    @property (strong,nonatomic)  NSString *_avg_price;
    @property (strong,nonatomic)  NSString * _turnover_rate;
    @property (strong,nonatomic)  NSString *_title;
    @property (strong,nonatomic)  NSString *_imageUrl;
    @property (strong,nonatomic)  NSString *_sold_date;
    @property (strong,nonatomic)  NSString *_sold_price;

-(id)initWithData:(NSString*)Setswank_score Setavg_score:(NSString*)Setavg_score Setturnover_rate:(NSString*)Setturnover_rate Settitle:(NSString*)Settitle SetimageUrl:(NSString*)SetimageUrl Setsold_date:(NSString*)Setsold_date Setsold_price:(NSString*)Setsold_price;
@end
