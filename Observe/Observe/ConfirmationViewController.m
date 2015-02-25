//
//  ConfirmationViewController.m
//  Observe
//
//  Created by Patrick Wilson on 2/25/15.
//  Copyright (c) 2015 Patrick Wilson. All rights reserved.
//

#import "ConfirmationViewController.h"
#import "FeedbackDraftViewController.h"
#import "UIColor+colorFromHexString.h"

@interface ConfirmationViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *thankYouButton;


@end

@implementation ConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadSubviews];
    [self autoLayoutSubviews];
}


- (void)loadSubviews {
    [self loadContentView];
    [self loadThankYouButton];
}

- (void)loadContentView {
    CGRect frame = self.view.bounds;
    self.contentView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:self.contentView];
}

- (void)loadThankYouButton{
    self.thankYouButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.thankYouButton setTitle:@"Thank you!" forState:UIControlStateNormal];
    [self.thankYouButton setTintColor:[UIColor colorFromHexString:@"4B77BE"]];
    [self.thankYouButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    [self.thankYouButton addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.thankYouButton];
}



- (void)autoLayoutSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // Label all views for autolayout
    NSDictionary *views = @{
                            @"thankYouButton"           :   self.thankYouButton
                            };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[thankYouButton]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[thankYouButton]-|" options:0 metrics:nil views:views]];
    
    
}

- (void)submitPressed:(UIButton*)button{
    FeedbackDraftViewController* vc = [FeedbackDraftViewController new];
    [self presentViewController:vc animated:YES completion:^{
        //
    }];
    
}

@end

