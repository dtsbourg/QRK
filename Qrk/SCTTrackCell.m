//
//  SCTTrackCell.m
//  Qrk
//
//  Created by Dylan Bourgeois on 15/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTTrackCell.h"

@implementation SCTTrackCell

@synthesize trackArtist=_trackArtist;
@synthesize trackFavs=_trackFavs;
@synthesize trackIllustration=_trackIllustration;
@synthesize trackBPM=_trackBPM;
@synthesize trackName=_trackName;
@synthesize trackPlays=_trackPlays;
@synthesize trackWaveForm=_trackWaveForm;

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

@end
