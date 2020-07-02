//
//  TwitterDetailsViewController.h
//  twitter
//
//  Created by denzeltov on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TwitterDetailsViewControllerDelegate <NSObject>
@end

@interface TwitterDetailsViewController : UIViewController
@property(nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<TwitterDetailsViewControllerDelegate> detailsDelegate;
@end

NS_ASSUME_NONNULL_END
