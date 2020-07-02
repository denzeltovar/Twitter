//
//  ComposeViewController.h
//  twitter
//
//  Created by denzeltov on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate <NSObject>
- (void)didTweet:(Tweet *)tweet;
@end

@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
