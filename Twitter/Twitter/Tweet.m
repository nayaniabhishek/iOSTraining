//
//  Tweet.m
//  Twitter
//
//  Created by Abhishek Nayani on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "Tweet.h"

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

@end
