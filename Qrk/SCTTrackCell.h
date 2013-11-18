//
//  SCTTrackCell.h
//  Qrk
//
//  Created by Dylan Bourgeois on 15/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface SCTTrackCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *trackName;
@property(nonatomic, weak) IBOutlet UILabel *trackArtist;
@property(nonatomic, weak) IBOutlet UILabel *trackBPM;
@property(nonatomic, weak) IBOutlet UILabel *trackPlays;
@property(nonatomic, weak) IBOutlet UILabel *trackFavs;
@property(nonatomic, weak) IBOutlet UIImageView *trackIllustration;

@end
