//
//  SCTTrackListViewController.h
//  Qrk
//
//  Created by Dylan Bourgeois on 14/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface SCTTrackListViewController : UITableViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) NSArray *tracks;
@property (strong, nonatomic) AVAudioPlayer* player;
@property (strong, nonatomic) IBOutlet UISegmentedControl *accountSegment;
@property (strong, nonatomic) AVQueuePlayer* queuePlayer;

-(BOOL) connected;
@end
