//
//  TwitterClient.h
//  Twitter
//
//  Created by Abhishek Nayani on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <BDBOAuth1SessionManager.h>
#import "User.h"

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *)sharedInstance;

- (void)login:(void (^)(User *user, NSError *error))completion;
- (void)handleOpenUrl:(NSString *)url;
- (void)currentAccount:(NSDictionary *)params completion:(void (^)(User *user, NSError *error))completion;
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)sendTweetWithParams:(NSDictionary *)params text:text completion:(void (^)(NSString *, NSError *))completion;
@end
