//
//  SCTCollectionViewController.h
//  Qrk
//
//  Created by Dylan Bourgeois on 28/10/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SCTCollectionViewController : UICollectionViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) NSArray *tracks;
@property (strong, nonatomic) AVAudioPlayer* player;

@end
