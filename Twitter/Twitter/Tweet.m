//
//  Tweet.m
//  Twitter
//
//  Created by Abhishek Nayani on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"

@interface Tweet()
@property (nonatomic) NSDictionary *dictionary;
@end

@implementation Tweet

- (id) initWithDictionary:(NSDictionary *)dictionary  {
    self = [super init];
    
    if (self) {
        self.dictionary = dictionary;
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        
        NSString *timestampString = dictionary[@"created_at"];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        self.timestamp = [dateformatter dateFromString:timestampString];
        
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];

        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favorited = [dictionary[@"favorited"] boolValue];

        self.idStr = dictionary[@"id_str"];
    }
    return self;
}

- (NSString *)description {
    return self.dictionary.description;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

- (BOOL)retweet {
    self.retweeted = !self.retweeted;
    if (self.retweeted) {
        self.retweetCount++;
        // retweet
        [[TwitterClient sharedInstance] retweetWithParams:nil tweet:self completion:^(NSString *retweetIdStr, NSError *error) {
            if (error) {
                NSLog(@"Retweet failed");
            } else {
                NSLog(@"Retweet successful, retweet_id_str: %@", retweetIdStr);
                // set retweet id string so it can be unretweeted
                self.retweetIdStr = retweetIdStr;
            }
        }];
    } else {
        self.retweetCount--;
        // unretweet
        [[TwitterClient sharedInstance] unretweetWithParams:nil tweet:self completion:^(NSError *error) {
            if (error) {
                NSLog(@"Unretweet failed");
            } else {
                NSLog(@"Unretweet successful");
            }
        }];
    }
    
    return self.retweeted;
}

- (BOOL)favorite {
    self.favorited = !self.favorited;
    if (self.favorited) {
        self.favoriteCount++;
        // favorite
        [[TwitterClient sharedInstance] favoriteWithParams:nil tweet:self completion:^(NSError *error) {
            if (error) {
                NSLog(@"Favorite failed");
            } else {
                NSLog(@"Favorite successful");
            }
        }];
    } else {
        self.favoriteCount--;
        // unfavorite
        [[TwitterClient sharedInstance] unfavoriteWithParams:nil tweet:self completion:^(NSError *error) {
            if (error) {
                NSLog(@"Unfavorite failed");
            } else {
                NSLog(@"Unfavorite successful");
            }
        }];
    }
    
    return self.favorited;
}

@end
