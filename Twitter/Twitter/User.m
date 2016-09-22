//
//  User.m
//  Twitter
//
//  Created by Abhishek Nayani on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString* const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User()
@property (nonatomic) NSDictionary *dictionary;
@end

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenname = [NSString stringWithFormat:@"@%@", dictionary[@"screen_name"]];
        self.tagline = dictionary[@"description"];
        self.tweetCount = [dictionary[@"statuses_count"] integerValue];
        self.friendCount = [dictionary[@"friends_count"] integerValue];
        self.followerCount = [dictionary[@"followers_count"] integerValue];

        
        if ([dictionary[@"profile_image_url_https"] length] > 0) {
            self.profileUrl = [NSURL URLWithString:dictionary[@"profile_image_url_https"]];
        }

        if ([dictionary[@"profile_banner_url"] length] > 0) {
            self.bannerUrl = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        } else if ([dictionary[@"profile_background_image_url_https"] length] > 0) {
            self.bannerUrl = [NSURL URLWithString:dictionary[@"profile_background_image_url_https"]];
        }

    }
    
    return self;
}

- (NSString *)description {
    return self.dictionary.description;
}

static User *_currentUser = nil;

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [userDefaults setObject:data forKey:@"currentUser"];
    } else {
        [userDefaults setObject:nil forKey:@"currentUser"];
    }
    
    _currentUser = currentUser;
    
    [userDefaults synchronize];
}

+ (void)logout {
    NSLog(@"Starting LOgout");
    [self setCurrentUser:nil];
    [[TwitterClient sharedInstance] deauthorize];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}


@end
