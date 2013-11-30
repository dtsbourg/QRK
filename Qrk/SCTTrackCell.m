//
//  SCTTrackCell.m
//  Qrk
//
//  Created by Dylan Bourgeois on 15/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTTrackCell.h"
#import "SCTAppDelegate.h"
#import "SCUI.h"

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
    
    SCAccount *account = [SCSoundCloud account];
    
    if (account == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Logged In"
                              message:@"You must login first"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    SCRequestResponseHandler handler;
    
    handler = ^(NSURLResponse *response, NSData *data, NSError *error)
    {
        
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
    };
    
    [SCRequest performMethod:SCRequestMethodPUT
                  onResource:[NSURL URLWithString:[NSURL URLWithString:@"https://api.soundcloud.com/me/favorites.json"]]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];

}



@end
