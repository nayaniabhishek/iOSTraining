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

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic) NSInteger retweetCount;
@property (nonatomic) NSInteger favoriteCount;

- (id) initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)description;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
