//
//  FeedbackDraftViewController.m
//  Observe
//
//  Created by Patrick Wilson on 2/25/15.
//  Copyright (c) 2015 Patrick Wilson. All rights reserved.
//

#import "FeedbackDraftViewController.h"
#import "ConfirmationViewController.h"
#import "UIColor+colorFromHexString.h"

@interface FeedbackDraftViewController ()


@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *submitButton;


@end

@implementation FeedbackDraftViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadSubviews];
    [self autoLayoutSubviews];
}


- (void)loadSubviews {
    [self loadContentView];
    [self loadSubmitButton];
}

- (void)loadContentView {
    CGRect frame = self.view.bounds;
    self.contentView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:self.contentView];
}

- (void)loadSubmitButton{
    self.submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.submitButton setTitle:@"Submit Feedback" forState:UIControlStateNormal];
    [self.submitButton setTintColor:[UIColor colorFromHexString:@"2ECC71"]];
    [self.submitButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    [self.submitButton addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.submitButton];
}



- (void)autoLayoutSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // Label all views for autolayout
    NSDictionary *views = @{
                            @"submitButton"           :   self.submitButton
                            };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[submitButton]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[submitButton]-20-|" options:0 metrics:nil views:views]];
    
    
}

- (void)submitPressed:(UIButton*)button{
    //push the next screen
    ConfirmationViewController* vc = [ConfirmationViewController new];
    [self presentViewController:vc animated:YES completion:^{
        //
    }];
    
}



@end
