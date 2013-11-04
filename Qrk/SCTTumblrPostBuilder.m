//
//  SCTTumblrPostBuilder.m
//  Qrk
//
//  Created by Dylan Bourgeois on 04/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTTumblrPostBuilder.h"
#import "SCTTumblrPost.h"

@implementation SCTTumblrPostBuilder

+ (NSArray *)postFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"results"];
    NSLog(@"Count %d", results.count);
    
    for (NSDictionary *postDic in results) {
        SCTTumblrPost *post = [[SCTTumblrPost alloc] init];
        
        for (NSString *key in postDic) {
            if ([post respondsToSelector:NSSelectorFromString(key)]) {
                [post setValue:[postDic valueForKey:key] forKey:key];
            }
        }
        
        [posts addObject:post];
    }
    
    return posts;
}

@end
