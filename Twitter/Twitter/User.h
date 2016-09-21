//
//  User.h
//  Twitter
//
//  Created by Abhishek Nayani on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *screenname;
@property (nonatomic) NSURL *profileUrl;
@property (nonatomic) NSString *tagline;
@property (nonatomic) NSInteger tweetCount;
@property (nonatomic) NSInteger friendCount;
@property (nonatomic) NSInteger followerCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

@end
