//
//  SharedManager.m
//  Observe
//
//  Created by Patrick Wilson on 4/13/15.
//  Copyright (c) 2015 Patrick Wilson. All rights reserved.
//

#import "SharedManager.h"

@implementation SharedManager

@synthesize entity;



#pragma mark Singleton Methods

+ (id)sharedManager {
    static SharedManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        entity = @"Observe";
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
