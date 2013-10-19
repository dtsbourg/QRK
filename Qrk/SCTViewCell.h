//
//  SCTViewCell.h
//  Qrk
//
//  Created by Dylan Bourgeois on 17/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *articleTrackArtist;
@property(nonatomic, weak) IBOutlet UILabel *articleTrackTitle;
@property(nonatomic, weak) IBOutlet UIImageView * articleTrackIllustration;
@property(nonatomic, weak) IBOutlet UITextView *articleGist;
@property (nonatomic, weak) IBOutlet UILabel *articleDate;


@end
