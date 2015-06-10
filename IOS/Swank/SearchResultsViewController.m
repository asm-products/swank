//
//  SearchResultsViewController.m
//  Swank
//
//  Created by Nik on 28/05/2015.
//  Copyright (c) 2015 Swank. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "NSString+FontAwesome.h"
#import "SearchResult.h"
#import "PageViewController.h"
#import "URLMaker.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchResultsViewController ()
    @property (nonatomic, strong) RLMResults *results;
@end

@implementation SearchResultsViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.screenName = @"Saved Searches Screen";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-BoldMT" size:20.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    [self.navigationItem setTitle:@"Saved Searches"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:96.0/255.f green:144.0/255.f blue:1.0/255.f alpha:1.0f];
    
    id backfont = [NSString fontAwesomeIconStringForEnum:FAChevronLeft];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:backfont style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *sizeLeft = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:22.0],NSFontAttributeName, nil];
    [leftButton setTitleTextAttributes:sizeLeft forState:UIControlStateNormal];
    
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = [self.searchBar.barTintColor CGColor];

    [self filter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Results

- (void)filter {
    
    NSString *property = nil;
    
    if (self.segmentedControl.selectedSegmentIndex < 2) {
        property = @"searchDate";
    } else {
        property = @"query";
    }
    
    BOOL ascending = NO;
    
    if (self.segmentedControl.selectedSegmentIndex == 1 || self.segmentedControl.selectedSegmentIndex == 2)
    {
        ascending = YES;
    }
    
    if (self.searchBar.text.length > 1)
    {
        self.results = [[SearchResult objectsWithPredicate:[NSPredicate predicateWithFormat:@"query CONTAINS[c] %@",self.searchBar.text]] sortedResultsUsingProperty:property ascending:ascending];
    } else {
        self.results = [[SearchResult allObjects] sortedResultsUsingProperty:property ascending:ascending];
    }
    
    [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)backAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Search

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    [self filter];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (IBAction)filterAction:(id)sender {
    [self filter];
}

#pragma mark - Tables

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    SearchResult *result = [self.results objectAtIndex:indexPath.row];

    cell.textLabel.text = result.query;
    
    NSString *condition;
    if ([result.condition isEqualToString:@"3000"]) {
        condition = @"U";
    } else if ([result.condition isEqualToString:@"1000"]) {
        condition = @"N";
    } else {
        condition = @"+";
    }
    
    NSString *listingType;
    if ([result.listingType isEqualToString:@"AO"]) {
        listingType = @"A";
    } else if ([result.listingType isEqualToString:@"ALL"]) {
        listingType = @"+";
    } else {
        listingType = @"B";
    }
    
    cell.detailTextLabel.text = [condition stringByAppendingFormat:@" / %@ / Price: %@ / T.O.: %@",listingType, result.averagePrice, result.turnover];

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:result.imageUrl]
                      placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:[self.results objectAtIndex:indexPath.row]];
    [realm commitWriteTransaction];
    
    [self filter];
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SearchResult *result = [self.results objectAtIndex:indexPath.row];
    
    NSString *url = [URLMaker encodedURLForQuery:result.query condition:result.condition listingType:result.listingType exact:result.exact];
    
    PageViewController *pageView = [self.storyboard instantiateViewControllerWithIdentifier:@"pageView"];
    pageView.sendUrl = url;
    pageView.query = result.query;
    pageView.condition = result.condition;
    pageView.listingType = result.listingType;
    pageView.cannotBeSaved = YES;

    [self.navigationController pushViewController:pageView animated:YES];
}

@end
