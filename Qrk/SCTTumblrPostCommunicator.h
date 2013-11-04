//
//  SCTTumblrPostCommunicator.h
//  Qrk
//
//  Created by Dylan Bourgeois on 04/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCTTumblrPostDelegate;

@interface SCTTumblrPostCommunicator : NSObject

@property (weak, nonatomic) id<SCTTumblrPostDelegate> delegate;

- (void)searchPosts;

@end
