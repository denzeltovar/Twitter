//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//
#import "TwitterDetailsViewController.h"
#import "TimelineViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "Tweet.h"
#import"ComposeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, TwitterDetailsViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tweets;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

@end


@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweets = (NSMutableArray *)tweets;
            NSLog(@"%@", self.tweets);
        }
        else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

-(void)fetchTweets {
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Networking Error"
                                                                           message:@"Could not connect to Network. Press \"OK\" to try again"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
            }];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@" , dataDictionary);
            self.tweets = dataDictionary[@"user"];
            for (Tweet *tweet in self.tweets) {
                NSLog(@"%@", tweet.text);
            }
            [self.tableView reloadData];
        }
        
        [self.refreshControl endRefreshing];
    }];
    [task resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

-(nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier: @"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.tweet = tweet;
    cell.userNameLabel.text = tweet.user.name;
    cell.userScreenNameLabel.text = tweet.user.screenName;
    cell.timeStampLabel.text = tweet.shortTimeAgo;
    cell.tweetTextLabel.text = tweet.text;
    
    
    cell.replyLabel.text = [NSString stringWithFormat:@"%d", tweet.replyCount];
    cell.favoriteLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    cell.retweetLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    
    NSURL *profileImageURL =[NSURL URLWithString:tweet.user.profileImage];
    [cell.userProfileImage setImageWithURL:profileImageURL];
    return cell;
}

- (IBAction)didTapLogout:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"composeTweet"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"detailsView"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell: tappedCell];
        
        Tweet *tweet = self.tweets[indexPath.row];
        TwitterDetailsViewController *twitterDetailsViewConroller = [segue destinationViewController];
        twitterDetailsViewConroller.tweet = tweet;
        twitterDetailsViewConroller.detailsDelegate = self;
        twitterDetailsViewConroller = indexPath;
        
    }
}

-(void) didTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}
@end

