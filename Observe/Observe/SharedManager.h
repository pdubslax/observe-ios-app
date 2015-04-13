//
//  SharedManager.h
//  Observe
//
//  Created by Patrick Wilson on 4/13/15.
//  Copyright (c) 2015 Patrick Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedManager : NSObject{
    NSString *entity;
    NSString *entityID;

}

@property (nonatomic, retain) NSString *entity;
@property (nonatomic, retain) NSString *entityID;






+ (id)sharedManager;

@end
