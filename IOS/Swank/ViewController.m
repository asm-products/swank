//
//  ViewController.m
//  Swank
//
//  Created by ??? on 1/27/15.
//  Copyright (c) 2015 Swank. All rights reserved.
//

#import "ViewController.h"
#import "NSString+FontAwesome.h"
#import "SearchResultsViewController.h"
#import "URLMaker.h"

@implementation ViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"Menu Screen";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    _KeywordText.text = @"Search";
    _KeywordText.textColor = [UIColor lightGrayColor];
    
    self.KeywordText.delegate =self;
    _KeywordText.layer.cornerRadius =2.0;
    _TrashBtn.hidden = YES;
    id searchPlus = [NSString fontAwesomeIconStringForEnum:FASearchPlus];
    id search = [NSString fontAwesomeIconStringForEnum:FASearch];
    id trash = [NSString fontAwesomeIconStringForEnum:FATimesCircle];
    [self.TrashBtn.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:23.f ]];
    [self.TrashBtn setTitle:[NSString stringWithFormat:@"%@",trash] forState:UIControlStateNormal] ;
    
    
    [self.ExtractSearchBtn.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:17.f ]];
    self.ExtractSearchBtn.layer.cornerRadius=15;
    
    [self.ExtractSearchBtn setTitle:[NSString stringWithFormat:@"%@%@",searchPlus,@" Exact"] forState:UIControlStateNormal] ;
    
    CAGradientLayer *gradientLayerExact = [CAGradientLayer layer];
    gradientLayerExact.frame = _ExtractSearchBtn.layer.bounds;
    
    gradientLayerExact.colors = [NSArray arrayWithObjects:
                                 (id)[UIColor colorWithRed:100/255.0f green:0/255.0f blue:2/255.0f alpha:0.1f].CGColor,
                                 (id)[UIColor colorWithRed:116/255.0f green:0/255.0f blue:2/255.0f alpha:0.1f].CGColor,                                                            nil];
    
    gradientLayerExact.locations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:1.0f],
                                    
                                    nil];
    
    gradientLayerExact.cornerRadius = _ExtractSearchBtn.layer.cornerRadius;
    // [_ExtractSearchBtn.layer addSublayer:gradientLayerExact];
    // self.ExtractSearchBtn.backgroundColor = [UIColor colorWithRed:113/255.0f green:126 /255.0f blue:2/255.0f alpha:1.0];
    /*
     self.ExtractSearchBtn.layer.borderColor = [UIColor whiteColor].CGColor;
     self.ExtractSearchBtn.layer.borderWidth =3.0;
     */
    self.normalButton.titleLabel.font=[UIFont fontWithName:kFontAwesomeFamilyName size:17.f];
    [self.normalButton setTitle:[NSString stringWithFormat:@"%@%@",search,@" Normal"] forState:UIControlStateNormal];
    self.normalButton.layer.cornerRadius=15;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _normalButton.layer.bounds;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:0.9f alpha:0.2f].CGColor,
                            (id)[UIColor colorWithWhite:0.9f alpha:0.7f].CGColor,
                            (id)[UIColor colorWithWhite:0.9f alpha:0.2f].CGColor,
                            nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               [NSNumber numberWithFloat:1.7f],
                               nil];
    
    gradientLayer.cornerRadius = _normalButton.layer.cornerRadius;
    //[_normalButton.layer addSublayer:gradientLayer];
    /*
     self.normalButton.layer.borderColor = [UIColor whiteColor].CGColor;
     self.normalButton.layer.borderWidth =3.0;*/
    //self.normalButton.backgroundColor = [UIColor colorWithRed:[self getColorValue:118] green:[self getColorValue:127] blue:[self getColorValue:2] alpha:1.0];
    ///
    //SegmentedControl height
    ///
    UIFont *font = [UIFont boldSystemFontOfSize:17.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.ConditionSetting setTitleTextAttributes:attributes
                                         forState:UIControlStateNormal];
    [self.ListingTypeSetting setTitleTextAttributes:attributes
                                           forState:UIControlStateNormal];
    
    
    ///
    //Navigation Bar font
    ///
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-BoldMT" size:20.0],NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    [self.navigationItem setTitle:@"Swank Search"];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:96.0/255.0f green:144.0/255.0f blue:1.0/255.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.ListingTypeSetting.selectedSegmentIndex=1;
    self.ConditionSetting.selectedSegmentIndex=0;
    self.Condition=@"3000";
    self.ListingType=@"BIN";

}

- (IBAction)showList:(id)sender
{
    SearchResultsViewController *searches = [self.storyboard instantiateViewControllerWithIdentifier:@"searchView"];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searches];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)performSearch:(BOOL)exact
{
    if ([self.KeywordText.text  isEqualToString:@""] || [self.KeywordText.text isEqualToString:@"Search"])
    {
        return;
    }
    
    NSString *url = [URLMaker encodedURLForQuery:self.KeywordText.text condition:self.Condition listingType:self.ListingType exact:exact];
    
#ifdef DEBUG
    NSLog(@"%@",url);
#endif
    
    PageViewController *pageView = [self.storyboard instantiateViewControllerWithIdentifier:@"pageView"];
    pageView.sendUrl = url;
    pageView.query = self.KeywordText.text;
    pageView.condition = self.Condition;
    pageView.listingType = self.ListingType;
    pageView.exact = exact;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pageView];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)ExtractSearchClick:(id)sender
{
    [self performSearch:YES];
}

- (IBAction)normalClick:(id)sender
{
    [self performSearch:NO];
}
- (IBAction)BarcodesearchBtn_Click:(id)sender
{
    ScannerViewController *scannerView = [self.storyboard instantiateViewControllerWithIdentifier:@"ScannerViewID"];
    scannerView.Condition = @"1";
    scannerView.listingType = @"ALL";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scannerView];
    nav.title = @"Barcode Scanner";
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)KeywordDeleteClick:(id)sender {
    _KeywordText.text = @"";
    _TrashBtn.hidden = YES;
}


- (IBAction)ConditionIndexChanged:(id)sender {
    switch (self.ConditionSetting.selectedSegmentIndex) {
        case 0:
            self.Condition=@"3000";
            break;
        case 1:
            self.Condition=@"1000";
            break;
        case 2:
            self.Condition=@"1";
            break;
            
        default:
            break;
    }
}
- (IBAction)ListingIndexChanged:(id)sender {
    switch (self.ListingTypeSetting.selectedSegmentIndex) {
        case 0:
            self.ListingType=@"AO";
            break;
        case 1:
            self.ListingType=@"BIN";
            break;
        case 2:
            self.ListingType=@"ALL";
            break;
            
        default:
            break;
    }
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    //[textField becomeFirstResponder];
    [textField resignFirstResponder];
    //
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(_KeywordText.text.length > 0 && _KeywordText.textColor == [UIColor blackColor])
        return YES;
    
    _KeywordText.text = @"";
    _KeywordText.textColor = [UIColor blackColor];
    return YES;
}
-(void) textViewDidChange:(UITextView *)textView
{
    if(_KeywordText.text.length == 0){
        _KeywordText.textColor = [UIColor lightGrayColor];
        _KeywordText.text = @"Search";
        [_KeywordText resignFirstResponder];
    }
    if (_KeywordText.text.length >0)
    {
        _TrashBtn.hidden = NO;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        _TrashBtn.hidden = YES;
        return NO;
    }
    return YES;
}
-(float)getColorValue:(float)colorVal
{
    return colorVal/255;
}
@end
