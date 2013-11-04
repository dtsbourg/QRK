//
//  SCTPostManagerDelegate.h
//  Qrk
//
//  Created by Dylan Bourgeois on 04/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCTPostManagerDelegate <NSObject>

- (void)didReceivePosts:(NSArray *)posts;
- (void)fetchingPostsFailedWithError:(NSError *)error;

@end
