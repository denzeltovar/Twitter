//
//  ComposeViewController.m
//  twitter
//
//  Created by denzeltov on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//
#import "ComposeViewController.h"
#import"Tweet.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(IBAction)onTweet:(id)sender {
    [[APIManager shared]postStatusWithText: self.composeTextView.text completion: ^(Tweet *tweet, NSError *error){
            if(error){
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            }else{
                [self.delegate didTweet:tweet];
                NSLog(@"Tweet Success!");
            }
        [self dismissViewControllerAnimated:true completion:nil];
        }];
}

@end
