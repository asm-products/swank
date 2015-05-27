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

- (void)awakeFromNib
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Result Screen";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.automaticallyAdjustsScrollViewInsets = NO;
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-BoldMT" size:20.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    [self.navigationItem setTitle:@"Swank Search Result"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:96.0/255.f green:144.0/255.f blue:1.0/255.f alpha:1.0f];
    
    [self.segmentedControl addTarget:self action:@selector(segmentaction:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentedControl.layer.borderWidth = 1.0;
    self.segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.segmentedControl.layer setCornerRadius:12.0f];
    self.segmentedControl.layer.masksToBounds =YES;
    
    UIFont *font = [UIFont boldSystemFontOfSize:17.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes
                                         forState:UIControlStateNormal];
    
    self.responseResults= [[searchResults alloc]init];
    self.SearchResults =[[NSMutableArray alloc ]init];
    [self HttpGetRequestandReceive];
    
    UIBarButtonItem *list = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(saveItem:)];
    list.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:list];
    
}

- (void)saveItem:(id)sender
{

}

- (void)orientationChanged:(NSNotification *)notification
{
    [self layoutScrollView];
    [self ScrollTopage:pageNumber animated:NO];
}

- (void)layoutScrollView
{
    [self.UrlScrollView setContentSize:CGSizeMake(self.UrlScrollView.frame.size.width*self.pageContent.count, self.UrlScrollView.frame.size.height)];
    
    if (self.UrlScrollView.subviews.count)
    {
        
        for (int i=0;i<self.pageContent.count;i++)
        {
            UIWebView *webView = self.UrlScrollView.subviews[i];
            [webView setFrame:CGRectMake(i * self.UrlScrollView.frame.size.width, 0, self.UrlScrollView.frame.size.width, self.UrlScrollView.frame.size.height)];
//            [self scrollWebViewToBottom:webView];
        }
        
    }
}

-(void) setupScroolView
{
    [self layoutScrollView];
    for (int i=0;i<self.pageContent.count;i++)
    {
        CGFloat xOrigin = i*self.UrlScrollView.frame.size.width;
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(xOrigin,0, self.UrlScrollView.frame.size.width, self.UrlScrollView.frame.size.height)];
       [webView loadHTMLString:[self.pageString objectAtIndex:i] baseURL:[NSURL URLWithString:@""]];
        webView.contentMode = UIViewContentModeScaleAspectFit;
        webView.autoresizesSubviews = YES;
        webView.backgroundColor = [UIColor clearColor];
        webView.scrollView.bounces = NO;
        webView.scrollView.scrollEnabled = YES;
        webView.delegate = self;
        webView.scrollView.showsVerticalScrollIndicator = YES;
        [self.UrlScrollView addSubview:webView];
       
    }
    pageNumber = 1;
}

- (void)scrollWebViewToBottom:(UIWebView*)webView
{
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
    NSString* javascript = [NSString stringWithFormat:@"window.scrollBy(0, %li);", (long)height];
    [webView stringByEvaluatingJavaScriptFromString:javascript];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.segmentedControl.hidden)
    {
        [self updatePageControl];
        self.segmentedControl.hidden = NO;
    }
}

-(void) segmentaction:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex==0)
    {
        if (pageNumber > 1)
        {
            [self ScrollTopage:--pageNumber];
        }
    }
    else if (segment.selectedSegmentIndex == 2)
    {
        if (pageNumber < self.pageContent.count)
        {
            [self ScrollTopage:++pageNumber];
        }
        
    }
}
-(void) viewDidLayoutSubviews
{
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    id backfont = [NSString fontAwesomeIconStringForEnum:FAChevronLeft];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:backfont style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonClicked:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:22.0],NSFontAttributeName, nil];
    [leftButton setTitleTextAttributes:size forState:UIControlStateNormal];
}

- (void)leftButtonClicked:(id)sender
{
    UIViewController *uivc = self.presentingViewController;
    while (uivc) {
        [uivc dismissViewControllerAnimated:NO completion:nil];
        uivc = uivc.presentingViewController;
    }
}

