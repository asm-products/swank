//
//  PageViewController.h
//  PDFView
//
//  Created by Admin on 03/12/14.
//  Copyright (c) 2014 youngjin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ContentViewController.h"
#import "searchResults.h"
#import "ViewController.h"
#import "GAITrackedViewController.h"
@interface PageViewController : GAITrackedViewController <UIScrollViewDelegate, UIWebViewDelegate>
@property (strong,nonatomic) NSArray *pageContent;
@property (strong,nonatomic) searchResults  *contentResults;
@property (strong,nonatomic)  NSMutableArray *SearchResults;
@property (strong,nonatomic) IBOutlet UIScrollView *UrlScrollView;
@property (strong,nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong,nonatomic) NSString  *pageUrl;
@property (strong,nonatomic) NSMutableArray *pageString;
@property (strong,nonatomic) NSString *sendUrl;
@property (strong,nonatomic)  searchResults *responseResults;
@property (nonatomic,getter=isMomentary) BOOL momentary;
@property (nonatomic,strong) IBOutlet UILabel *SwankValue;
@property (nonatomic,strong) IBOutlet UILabel *avgPriceValue;
@property (nonatomic,strong) IBOutlet UILabel *turnOverValue;
@property (nonatomic,strong) IBOutlet UIView *summaryContainer;
-(void) segmentaction:(UISegmentedControl *)segment;
@end
