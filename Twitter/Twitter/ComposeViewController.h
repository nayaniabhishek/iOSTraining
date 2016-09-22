//
//  ComposeViewController.h
//  Twitter
//
//  Created by Abhishek Nayani on 9/21/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@interface ComposeViewController : UIViewController

@property (nonatomic) Tweet *replyToTweet;

@end
