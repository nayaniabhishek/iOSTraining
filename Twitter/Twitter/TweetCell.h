//
//  TweetCell.h
//  Twitter
//
//  Created by Abhishek Nayani on 9/20/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic) Tweet *tweet;

@end
