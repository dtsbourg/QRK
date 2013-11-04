//
//  SCTTumblrPostDelegate.h
//  Qrk
//
//  Created by Dylan Bourgeois on 04/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCTTumblrPostDelegate <NSObject>

- (void)receivedTumblrJSON:(NSData *)objectNotation;
- (void)fetchingTumblrFailedWithError:(NSError *)error;

@end
