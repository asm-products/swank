//
//  PageViewController.h
//  PDFView
//
//  Created by Admin on 03/12/14.
//  Copyright (c) 2014 youngjin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "searchResults.h"
#import "ViewController.h"
@interface PageViewController : UIViewController<UIScrollViewDelegate>
@property (strong,nonatomic) NSArray *pageContent;
@property (strong,nonatomic) searchResults  *contentResults;
@property (strong,nonatomic)  NSMutableArray *SearchResults;
@property (strong, nonatomic)  UIScrollView *UrlScrollView;
@property (strong, nonatomic)  UIScrollView *titleScrollView;
@property (strong,nonatomic)  UISegmentedControl *segmentedControl;
@property (strong,nonatomic) NSString  *pageUrl;
@property (strong,nonatomic) NSMutableArray *pageString;
@property (strong,nonatomic) NSString *sendUrl;
@property (strong,nonatomic)  searchResults *responseResults;
@property (nonatomic,getter=isMomentary) BOOL momentary;
-(void) segmentaction:(UISegmentedControl *)segment;
@end
