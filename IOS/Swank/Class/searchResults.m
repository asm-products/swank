//
//  searchResults.m
//  PDFView
//
//  Created by ??? on 03/12/14.
//  Copyright (c) 2014 Swank. All rights reserved.
//

#import "searchResults.h"

@implementation searchResults

-(id) initWithData:(NSString *) Setswank_score Setavg_score:(NSString*)Setavg_score Setturnover_rate:(NSString*)Setturnover_rate Settitle:(NSString*)Settitle SetimageUrl:(NSString *) SetimageUrl Setsold_date:(NSString*)Setsold_date Setsold_price:(NSString*)Setsold_price
{
    self=[super init];
     if(self)
    {
        self._swank =Setswank_score;
        self._sold_date=Setsold_date;
        self._sold_price =Setsold_price;
        self._avg_price=Setavg_score;
        self._turnover_rate =Setturnover_rate;
        self._title = Settitle;
        self._imageUrl =SetimageUrl;
    }
    
    return self;
}

@end
