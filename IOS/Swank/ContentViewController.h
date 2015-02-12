//
//  ContentViewController.h
//  PDFView
//
//  Created by Admin on 03/12/14.
//  Copyright (c) 2014 youngjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController
//@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *SwankScoreLabel;
@property (strong, nonatomic) NSString *SwankScoreValue;
@property (strong, nonatomic) IBOutlet UILabel *AvgPriceLabel;
@property (strong,nonatomic) NSString *AvgPriceValue;
@property (strong,nonatomic) id dataObject;
@property (strong, nonatomic) IBOutlet UILabel *TurnOverLabel;
@property (strong, nonatomic) IBOutlet UIButton *CurrentPageBtn;
@property (strong,nonatomic) NSString *TurnOverValue;
@end
