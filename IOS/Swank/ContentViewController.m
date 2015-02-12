//
//  ContentViewController.m
//  PDFView
//
//  Created by Admin on 03/12/14.
//  Copyright (c) 2014 youngjin. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setScreenObjects];
}

- (void)setScreenObjects
{
    
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView setFrame:CGRectMake(50, 100, 320, 400)];
    self.CurrentPageBtn.backgroundColor=[UIColor clearColor];
    //SwankScoreLabel Display
   
    self.SwankScoreLabel.text = self.SwankScoreValue;
    self.SwankScoreLabel.textColor=[UIColor colorWithRed:0.0/255.0f green:120.0/255.0f blue:0.0/255.0f alpha:1.0];
    self.SwankScoreLabel.textAlignment =NSTextAlignmentCenter;
 
    //AVGPrice Label Display
    self.AvgPriceLabel.text=self.AvgPriceValue;
    self.AvgPriceLabel.textAlignment=NSTextAlignmentCenter;
    self.AvgPriceLabel.textColor=[UIColor blackColor];
    
    //TurnOverLabel Display
    self.TurnOverLabel.text = self.TurnOverValue;
    self.TurnOverLabel.textAlignment =NSTextAlignmentCenter;
    self.TurnOverLabel.textColor = [UIColor redColor];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_webView loadHTMLString:_dataObject baseURL:[NSURL URLWithString:@""]];
  //  self.SwankScoreLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 10,75, 40)];
   // self.AvgPriceLabel =[[UILabel alloc] initWithFrame:CGRectMake(80,10, 75, 40)];
   // [self.webView setFrame:CGRectMake(0, 100, 320, 468)];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  
  //  self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];

}


@end
