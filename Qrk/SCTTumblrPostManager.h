//
//  SCTTumblrPostManager.h
//  Qrk
//
//  Created by Dylan Bourgeois on 04/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCTTumblrPostDelegate.h"
#import "SCTPostManagerDelegate.h"

@class SCTTumblrPostCommunicator;

@interface SCTTumblrPostManager : NSObject <SCTTumblrPostDelegate>

@property (strong, nonatomic) SCTTumblrPostCommunicator *communicator;
@property (weak, nonatomic) id<SCTPostManagerDelegate> delegate;

- (void)fetchPosts;

@end
