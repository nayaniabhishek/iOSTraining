//
//  TwitterClient.m
//  Twitter
//
//  Created by Abhishek Nayani on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"

@interface TwitterClient()

@property (nonatomic) void (^loginCompletion)(User *user, NSError *error);

@end


@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc]
                        initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"]
                        consumerKey:@"Au99SB1QpjYE7vhIZIXijQsdx"
                        consumerSecret:@"wRjD1Nm8ehqbZrgQaK57SatSZkeB3sPyquUOgKJOTbbHPp4QKa"];
        }
    });
    
    return instance;
}

- (void)login:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self deauthorize];
    
    [self
     fetchRequestTokenWithPath:@"oauth/request_token"
     method:@"GET"
     callbackURL:[NSURL URLWithString:@"mytwitterdemo://oauth"]
     scope:nil
     success:^(BDBOAuth1Credential *requestToken) {
         NSLog(@"Success: %@", requestToken);
         
         [[UIApplication sharedApplication]
          openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]]
          options:@{}
          completionHandler:nil];
         
     }
     failure:^(NSError *error) {
         completion(nil, error);
         NSLog(@"Error getting token: %@", error);
     }];
}

- (void)handleOpenUrl:(NSString *)url {
    BDBOAuth1Credential *credential = [BDBOAuth1Credential credentialWithQueryString:url];
    
    [self
     fetchAccessTokenWithPath:@"oauth/access_token"
     method:@"POST"
     requestToken:credential
     success:^(BDBOAuth1Credential *accessToken) {
         NSLog(@"Got AccessToken: %@", accessToken);
         
         [self.requestSerializer saveAccessToken:accessToken];
         
         [self currentAccount:nil completion:^(User *user, NSError *error) {
             if (user) {
                 [User setCurrentUser:user];
                 self.loginCompletion(user, nil);
             } else {
                 self.loginCompletion(nil, error);
             }
         }];
     } failure:^(NSError *error) {
         NSLog(@"Got Error trying to get accessToken");
         self.loginCompletion(nil, error);
     }];
    
}


- (void)currentAccount:(NSDictionary *)params completion:(void (^)(User *user, NSError *error))completion {
    [self
     GET:@"1.1/account/verify_credentials.json"
     parameters:params progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         User *user = [[User alloc] initWithDictionary:responseObject];
         completion(user, nil);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         completion(nil, error);
     }];
    
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self
     GET:@"1.1/statuses/home_timeline.json"
     parameters:params progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSArray *tweets = [Tweet tweetsWithArray:responseObject];
         
         completion(tweets, nil);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         completion(nil, error);
     }];
}

- (void)userTimelineWithParams:(NSDictionary *)params user:(User *)user completion:(void (^)(NSArray *tweets, NSError *error))completion {
    User *forUser = user ? user : [User currentUser];
    
    [self
     GET:[NSString stringWithFormat:@"1.1/statuses/user_timeline.json?include_rts=1&count=20&include_my_retweet=1&screen_name=%@", forUser.screenname]
     parameters:params progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self
     GET:@"1.1/statuses/mentions_timeline.json?include_my_retweet=1"
     parameters:params progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)sendTweetWithParams:(NSDictionary *)params text:text completion:(void (^)(NSString *, NSError *))completion {
    [self
     POST:[NSString stringWithFormat:@"1.1/statuses/update.json?status=%@", text]
     parameters:params progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         completion(responseObject[@"id_str"], nil);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         completion(nil, error);
     }];
}

- (void)retweetWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(NSString *, NSError *))completion {
    [self
     POST:[[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.idStr] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]
     parameters:params progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         completion(responseObject[@"id_str"], nil);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         completion(nil, error);
     }];
}

- (void)unretweetWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(NSError *error))completion {
    [self
     POST:[[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", tweet.retweetIdStr] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]
     parameters:params progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         completion(nil);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         completion(error);
     }];
}

- (void)favoriteWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(NSError *error))completion {
    [self
     POST:[[NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", tweet.idStr] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]
     parameters:params progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         completion(nil);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         completion(error);
     }];
}

- (void)unfavoriteWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(NSError *error))completion {
    [self
     POST:[[NSString stringWithFormat:@"1.1/favorites/destroy.json?id=%@", tweet.idStr] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]
     parameters:params progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         completion(nil);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         completion(error);
     }];
}


@end
