//
//  TableCell.h
//  Swank
//
//  Created by Nikita on 29/05/2015.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UILabel *mainLabel;
@property (nonatomic, weak) IBOutlet UIImageView *leftImage;

@end
