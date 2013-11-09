//
//  SCTFeedViewController.h
//  Qrk
//
//  Created by Dylan Bourgeois on 17/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Reachability.h"


@interface SCTFeedViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *posts;
-(BOOL) connected;
    
@end
