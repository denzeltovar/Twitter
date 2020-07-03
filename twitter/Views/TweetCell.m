//
//  TweetCell.m
//  twitter
//
//  Created by denzeltov on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "TimelineViewController.h"
#import "ResponsiveLabel.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)didTapRetweet:(id)sender {
    if(self.retweetButton.isSelected) {
        
        self.retweetButton.selected = NO;
        self.tweet.retweetCount -= 1;
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweet tweet: %@", error.localizedDescription);
            }else{
                NSLog(@"Successfully unretweeting the following tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.retweetButton.selected = YES;
        self.tweet.retweetCount += 1;
        
        [[APIManager shared]retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting Tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully retweeted the tweet: %@", tweet.text );
            }
        }];
    }
    self.tweet.retweeted = self.favoriteButton.selected;
    [self refreshData];
}

- (IBAction)didTapFavorite:(id)sender {
    if(self.favoriteButton.isSelected) {
        self.favoriteButton.selected = NO;
        self.tweet.favoriteCount -= 1;
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }else{
                NSLog(@"Successfully unfavorited the following tweet: %@", tweet.text);
            }
        }];
    }else{
        self.favoriteButton.selected = YES;
        self.tweet.favoriteCount += 1;
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting Tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully facorited the tweet: %@", tweet.text );
            }
        }];
    }
    self.tweet.favorited = self.favoriteButton.selected;
    [self refreshData];
}

-(void)refreshData {
    self.favoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateSelected];
    
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateSelected];
}
@end
