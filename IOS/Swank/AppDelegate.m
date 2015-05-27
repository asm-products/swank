//
//  AppDelegate.m
//  PDFView
//
//  Created by Admin on 12/2/14.
//  Copyright (c) 2014 youngjin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@implementation AppDelegate


- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad
        return UIInterfaceOrientationMaskAll;
    } else {
        // iPhone / iPod Touch
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString *urlString = [url absoluteString];
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-43102431-3"];
    
    // setCampaignParametersFromUrl: parses Google Analytics campaign ("UTM")
    // parameters from a string url into a Map that can be set on a Tracker.
    GAIDictionaryBuilder *hitParams = [[GAIDictionaryBuilder alloc] init];
    
    // Set campaign data on the map, not the tracker directly because it only
    // needs to be sent once.
    [[hitParams setCampaignParametersFromUrl:urlString] build];
    
    // Campaign source is the only required campaign field. If previous call
    // did not set a campaign source, use the hostname as a referrer instead.
    if(![hitParams valueForKey:kGAICampaignSource] && [url host].length !=0) {
        // Set campaign data on the map, not the tracker.
        [hitParams set:@"referrer" forKey:kGAICampaignMedium];
        [hitParams set:[url host] forKey:kGAICampaignSource];
    }
    
    NSDictionary *hitParamsDict = [hitParams build];
    
    // A screen name is required for a screen view.
    [tracker set:kGAIScreenName value:@"Menu Screen"];
    
    // Previous V3 SDK versions.
    // [tracker send:[[[GAIDictionaryBuilder createAppView] setAll:hitParamsDict] build]];
    
    // SDK Version 3.08 and up.
    [tracker send:[[[GAIDictionaryBuilder createScreenView] setAll:hitParamsDict] build]];
    
//    Alternatively, if you have campaign information in a form other than Google Analytics campaign parameters, you may set it on a NSDictionary and send it manually:
//        
//        // Assumes at least one tracker has already been initialized.
//        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    
//    // Note that it's not necessary to set kGAICampaignKeyword for this email campaign.
//    NSMutableDictionary *campaignData = [NSDictionary alloc dictionaryWithObjectsAndKeys:
//                                         @"email", kGAICampaignSource,
//                                         @"email_marketing", kGAICampaignMedium,
//                                         @"summer_campaign", kGAICampaignName,
//                                         @"email_variation1", kGAICampaignContent, nil];
//    
//    // A screen name is required for a screen view.
//    [tracker set:kGAIScreenName value:@"screen name"];
//    
//    // Note that the campaign data is set on the Dictionary, not the tracker.
//    // Previous V3 SDK versions.
//    // [tracker send:[[[GAIDictionaryBuilder createAppView] setAll:campaignData] build]];
//    
//    // SDK Version 3.08 and up.
//    [tracker send:[[[GAIDictionaryBuilder createScreenView] setAll:campaignData] build]];
    return true;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // [[GAI sharedInstance] setDryRun:YES];
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
#ifdef DEBUG
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
#endif
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-43102431-3"];
    
    // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Instantiate the initial view controller object from the storyboard
    //LoginViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
    ViewController *splashView = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"parentView"];
    
    // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Set the initial view controller to be the root view controller of the window object
    self.window.rootViewController  = splashView;
    
    // Set the window object to be the key window and show it
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
