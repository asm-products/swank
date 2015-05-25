//
//  PageViewController.m
//  PDFView
//
//  Created by Admin on 03/12/14.
//  Copyright (c) 2014 youngjin. All rights reserved.
//

#import "PageViewController.h"
#import "MBProgressHUD.h"
#import "ViewController.h"
#import "NSString+FontAwesome.h"
CGPoint currentPos;
NSInteger pageNumber;
UILabel *SwankValue;
UILabel *avgPriceValue;
UILabel *turnOverValue;
NSString *status;
@interface PageViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *buyHUD;
}
@end

@implementation PageViewController

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
    self.screenName = @"Result Screen";
    
    self.responseResults= [[searchResults alloc]init];
    self.SearchResults =[[NSMutableArray alloc ]init];
    [self HttpGetRequestandReceive];
    
}
-(void) SetupLabel
{
    UIFont *font = [UIFont boldSystemFontOfSize:17.0f];
    UILabel *SwankLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 70, 80, 20)];
    SwankLabel.text = @"SWANK";
    SwankLabel.textAlignment= NSTextAlignmentCenter;
    SwankLabel.textColor = [UIColor colorWithRed:0.0/255.0f  green:120.0/255.0f blue:0.0/255.0f alpha:1.0];
    SwankLabel.font =font;
    [self.view addSubview:SwankLabel];
    
    SwankValue =[[UILabel alloc] initWithFrame:CGRectMake(10, 95, 80, 20)];
   
    SwankValue.textAlignment= NSTextAlignmentCenter;
    SwankValue.textColor = [UIColor colorWithRed:0.0/255.0f  green:120.0/255.0f blue:0.0/255.0f alpha:1.0];
    SwankValue.font = font;
    [self.view addSubview:SwankValue];
    
    UILabel *BetweenLabel1 =[[UILabel alloc] initWithFrame:CGRectMake(92, 80, 2 , 30)];
    BetweenLabel1.text = @"";
    BetweenLabel1.textAlignment= NSTextAlignmentCenter;
    BetweenLabel1.backgroundColor = [UIColor blackColor];
    [self.view addSubview:BetweenLabel1];
    UILabel *AvgLabel =[[UILabel alloc] initWithFrame:CGRectMake(97, 70, 100, 20)];
    AvgLabel.text = @"AVG PRICE";
    AvgLabel.textAlignment= NSTextAlignmentCenter;
    AvgLabel.textColor = [UIColor blackColor];
    AvgLabel.font =font;
    [self.view addSubview:AvgLabel];
    
    avgPriceValue = [[UILabel alloc] initWithFrame:CGRectMake(97,95, 100, 20)];
    avgPriceValue.textAlignment = NSTextAlignmentCenter;
    avgPriceValue.textColor = [UIColor blackColor];
    avgPriceValue.font = font;
    [self.view addSubview:avgPriceValue];
    
    UILabel *BetweenLabel2 =[[UILabel alloc] initWithFrame:CGRectMake(202, 80, 2 , 30)];
    BetweenLabel2.text = @"";
    BetweenLabel2.textAlignment= NSTextAlignmentCenter;
    BetweenLabel2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:BetweenLabel2];
    
    UILabel *Turnover =[[UILabel alloc] initWithFrame:CGRectMake(210, 70, 100, 20)];
    Turnover.text = @"TURNOVER";
    Turnover.textAlignment= NSTextAlignmentCenter;
    Turnover.textColor = [UIColor blackColor];
    Turnover.font =font;
    [self.view addSubview:Turnover];
    
    turnOverValue = [[UILabel alloc] initWithFrame:CGRectMake(210, 95, 100, 20)];
    turnOverValue.textColor = [UIColor blackColor];
    turnOverValue.textAlignment =NSTextAlignmentCenter;
    turnOverValue.font = font;
    [self.view addSubview:turnOverValue];
}

