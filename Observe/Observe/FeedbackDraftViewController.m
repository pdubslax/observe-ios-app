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
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "ChooseViewController.h"
#import "SharedManager.h"

@interface FeedbackDraftViewController () <UITextViewDelegate, CLLocationManagerDelegate>


@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UITextView *inputField;
@property (nonatomic, strong) UILabel *observeLogo;
@property (nonatomic, strong) NSLayoutConstraint *textHeight;
@property (nonatomic, strong) NSLayoutConstraint *buttonHeight;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locationResults;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (nonatomic) BOOL done;
@property (nonatomic) BOOL newFeedback;




@end

@implementation FeedbackDraftViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.done = YES;
    self.newFeedback = YES;
    
    self.view.backgroundColor = [UIColor colorFromHexString:@"2ECC71"];
    
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
        ) {
        // Will open an confirm dialog to get user's approval
        [_locationManager requestWhenInUseAuthorization];
        //[_locationManager requestAlwaysAuthorization];
    } else {
        [_locationManager startUpdatingLocation]; //Will update location immediately
    }
    
    
    
    
    
    
    
    [self loadSubviews];
    [self autoLayoutSubviews];
    
    self.observeLogo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)];
    [self.observeLogo addGestureRecognizer:tapGesture];
    
}

- (void)viewDidAppear:(BOOL)animated{
    SharedManager *test = [SharedManager sharedManager];
    self.observeLogo.text = test.entity;
}

- (void)labelTap{
    ChooseViewController *viewController = [[ChooseViewController alloc] init];
    viewController.locationResults = [NSMutableArray new];
    viewController.locationResults = self.locationResults;
    [self presentViewController:viewController animated:YES completion:^{
        //
    }];
}

- (void)findLocationParse{
    [PFCloud callFunctionInBackground:@"get_places"
                       withParameters:@{@"longitude": [NSString stringWithFormat:@"%f", self.longitude], @"latitude":[NSString stringWithFormat:@"%f", self.latitude]}
                                block:^(NSDictionary *results, NSError *error) {
                                    if (!error) {
                                        // this is where you handle the results and change the UI.
                                        NSString* test = results[@"text"];
                                        NSData *data = [test dataUsingEncoding:NSUTF8StringEncoding];
                                        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                        NSString *label = json[@"results"][0][@"name"];
                                        self.locationResults = [NSMutableArray new];
                                        self.locationResults = json[@"results"];
                                        
                                        CATransition *animation = [CATransition animation];
                                        animation.duration = 1.0;
                                        animation.type = kCATransitionFade;
                                        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                        [self.observeLogo.layer addAnimation:animation forKey:@"changeTextTransition"];
                                        
                                        // Change the text
                                        self.observeLogo.text = label;
                                        SharedManager *hey = [SharedManager sharedManager];
                                        hey.entity = label;
                                        hey.entityID = json[@"results"][0][@"place_id"];
                                        
                                        
                                        
                                        
                                        
                                        
                                    }
                                }];
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [_locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}


- (void)loadSubviews {
    [self loadContentView];
    [self loadSubmitButton];
    [self loadInputField];
    [self loadObserveLogo];
}

- (void)loadContentView {
    CGRect frame = self.view.bounds;
    self.contentView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:self.contentView];
}

- (void)loadSubmitButton{
    self.submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.submitButton setTitle:@"Submit Feedback" forState:UIControlStateNormal];
    [self.submitButton setTintColor:[UIColor whiteColor]];
    [self.submitButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    [self.submitButton addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.submitButton];
}

- (void)loadInputField{
    self.inputField = [[UITextView alloc] init];
    [self.inputField setFont:[UIFont fontWithName:@"Helvetica" size:24]];
    self.inputField.delegate = self;
    self.inputField.text = @"Enter feedback here..";
    self.inputField.textColor = [UIColor lightGrayColor]; //optional
    [self.contentView addSubview:self.inputField];

}

