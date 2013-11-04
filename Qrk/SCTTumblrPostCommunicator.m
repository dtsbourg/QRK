//
//  SCTTumblrPostCommunicator.m
//  Qrk
//
//  Created by Dylan Bourgeois on 04/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTTumblrPostCommunicator.h"
#import "SCTTumblrPostDelegate.h"

#define API_KEY @"PFNVtb9DgmvdLwt43vK3f3zQai0bSLEmyz07A9cr7Do1xlIJ3D"
#define PAGES 20

@implementation SCTTumblrPostCommunicator

- (void)searchPosts
{
    NSString *urlAsString = [NSString stringWithFormat:@"api.tumblr.com/v2/blog/quark-up.tumblr.com/posts?api_key=%@&limit=%d",API_KEY, PAGES ];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingTumblrFailedWithError:error];
        } else {
            [self.delegate receivedTumblrJSON:data];
        }
    }];
    
}

@end