-(void) setupScroolView
{
    
    
    self.UrlScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    self.UrlScrollView.pagingEnabled = YES;
    self.UrlScrollView.delegate = self;
    [self.UrlScrollView setAlwaysBounceHorizontal:NO];
    for (int i=0;i<self.pageContent.count;i++)
    {
        /*
        searchResults *image = [self.SearchResults objectAtIndex:i];
        NSURL *imgurl = [NSURL URLWithString:image._imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:imgurl];
        UIImage *img = [[UIImage alloc] initWithData:data ];
        CGSize siize = img.size;
        */
        CGFloat xOrigin = i*self.view.frame.size.width;
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(xOrigin,120, self.view.frame.size.width, self.view.frame.size.height-120)];
       [webView loadHTMLString:[self.pageString objectAtIndex:i] baseURL:[NSURL URLWithString:@""]];
        webView.contentMode = UIViewContentModeScaleAspectFit;
        webView.backgroundColor = [UIColor clearColor];
        webView.scrollView.bounces = NO;
        webView.scrollView.scrollEnabled = YES;
     //   webView.scrollView.contentSize =CGSizeMake(self.view.frame.size.width, (siize.height)*self.view.frame.size.width/siize.width+180);
     //   NSLog(@"%f%f",self.view.frame.size.width,siize.height*self.view.frame.size.width/siize.width);
     //   NSLog(@"%f%f",siize.width,siize.height);
        webView.scrollView.showsVerticalScrollIndicator = YES;
        [self.UrlScrollView addSubview:webView];
       
    }
    
    self.UrlScrollView.contentSize = CGSizeMake(self.view.frame.size.width*self.pageContent.count, self.view.frame.size.height-180)
    ;
    [self.view addSubview:self.UrlScrollView];
    NSString *currentPageDisp =  [NSString stringWithFormat:@"%@%lu",@"1 / ",(unsigned long)self.SearchResults.count];
    
    NSArray *itemArray = [NSArray arrayWithObjects:@"<",currentPageDisp,@">", nil];
    pageNumber = 1;
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.segmentedControl.frame = CGRectMake(70, self.view.frame.size.height-48, 180, 30);
    [self.segmentedControl addTarget:self action:@selector(segmentaction:) forControlEvents:UIControlEventValueChanged];
    //self.segmentedControl.selectedSegmentIndex=1;
    self.segmentedControl.backgroundColor = [UIColor blackColor ];
    self.segmentedControl.tintColor = [UIColor whiteColor];
    self.segmentedControl.layer.borderWidth = 1.0;
    self.segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.segmentedControl.layer setCornerRadius:12.0f];
    self.segmentedControl.layer.masksToBounds =YES;
    self.segmentedControl.momentary =YES;
    UIFont *font = [UIFont boldSystemFontOfSize:17.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes
                                         forState:UIControlStateNormal];
    [self.view addSubview:self.segmentedControl];

}

-(void) segmentaction:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex==0)
    {
        [self ScrollTopage:pageNumber-1];
    }
    else if (segment.selectedSegmentIndex == 2)
    {
        [self ScrollTopage:pageNumber+1];
    }
   // self.segmentedControl.selectedSegmentIndex = 1;
    [[segment.subviews objectAtIndex:1] setTintColor:[UIColor whiteColor]];
    [[segment.subviews objectAtIndex:1] setBackgroundColor:[UIColor blackColor]];
}
-(void) viewDidLayoutSubviews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-BoldMT" size:20.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
   [self.navigationItem setTitle:@"Swank Search Result"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:96.0/255.f green:144.0/255.f blue:1.0/255.f alpha:1.0f];
}

-(void)viewWillAppear:(BOOL)animated
{
    id backfont = [NSString fontAwesomeIconStringForEnum:FAChevronLeft];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:backfont style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonClicked:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:22.0],NSFontAttributeName, nil];
    [leftButton setTitleTextAttributes:size forState:UIControlStateNormal];
    self.UrlScrollView.showsHorizontalScrollIndicator = YES;
    self.UrlScrollView.showsVerticalScrollIndicator = NO;
    self.UrlScrollView.bounces = NO;
}

