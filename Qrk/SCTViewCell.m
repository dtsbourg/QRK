//
//  SCTViewCell.m
//  Qrk
//
//  Created by Dylan Bourgeois on 17/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTViewCell.h"

@implementation SCTViewCell

@synthesize articleGist=_articleGist;
@synthesize articleTrackArtist = _articleTrackArtist;
@synthesize articleTrackIllustration=_articleTrackIllustration;
@synthesize articleTrackTitle=_articleTrackTitle;
@synthesize articleDate=_articleDate;

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
