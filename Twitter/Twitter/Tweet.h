//
//  Tweet.h
//  Twitter
//
//  Created by Abhishek Nayani on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic) User *user;
@property (nonatomic) NSString *text;
@property (nonatomic) NSDate *timestamp;
@property (nonatomic) NSInteger retweetCount;
@property (nonatomic) NSInteger favoriteCount;
@property (nonatomic) BOOL retweeted;
@property (nonatomic) BOOL favorited;
@property (nonatomic) NSString *idStr;
@property (nonatomic) NSString *retweetIdStr;


- (id) initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;
- (BOOL) retweet;
- (BOOL) favorite;


+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
