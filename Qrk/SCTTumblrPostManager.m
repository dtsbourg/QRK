//
//  SCTTumblrPostManager.m
//  Qrk
//
//  Created by Dylan Bourgeois on 04/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTTumblrPostManager.h"
#import "SCTTumblrPostBuilder.h"
#import "SCTTumblrPostCommunicator.h"


@implementation SCTTumblrPostManager

- (void)fetchPosts
{
    [self.communicator searchPosts];
}

#pragma mark - SCTTumblrPostCommunicatorDelegate

- (void)receivedTumblrJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    NSArray *posts = [SCTTumblrPostBuilder postFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchingPostsFailedWithError:error];
        
    } else {
        [self.delegate didReceivePosts:posts];
    }
}

- (void)fetchingTumblrFailedWithError:(NSError *)error
{
    [self.delegate fetchingPostsFailedWithError:error];
}

@end
