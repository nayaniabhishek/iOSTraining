//
//  TweetCell.m
//  Twitter
//
//  Created by Abhishek Nayani on 9/20/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    NSLog(@"Tweet: %@", tweet);
    
    self.nameLabel.text = tweet.user.name;
    self.handleLabel.text = tweet.user.screenname;
    self.messageLabel.text = tweet.text;
    [self.profileImage setImageWithURL:tweet.user.profileUrl];
    
    // show relative time since now if 24 hours or more has elapsed
    NSTimeInterval secondsSinceTweet = -[tweet.timestamp timeIntervalSinceNow];
    
    if (secondsSinceTweet >= 86400) {
        // show month, day, and year
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"M/d/yy"];
        self.dateLabel.text = [dateFormat stringFromDate:tweet.timestamp];
    } else if (secondsSinceTweet >= 3600) {
        // show hours
        self.dateLabel.text = [NSString stringWithFormat:@"%.0fh", secondsSinceTweet/3600];
    } else if (secondsSinceTweet >= 60){
        // show minutes
        self.dateLabel.text = [NSString stringWithFormat:@"%.0fm", secondsSinceTweet/60];
    } else {
        // show seconds
        self.dateLabel.text = [NSString stringWithFormat:@"%.0fs", secondsSinceTweet];
    }

}

@end
