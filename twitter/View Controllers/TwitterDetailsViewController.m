//
//  TwitterDetailsViewController.m
//  twitter
//
//  Created by denzeltov on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//
#import "TwitterDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "ResponsiveLabel.h"

@interface TwitterDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@end

@implementation TwitterDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userNameLabel.text = self.tweet.user.name;
    self.userScreenNameLabel.text = self.tweet.user.screenName;
    self.timeStampLabel.text = self.tweet.shortTimeAgo;
    self.tweetTextLabel.text = self.tweet.text;
    self.retweetButton.selected = self.tweet.retweeted;
    self.favoriteButton.selected = self.tweet.favorited;
    self.replyButton.selected = self.tweet.replyCount;
    
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.replyLabel.text = [NSString stringWithFormat:@"%d", self.tweet.replyCount];
    
    NSURL *profileImageURL =[NSURL URLWithString:self.tweet.user.profileImage];
    [self.userProfileImage setImageWithURL:profileImageURL];
    [self refreshData];
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

