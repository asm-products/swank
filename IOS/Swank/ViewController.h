//
//  ViewController.h
//  Swank
//
//  Created by ??? on 1/27/15.
//  Copyright (c) 2015 Swank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"
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
@property (strong,nonatomic)  NSString *Condition;
@property (strong,nonatomic)  NSString *ListingType;
@property (strong,nonatomic)  NSString *SendUrl;
@property (strong,nonatomic)  NSString *StopListingUrl;
@end

