//
//  Tweet.h
//  twitter
//
//  Created by denzeltov on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
// Gets properties from User.h file
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSObject


// MARK: Properties
@property (nonatomic, strong) NSString *idStr; // For favoriting, retweeting & replying
@property (nonatomic, strong) NSString *text; // Text content of tweet
@property (nonatomic) int favoriteCount; // Update favorite count label
@property (nonatomic) BOOL favorited; // Configure favorite button
@property (nonatomic) int retweetCount; // Update favorite count label
@property (nonatomic) BOOL retweeted; // Configure retweet button
@property (nonatomic, strong) User *user; // Contains Tweet author's name, screenname, etc.
@property (nonatomic, strong) NSString *createdAtString; // Display date
@property (nonatomic) int replyCount; // Update favorite count label
@property (nonatomic, strong) NSString *shortTimeAgo;


@property (nonatomic, strong) User *retweetedByUser;  // user who retweeted if tweet is retweet

-(instancetype) initWithDictionary: (NSDictionary *)dictionary;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries;
@end

NS_ASSUME_NONNULL_END