- (void)leftButtonClicked:(id)sender
{
    UIViewController *uivc = self.presentingViewController;
    while (uivc) {
        [uivc dismissViewControllerAnimated:NO completion:nil];
        uivc = uivc.presentingViewController;
    }

   // [self dismissViewControllerAnimated:YES completion:^{ }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) createContentPages
{
    
    self.pageString = [[NSMutableArray alloc]init];
    for (int i=0;i<self.SearchResults.count;i++)
    {
        self.contentResults = [self.SearchResults objectAtIndex:i];
        NSString *htmlfilePath = [[NSBundle mainBundle] pathForResource:@"webPage" ofType:@"html" inDirectory:nil];
        NSString  *contentString = [NSString stringWithContentsOfFile:htmlfilePath encoding:NSUTF8StringEncoding error:nil];
        NSDateFormatter *dateFormatter =  [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:self.contentResults._sold_date];
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:dateFromString];
        
        contentString = [contentString stringByReplacingOccurrencesOfString:@"http://xxx.xxxx" withString:self.contentResults._imageUrl];
        contentString = [contentString stringByReplacingOccurrencesOfString:@"this is a title" withString:self.contentResults._title];
        contentString = [contentString stringByReplacingOccurrencesOfString:@"this is a solddate" withString:dateString];
        contentString = [contentString stringByReplacingOccurrencesOfString:@"this is a price" withString:self.contentResults._sold_price];
        [self.pageString addObject:contentString];
    }
    _pageContent=[[NSArray alloc]initWithArray:self.pageString];
    SwankValue.text =self.contentResults._swank;
    avgPriceValue.text = self.contentResults._avg_price;
    turnOverValue.text = self.contentResults._turnover_rate;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     pageNumber = (NSInteger) floor( (self.UrlScrollView.contentOffset.x + self.view.frame.size.width /2)/self.view.frame.size.width) +1;
    //self.segmentedControl.selectedSegmentIndex=1;
    NSString *strPageNumber =[NSString stringWithFormat:@"%ld%@%lu",(long)pageNumber,@" / ",(unsigned long)self.SearchResults.count];
    [self.segmentedControl setTitle:strPageNumber forSegmentAtIndex:1];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  //  if (self.UrlScrollView.contentOffset.x ==)
}
-(void) ScrollTopage:(NSInteger)pageno
{
    CGRect frame = CGRectMake((pageno-1) *self.view.frame.size.width ,0,self.view.frame.size.width, self.view.frame.size.height);
    [self.UrlScrollView scrollRectToVisible:frame animated:YES];
}
- (void)removeWithGradient
{
    if(buyHUD!=nil)
    {
        [buyHUD hide:YES];
        [buyHUD removeFromSuperview];
    }
    
}

- (void)showWithGradient
{
    
    //[self removeWithGradient];
    buyHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:buyHUD];
     //buyHUD.dimBackground = YES;
    buyHUD.animationType = 3;
    [buyHUD show:YES];
    
    
}
-(void)ResponsePassing:(NSMutableArray*)Data //parsing results of response
{
    NSLog(@"%@",@"Passing Start");
    NSMutableArray *results = [[NSMutableArray alloc]init];
    
    
    for (NSMutableDictionary *dic in Data)
    {
        //response status
       // NSString *status=dic[@"status"];
        //NSLog(@"%@",status);
        
        //avg_price
        NSString *avg_price=dic[@"avg_price"];
        NSLog(@"%@",avg_price);
        
        //swank_score
        NSString *swank_score=dic[@"swank_score"];
        NSLog(@"%@",swank_score);
        
        //turnover_rate
        NSString *turnover_rate=dic[@"turnover_rate"];
        NSLog(@"%@",turnover_rate);
        
        //results
        results= dic[@"results"];
        if (results.count>0)
        {
            for (NSMutableDictionary * dic1 in results)
            {
                //title
                NSString *title=dic1[@"title"];
                NSLog(@"%@",title);
                //imageUrl
                NSString *imageUrl=[dic1 objectForKey:@"image"];
                NSLog(@"%@",imageUrl);
                //sold_date
                NSString *sold_date=dic1[@"sold_date"];
                NSLog(@"%@",sold_date);
                //sold_price
                NSString *sold_price=dic1[@"sold_price"];
                NSLog(@"%@",sold_price);
                
                
                
                
                self.responseResults = [[searchResults alloc] initWithData:swank_score Setavg_score:avg_price Setturnover_rate:turnover_rate Settitle:title SetimageUrl:imageUrl Setsold_date:sold_date Setsold_price:sold_price];
                NSLog(@"%@",self.responseResults._title);
                [self.SearchResults addObject:self.responseResults];
                // NSLog(@"%@",self.SearchResults);
            }
        }
    }
}
-(void) HttpGetRequestandReceive
{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.sendUrl]];
    //[request setHTTPMethod:@"GET"];
    [self showWithGradient];
    [NSURLConnection sendAsynchronousRequest:request  queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *requestError)
     {
         //[self removeWithGradient];
         if (requestError==nil)
         {
             
             NSMutableArray *responseParsing = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
             NSLog(@"%@",responseParsing);
             for (NSMutableDictionary *dic in responseParsing)
             {
                 //response status
                  status=dic[@"status"];
                 NSLog(@"%@",status);
             }
             
             if (responseParsing==nil || ![status  isEqualToString:@"200" ] )
             {
                 
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Search Failure!"
                                                                   message:@"There is no search result.Please try again. "
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:@"Retry",nil];
                 [self removeWithGradient];
                 [message show];
             }
             else
             {
                 
                 
                 [self ResponsePassing:responseParsing];
                 [self removeWithGradient];
                 [self SetupLabel];
                 [self createContentPages];
                 [self setupScroolView];

             }
             
         }
         else{
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Can not connect server. No network connection."
                                                               message:requestError.localizedDescription
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Retry",nil];
             [self removeWithGradient];
             [message show];
         }
         
        }];
}
@end
