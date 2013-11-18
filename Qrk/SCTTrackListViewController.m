//
//  SCTTrackListViewController.m
//  Qrk
//
//  Created by Dylan Bourgeois on 14/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTTrackListViewController.h"
#import "SCUI.h"
#import "SCTTrackCell.h"
#import "MRProgress.h"
#import "Reachability.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface SCTTrackListViewController () {
    NSString *resourceURL;
    NSArray* trackArray;
    NSInteger selectedIndex;
}


@end

@implementation SCTTrackListViewController

@synthesize tracks;
@synthesize player;
@synthesize queuePlayer;

- (IBAction)swipeLeft:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Swipe"
                          message:@"Direction Left"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];

    
}

# pragma mark - View

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self connected]) {
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
    self.navigationController.navigationBar.translucent=NO;
    
    self.tabBarController.tabBar.tintColor=UIColorFromRGB(0x067AB5);
    self.tabBarController.tabBar.translucent=NO;
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    
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
        
        if (!jsonError) {
            self.tracks = (NSArray *)jsonResponse;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
            });
        }
        
        else NSLog(@"%@",[jsonError localizedDescription]);
            
        };
    
        switch ([self.accountSegment selectedSegmentIndex]) {
            case 0:
                resourceURL=@"https://api.soundcloud.com/me/favorites.json";
                break;
            case 1:
                resourceURL=@"https://api.soundcloud.com/users/gramatik/favorites.json";
                break;
            default:
                break;
        }
        
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to connect"
                                                        message:@"Please check your connection to use Qrk"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        [self.accountSegment setSelectedSegmentIndex:0];
        resourceURL = @"https://api.soundcloud.com/me/favorites.json";
        [self performSelector: @selector(getTracks:) withObject:self afterDelay: 0.0];
    }
    else{
        //toggle the correct view to be visible
        resourceURL = @"https://api.soundcloud.com/users/gramatik/favorites.json";
        [self.accountSegment setSelectedSegmentIndex:1];
        [self performSelector: @selector(getTracks:) withObject:self afterDelay: 0.0];
    }
    
}

# pragma mark - Internet connection
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

#pragma mark - Audio player

- (IBAction)getTracks:(id)sender {
    
    if ([self connected]) {
        [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
        
        SCAccount *account = [SCSoundCloud account];
        
        if (account == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Logged In"
                                                            message:@"You must login first"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        SCRequestResponseHandler handler;
        handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
            NSError *jsonError = nil;
            NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                                 JSONObjectWithData:data
                                                            options:0
                                                              error:&jsonError];
            
            if (!jsonError) {
                self.tracks = (NSArray *)jsonResponse;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                });
            }
            
            else NSLog(@"%@", [jsonError localizedDescription]);
        };
        
        
        [SCRequest performMethod:SCRequestMethodGET
                      onResource:[NSURL URLWithString:resourceURL]
                 usingParameters:nil
                     withAccount:account
          sendingProgressHandler:nil
                 responseHandler:handler];
    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to connect"
                                                        message:@"Please check your connection to use Qrk"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    NSDictionary *track = [trackArray objectAtIndex:selectedIndex];
    NSString *streamURL = [track objectForKey:@"stream_url"];
    
    SCAccount *account = [SCSoundCloud account];
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:streamURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                    self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
                    [self.player setDelegate:self];
                    [self.player prepareToPlay];
                    [self.player play];
                 });
             }];

    
}

- (void) playMusic {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self connected]) return [self.tracks count];
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    SCTTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SCTTrackCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    NSDictionary *userInfo = [track objectForKey:@"user"];
    
    
    //TRACK PLAYS
    NSInteger plays=[[track objectForKey:@"playback_count"]integerValue];
    
    if (plays >= 1000) {
        cell.trackPlays.text =[NSString stringWithFormat:@"%.01f K",plays/1000.];
    }

    else {
        cell.trackPlays.text =[NSString stringWithFormat:@"%@",[track objectForKey:@"playback_count"]];
    }
    
    //TRACK BPM
    NSInteger bpm=100;
    if ([[NSString stringWithFormat:@"%@",[track objectForKey:@"bpm"]] isEqualToString:@"<null>"]) {
        cell.trackBPM.text=[NSString stringWithFormat:@"%i",bpm+(rand()%27)];
    }
    else {
        cell.trackBPM.text=[NSString stringWithFormat:@"%@",[track objectForKey:@"bpm"]];
    }
    
    cell.trackName.text = [track objectForKey:@"title"];
    [cell.trackName setLineBreakMode:NSLineBreakByWordWrapping];
    cell.trackName.numberOfLines=2;
    
    cell.trackFavs.text =[NSString stringWithFormat:@"%@",[track objectForKey:@"favoritings_count"]];
    cell.trackArtist.text =[userInfo objectForKey:@"username"];
    
    //TRACK ILLUSTRATION
    NSString*artworkURL=[track objectForKey:@"artwork_url"];
    
    if (!([artworkURL isKindOfClass:[NSNull class]])) {
        
            [cell.trackIllustration setImageWithURL:[NSURL URLWithString:artworkURL]
                           placeholderImage:[UIImage imageNamed:@"quark_up.png"]];
    }
    
    else {
        cell.trackIllustration.image = [UIImage imageNamed:@"quark_up.png"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    NSString *streamURL = [track objectForKey:@"stream_url"];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row,indexPath.row+2)];
    trackArray = [self.tracks objectsAtIndexes:indexSet];
    selectedIndex = indexPath.row;
    
    SCAccount *account = [SCSoundCloud account];
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:streamURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                    
                     NSError *playerError;
                     
                     if (player==nil) {
                         player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                         [player setDelegate:self];
                         [player prepareToPlay];
                         [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                         [player play];
                     }
                 });
             }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


@end
