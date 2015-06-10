//
//  SearchResultsViewController.h
//  Swank
//
//  Created by Nik on 28/05/2015.
//  Copyright (c) 2015 Swank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface SearchResultsViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,strong) IBOutlet UIView *filterBackground;

@end
