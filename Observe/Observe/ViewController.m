//
//  ViewController.m
//  Observe
//
//  Created by Patrick Wilson on 2/25/15.
//  Copyright (c) 2015 Patrick Wilson. All rights reserved.
//

#import "ViewController.h"
#import "FeedbackDraftViewController.h"
#import "UIColor+colorFromHexString.h"
#import <Parse/Parse.h>

@interface ViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadSubviews];
    [self autoLayoutSubviews];
}


- (void)loadSubviews {
    [self loadContentView];
    [self loadLoginButton];
}

- (void)loadContentView {
    CGRect frame = self.view.bounds;
    self.contentView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:self.contentView];
}

- (void)loadLoginButton{
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTintColor:[UIColor colorFromHexString:@"6C7A89"]];
    [self.loginButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:45]];
    [self.loginButton addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.loginButton];
}



- (void)autoLayoutSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // Label all views for autolayout
    NSDictionary *views = @{
                            @"loginButton"           :   self.loginButton
                            };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[loginButton]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[loginButton]-|" options:0 metrics:nil views:views]];

    
}

- (void)loginPressed:(UIButton*)button{
    //push the next screen
    
    PFUser *user = [PFUser user];
    user.username = @"pdubslax";
    user.password = @"swagmoney";
    user.email = @"pdubslax@umich.edu";
    
    // other fields can be set if you want to save more information
    user[@"phone"] = @"231-409-9896";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            FeedbackDraftViewController* vc = [FeedbackDraftViewController new];
            [self presentViewController:vc animated:YES completion:^{
                //
            }];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
        }
    }];
    
    
    
}




@end
