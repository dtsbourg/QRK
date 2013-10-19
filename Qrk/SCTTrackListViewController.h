//
//  SCTTrackListViewController.h
//  Qrk
//
//  Created by Dylan Bourgeois on 14/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface SCTTrackListViewController : UITableViewController <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSArray *tracks;
@property (nonatomic, strong) AVAudioPlayer *player;

@end
