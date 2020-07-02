//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"
#import "ResponsiveLabel.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;
//Home Timeline
- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;
//Compose View Controller
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;
//Tweet Cell
-(void)favorite: (Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
-(void)unfavorite: (Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
-(void)retweet: (Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
-(void)unretweet: (Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
@end
