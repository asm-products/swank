//
//  ViewController.h
//  Swank
//
//  Created by admin on 1/27/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchResults.h"
#import "PageViewController.h"
#import "MBProgressHUD.h"
#import "ScannerViewController.h"
#import "GAITrackedViewController.h"

@interface ViewController : GAITrackedViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *normalButton;
//- (IBAction)normalClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BsrcodeSearchBtn;
- (IBAction)BarcodesearchBtn_Click:(id)sender;
- (IBAction)KeywordDeleteClick:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *KeywordText;
@property (strong, nonatomic) IBOutlet UIButton *TrashBtn;

@property (weak, nonatomic) IBOutlet UIButton *ExtractSearchBtn;
//@property (strong,nonatomic) UITextField* txtfield;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ConditionSetting;
- (IBAction)ConditionIndexChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ListingTypeSetting;
- (IBAction)ListingIndexChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
- (IBAction)SearchText:(id)sender;
@property (strong,nonatomic)  NSString *Condition;
@property (strong,nonatomic)  NSString *ListingType;
@property (strong,nonatomic)  NSString *SendUrl;
@property (strong,nonatomic)  NSString *StopListingUrl;
@property (strong,nonatomic)  NSMutableArray *SearchResults;
@property (strong,nonatomic)  searchResults *responseResults;
//@property (nonatomic, strong) MBProgressHUD *buyHUD;
@end

