//
//  SCTTrackCell.m
//  Qrk
//
//  Created by Dylan Bourgeois on 15/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTTrackCell.h"
#import "SCTAppDelegate.h"

@implementation SCTTrackCell

@synthesize trackArtist=_trackArtist;
@synthesize trackFavs=_trackFavs;
@synthesize trackIllustration=_trackIllustration;
@synthesize trackBPM=_trackBPM;
@synthesize trackName=_trackName;
@synthesize trackPlays=_trackPlays;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)shareTap:(UIGestureRecognizer*)sender
{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Tweeting from my own app! :)"];
        
        UITableView *tv = (UITableView *) self.superview.superview;
        UITableViewController *vc = (UITableViewController *) tv.dataSource;
        [vc presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure"
                                  "your device has an internet connection and you have"
                                  "at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }

}



@end
