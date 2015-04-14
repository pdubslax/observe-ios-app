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
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:@"15BF73"];
    //lighter shade is 4DF5D0
    [self loadSubviews];
    [self autoLayoutSubviews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.textView resignFirstResponder];
    [self.textView2 resignFirstResponder];
    
}


- (void)loadSubviews {
    [self loadContentView];
    [self loadLoginButton];
    [self loadEmailText];
}

- (void)loadEmailText{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 250, self.contentView.frame.size.width-100, 40)];
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.textColor = [UIColor grayColor];
    self.textView.text = @"Email";
    self.textView.font = [UIFont fontWithName:@"Helvetica" size:25];
    [self.contentView addSubview:self.textView];
    
    self.textView2 = [[UITextView alloc] initWithFrame:CGRectMake(50, 330, self.contentView.frame.size.width-100, 40)];
    self.textView2.returnKeyType = UIReturnKeyDone;
    self.textView2.textColor = [UIColor grayColor];
    self.textView2.text = @"Password";
    self.textView2.font = [UIFont fontWithName:@"Helvetica" size:25];
    [self.contentView addSubview:self.textView2];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button1 setTitle:@"Log In" forState:UIControlStateNormal];
    [self.button1 setTintColor:[UIColor whiteColor]];
    [self.button1.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:30]];
    [self.contentView addSubview:self.button1];
    [[self.button1 layer] setBorderWidth:2.0f];
    [[self.button1 layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button2 setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.button2 setTintColor:[UIColor whiteColor]];
    [self.button2.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:30]];
    [self.contentView addSubview:self.button2];
    [[self.button2 layer] setBorderWidth:2.0f];
    [[self.button2 layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.button1 addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

- (void)loadContentView {
    CGRect frame = self.view.bounds;
    self.contentView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:self.contentView];
}

- (void)loadLoginButton{
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton setTitle:@"Observe" forState:UIControlStateNormal];
    [self.loginButton setTintColor:[UIColor whiteColor]];
    [self.loginButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:50]];
    //[self.loginButton addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setUserInteractionEnabled:NO];
    [self.contentView addSubview:self.loginButton];
}



- (void)autoLayoutSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // Label all views for autolayout
    NSDictionary *views = @{
                            @"loginButton"           :   self.loginButton,
                            @"textView"              :   self.textView,
                            @"button1" : self.button1,
                            @"button2" : self.button2
                            };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[loginButton]-40-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[loginButton]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[button1]-120-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-420-[button1]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[button2]-120-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button1]-40-[button2]" options:0 metrics:nil views:views]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView]-|" options:0 metrics:nil views:views]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView]-200-|" options:0 metrics:nil views:views]];

    
}

- (void)loginPressed:(UIButton*)button{
    //push the next screen
    
    PFUser *user = [PFUser user];
    user.username = @"pdubslax";
    user.password = self.textView2.text;
    user.email = self.textView.text;
    
    [PFUser logInWithUsernameInBackground:user.username password:user.password block:^(PFUser *user, NSError *error) {
        //
        FeedbackDraftViewController* vc = [FeedbackDraftViewController new];
        [self presentViewController:vc animated:YES completion:^{
            //
        }];
    }];
}

- (void)signUpPressed:(UIButton*)button{
    
}




@end