- (void)loadObserveLogo{
    self.observeLogo = [UILabel new];
    [self.observeLogo setText:@"Observe"];
    [self.observeLogo setTextColor:[UIColor whiteColor]];
    [self.observeLogo setTextAlignment:NSTextAlignmentCenter];
    [self.observeLogo setFont:[UIFont fontWithName:@"Helvetica" size:40]];
    self.observeLogo.numberOfLines = 1;
    self.observeLogo.minimumFontSize = 8.;
    self.observeLogo.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.observeLogo];
    
}



- (void)autoLayoutSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // Label all views for autolayout
    NSDictionary *views = @{
                            @"submitButton"           :   self.submitButton,
                            @"inputField"             :   self.inputField,
                            @"observeLogo"            :   self.observeLogo
                            };
    

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[submitButton]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[submitButton]-20-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[observeLogo]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-35-[observeLogo]" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[inputField]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[inputField]-10-[submitButton]" options:0 metrics:nil views:views]];
    
    [UIView animateWithDuration:0.2 animations:^{[self.contentView layoutIfNeeded];}];
    
    
    
    
    
}

- (void)keyboardLayout {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // Label all views for autolayout
    NSDictionary *views = @{
                            @"submitButton"           :   self.submitButton,
                            @"inputField"             :   self.inputField,
                            @"observeLogo"            :   self.observeLogo
                            };
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[submitButton]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[submitButton]-260-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[observeLogo]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[observeLogo]" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[inputField]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[inputField]-10-[submitButton]" options:0 metrics:nil views:views]];
    
    
    [UIView animateWithDuration:0.2 animations:^{[self.contentView layoutIfNeeded];}];
}

- (void)submitPressed:(UIButton*)button{
    //push the next screen
//    ConfirmationViewController* vc = [ConfirmationViewController new];
//    [self presentViewController:vc animated:YES completion:^{
//        //
//    }];
    SharedManager *test = [SharedManager sharedManager];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Thank you for your feedback to %@.",test.entity]
                                                    message:@"Feel free to write some more!"
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self sendFeedbackToParse];
    self.newFeedback = YES;
    [self.inputField setText:@""];
    
    
    
  
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:

(NSRange)range replacementText:(NSString *)text{
    
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
    }
    
    
    return YES;
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    NSLog(@"Did begin editing");
    
    self.inputField = textView;
    
    if ([self.inputField.text isEqual:@"Enter feedback here.."] || [self.inputField.text isEqual:@""]){
        self.inputField.textColor = [UIColor blackColor];
        [self.inputField setText:@""];
    }
    

    
    [self.contentView removeConstraints:self.contentView.constraints];
    [self keyboardLayout];
    
    
//    [self.inputField setText:@"Enter feedback here.."];
//    self.inputField.textColor = [UIColor lightGrayColor];
    
    
//    else if ([self.inputField.text  isEqual: @""]) {
//        [self.inputField setText:@"Enter feedback here.."];
//        self.inputField.textColor = [UIColor lightGrayColor];
//    }
    
    
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    NSLog(@"Did End editing");
    [self autoLayoutSubviews];
    
    
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    
    
    
    return YES;
    
}

-(void)sendFeedbackToParse{
    NSString *textContent = self.inputField.text;
    PFObject *feedback = [PFObject objectWithClassName:@"Feedback"];
    SharedManager *test = [SharedManager sharedManager];
    feedback[@"text"]=textContent;
    feedback[@"latitude"]= [NSNumber numberWithFloat:self.latitude];
    feedback[@"longitude"]= [NSNumber numberWithFloat:self.longitude];
    feedback[@"creator"]=[PFUser currentUser];
    feedback[@"placeId"]=test.entityID;
    
    [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //
    }];
    
    
    
    [self.inputField setText:@"Enter feedback here.."];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    
    
    self.longitude = location.coordinate.longitude;
    self.latitude =  location.coordinate.latitude;
    if (self.done){
        [self findLocationParse];
    }
    
    self. done = false;

}



@end
