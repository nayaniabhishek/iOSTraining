//
//  MovieTableViewCell.h
//  Flicks
//
//  Created by Abhishek Nayani on 9/12/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

@end