-(void) createContentPages
{
    NSString *htmlfilePath = [[NSBundle mainBundle] pathForResource:@"webPage" ofType:@"html" inDirectory:nil];
    NSString  *contentString = [NSString stringWithContentsOfFile:htmlfilePath encoding:NSUTF8StringEncoding error:nil];
    
    self.pageString = [[NSMutableArray alloc]init];
    for (int i=0;i<self.SearchResults.count;i++)
    {
        self.contentResults = [self.SearchResults objectAtIndex:i];

        NSDateFormatter *dateFormatter =  [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *dateFromString = [dateFormatter dateFromString:self.contentResults._sold_date];
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        
        NSString *dateString = [dateFormatter stringFromDate:dateFromString];
        
        NSString *pageString = [contentString stringByReplacingOccurrencesOfString:@"http://xxx.xxxx" withString:self.contentResults._imageUrl];
        pageString = [pageString stringByReplacingOccurrencesOfString:@"this is a title" withString:self.contentResults._title];
        pageString = [pageString stringByReplacingOccurrencesOfString:@"this is a solddate" withString:dateString];
        pageString = [pageString stringByReplacingOccurrencesOfString:@"this is a price" withString:self.contentResults._sold_price];
        [self.pageString addObject:pageString];
    }
    _pageContent=[[NSArray alloc]initWithArray:self.pageString];
    self.SwankValue.text =self.contentResults._swank;
    self.avgPriceValue.text = self.contentResults._avg_price;
    self.turnOverValue.text = self.contentResults._turnover_rate;
    self.summaryContainer.hidden = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updatePageControl];
}

- (void)updatePageControl
{
    NSString *strPageNumber =[NSString stringWithFormat:@"%ld%@%lu",(long)pageNumber,@" / ",(unsigned long)self.SearchResults.count];
    [self.segmentedControl setTitle:strPageNumber forSegmentAtIndex:1];
}

- (void)ScrollTopage:(NSInteger)pageno animated:(BOOL)animated
{
    CGRect frame = CGRectMake((pageno-1) * self.UrlScrollView.frame.size.width,0,self.UrlScrollView.frame.size.width, self.UrlScrollView.frame.size.height);
    [self.UrlScrollView scrollRectToVisible:frame animated:animated];
}
-(void) ScrollTopage:(NSInteger)pageno
{
    [self ScrollTopage:pageno animated:YES];
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
    buyHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:buyHUD];
    buyHUD.animationType = 3;
    [buyHUD show:YES];
    
    
}
-(void)ResponsePassing:(NSMutableArray*)Data //parsing results of response
{
#ifdef DEBUG
    NSLog(@"%@",@"Passing Start");
#endif
    NSArray *results = nil;
    
    
    for (NSMutableDictionary *dic in Data)
    {
        //response status
#ifdef DEBUG
        NSString *status=dic[@"status"];
        NSLog(@"%@",status);
#endif
        
        //avg_price
        NSString *avg_price=dic[@"avg_price"];
#ifdef DEBUG
        NSLog(@"%@",avg_price);
#endif
        
        //swank_score
        NSString *swank_score=dic[@"swank_score"];
#ifdef DEBUG
        NSLog(@"%@",swank_score);
#endif
        
        //turnover_rate
        NSString *turnover_rate=dic[@"turnover_rate"];
#ifdef DEBUG
        NSLog(@"%@",turnover_rate);
#endif
        
        //results
        results= dic[@"results"];
        if (results.count>0)
        {
            for (NSMutableDictionary * dic1 in results)
            {
                //title
                NSString *title=dic1[@"title"];
#ifdef DEBUG
                NSLog(@"%@",title);
#endif
                //imageUrl
                NSString *imageUrl=[dic1 objectForKey:@"image"];
#ifdef DEBUG
                NSLog(@"%@",imageUrl);
#endif
                //sold_date
                NSString *sold_date=dic1[@"sold_date"];
#ifdef DEBUG
                NSLog(@"%@",sold_date);
#endif
                //sold_price
                NSString *sold_price=dic1[@"sold_price"];
#ifdef DEBUG
                NSLog(@"%@",sold_price);
#endif
                
                
                
                
                self.responseResults = [[searchResults alloc] initWithData:swank_score Setavg_score:avg_price Setturnover_rate:turnover_rate Settitle:title SetimageUrl:imageUrl Setsold_date:sold_date Setsold_price:sold_price];
#ifdef DEBUG
                NSLog(@"%@",self.responseResults._title);
#endif
                [self.SearchResults addObject:self.responseResults];
#ifdef DEBUG
                 NSLog(@"%@",self.SearchResults);
#endif
            }
        }
    }
}
-(void) HttpGetRequestandReceive
{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.sendUrl]];
    [self showWithGradient];
    [NSURLConnection sendAsynchronousRequest:request  queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *requestError)
     {
         if (requestError==nil)
         {
             
             NSMutableArray *responseParsing = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
#ifdef DEBUG
             NSLog(@"%@",responseParsing);
#endif
             for (NSMutableDictionary *dic in responseParsing)
             {
                 //response status
                  status=dic[@"status"];
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
