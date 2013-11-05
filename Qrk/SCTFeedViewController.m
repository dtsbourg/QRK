//
//  SCTFeedViewController.m
//  Qrk
//
//  Created by Dylan Bourgeois on 17/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTFeedViewController.h"
#import "SCTTrackListViewController.h"
#import "SCUI.h"
#import "SCTViewcell.h"
#import "TMAPIClient.h"

#define API_KEY @"PFNVtb9DgmvdLwt43vK3f3zQai0bSLEmyz07A9cr7Do1xlIJ3D"
#define PAGES 5


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SCTFeedViewController () 

@end

@implementation SCTFeedViewController
@synthesize posts;

- (IBAction) login:(id) sender
{
    SCLoginViewControllerCompletionHandler handler = ^(NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Done!");
        }
    };
    
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController
                               loginViewControllerWithPreparedURL:preparedURL
                               completionHandler:handler];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
        NSLog(@"initwithstyle");
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [TMAPIClient sharedInstance].OAuthConsumerKey=@"PFNVtb9DgmvdLwt43vK3f3zQai0bSLEmyz07A9cr7Do1xlIJ3D";
    [TMAPIClient sharedInstance].OAuthConsumerSecret=@"pyARG8a2xedThyL1I5zTHDRQUgDLJmAWRaqywbiqQ6cSWMvyAe";
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.opaque=YES;
    
    self.tabBarController.tabBar.tintColor=UIColorFromRGB(0x067AB5);
    self.tabBarController.tabBar.translucent=YES;
    
  
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/quark-up.tumblr.com/posts?api_key=%@&limit=%d",API_KEY, PAGES ]];
        NSString *json = [NSString stringWithContentsOfURL:url
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
        
        if(!error) {
            NSData *jsonData = [json dataUsingEncoding:NSISOLatin1StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:kNilOptions
                                                                       error:&error];
            
           
            NSDictionary *result=[jsonDict objectForKey:@"response"];
            self.posts=(NSArray*)[result objectForKey:@"posts"];
            NSLog(@"%@", self.posts);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    });
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //reload the table to catch any changes
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.posts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SCTViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SCTViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (posts) {
        
        NSURL*url;
        NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
        
        //Artist
        cell.articleTrackArtist.text=[post objectForKey:@"artist"];
        
        //Track
        cell.articleTrackTitle.text=[post objectForKey:@"track_name"];
        
        //Gist
        cell.articleGist.text=[post objectForKey:@"caption"];
        
        //Illustration
        if ([[post objectForKey:@"type" ]isEqualToString:@"video"]) {
            url= [NSURL URLWithString:[post objectForKey:@"thumbnail_url"]];
            cell.articleTrackIllustration.image=[UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:url]];
        }
        
        else if ([[post objectForKey:@"type" ]isEqualToString:@"audio"])
        {
            url= [NSURL URLWithString:[post objectForKey:@"album_art"]];
            cell.articleTrackIllustration.image=[UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:url]];
        
        }
        
        else {
            cell.articleTrackIllustration.image=[UIImage imageNamed:@"quark_up.png"];
        }
        
        cell.articleTrackIllustration.clipsToBounds=YES;
        
        //Date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [formatter setDateFormat:@"y-M-d HH:mm:ss zz"];
        NSString *dateString = [post objectForKey:@"date"];
        NSDate *postDate = [formatter dateFromString:dateString];
        NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:postDate];
        
        NSDateFormatter *monthFormat = [[NSDateFormatter alloc] init];
        [monthFormat setDateFormat:@"MMMM"];
        
        NSString *month = [monthFormat stringFromDate:postDate];
        
        cell.articleDate.text=[NSString stringWithFormat:@"%@ %d, %d",month, [dateComps day], [dateComps year]];
    }
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
