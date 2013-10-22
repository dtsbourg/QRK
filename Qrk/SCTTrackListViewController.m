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

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface SCTTrackListViewController ()


@end

@implementation SCTTrackListViewController

@synthesize tracks;
@synthesize player;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)getTracks:(id)sender {
    
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
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            self.tracks = (NSArray *)jsonResponse;
        }
    };
    
    NSString *resourceURL = @"https://api.soundcloud.com/me/favorites.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.opaque=YES;
    
    self.tabBarController.tabBar.tintColor=UIColorFromRGB(0x067AB5);
    self.tabBarController.tabBar.translucent=YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tracks count];
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
    if (!([[track objectForKey:@"artwork_url"] isKindOfClass:[NSNull class]])) {
        if ([[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[track objectForKey:@"artwork_url"]]]) {
            cell.trackIllustration.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[track objectForKey:@"artwork_url"]]]];
        }
    }
    
    else {
        cell.trackIllustration.image = [UIImage imageNamed:@"QUP.png"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    NSString *streamURL = [track objectForKey:@"stream_url"];
    
    SCAccount *account = [SCSoundCloud account];
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:streamURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 NSError *playerError;
                 player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                 [player prepareToPlay];
                 [player play];
             }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}



/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
