//
//  SCTFeedViewController.m
//  Qrk
//
//  Created by Dylan Bourgeois on 17/10/13.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTFeedViewController.h"
#import "SCUI.h"
#import "SCTViewcell.h"
#import "TMAPIClient.h"
#import "NSString+HTML.h"
#import "SCTPersonalInfoViewController.h"
#import "MRProgress.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define API_KEY @"PFNVtb9DgmvdLwt43vK3f3zQai0bSLEmyz07A9cr7Do1xlIJ3D"
#define PAGES 10


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SCTFeedViewController () {
    Reachability *internetReachableFoo;
}

@end

@implementation SCTFeedViewController
@synthesize posts;

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (IBAction) login:(id) sender
{
    SCAccount *account = [SCSoundCloud account];
    if(!account)
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
    
    else {
        // Testing : self.navigationItem.rightBarButtonItem.enabled=NO;
        [self performSegueWithIdentifier:@"personalInfoSegue" sender:self];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self connected]) {
        [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
        
        
        self.tabBarController.tabBar.tintColor=UIColorFromRGB(0x067AB5);
        self.tabBarController.tabBar.translucent=NO;
        [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
        
        
        [TMAPIClient sharedInstance].OAuthConsumerKey=@"PFNVtb9DgmvdLwt43vK3f3zQai0bSLEmyz07A9cr7Do1xlIJ3D";
        [TMAPIClient sharedInstance].OAuthConsumerSecret=@"pyARG8a2xedThyL1I5zTHDRQUgDLJmAWRaqywbiqQ6cSWMvyAe";
        
        
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                });
            }
        });
    }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to connect" message:@"Please check your connection to use Qrk" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([self connected]) return 1;
    else return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self connected]) return [self.posts count];
    else return 0;
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
        NSMutableString* gistString =  [[[post objectForKey:@"caption"] kv_decodeHTMLCharacterEntities] mutableCopy];
        NSError*paragError=nil; NSError*linkError=nil;
        
        NSRegularExpression *regexParagraph = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*p>"
                                                                                        options:NSRegularExpressionCaseInsensitive
                                                                                          error:&paragError];
        NSRegularExpression *regexLink = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*a[^>]*>"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&linkError];
        if (!linkError && !paragError) {
            
        [regexParagraph replaceMatchesInString:gistString
                                       options:0
                                         range:NSMakeRange(0, gistString.length)
                                  withTemplate:@""];
        
        [regexLink replaceMatchesInString:gistString
                                  options:0
                                    range:NSMakeRange(0, gistString.length)
                             withTemplate:@""];
        
        cell.articleGist.text=gistString;
        CGRect rect = cell.articleGist.frame;
        rect.size.height = cell.articleGist.contentSize.height;
        cell.articleGist.frame = rect;
            
        }
        
        //Illustration
        bool didGetIllustration=NO;
        
        if ([[post objectForKey:@"type"]isEqualToString:@"video"]) {
            
            url= [NSURL URLWithString:[post objectForKey:@"thumbnail_url"]];

                [cell.articleTrackIllustration setImageWithURL:url
                                       placeholderImage:[UIImage imageNamed:@"quark_up.png"]];
                didGetIllustration=YES;
        }
        
        else if ([[post objectForKey:@"type" ]isEqualToString:@"audio"]) {
            
            url= [NSURL URLWithString:[post objectForKey:@"album_art"]];
           
            
         
                [cell.articleTrackIllustration setImageWithURL:url
                                              placeholderImage:[UIImage imageNamed:@"quark_up.png"]];
                didGetIllustration=YES;
            
        
        }
        
        else if (!didGetIllustration) {
            cell.articleTrackIllustration.image=[UIImage imageNamed:@"quark_up.png"];
            cell.articleTrackTitle.text=[post objectForKey:@"title"];
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
        
        cell.articleDate.text=[NSString stringWithFormat:@"%@ %ld, %ld",month, (long)[dateComps day], (long)[dateComps year]];
    }
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
}


#pragma mark - Submission

- (IBAction)sendMail:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"[QRK Submission]";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"<ul> \n"
                             "<li> Title :  </li> <hr /> \n"
                             "<li> Artist :  </li> <hr /> \n"
                             "<li> Link : </li>  <hr />\n"
                             "<li> Comment : </li> <hr /> \n"
                             "</ul>"];
    
    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"quark_up_banner.png"], 0.5);
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc addAttachmentData:data mimeType:@"image/png" fileName:@"quark_up_banner.png"];
    
    [mc setToRecipients:@[@"submission.quark.up@gmail.com"]];
    
    mc.navigationBar.tintColor=[UIColor whiteColor];
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    UIAlertView *messageAlert;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            messageAlert = [[UIAlertView alloc]initWithTitle:@"Mail Cancelled !" message:@" " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [messageAlert show];
            break;
        case MFMailComposeResultSaved:
            messageAlert = [[UIAlertView alloc]initWithTitle:@"Mail Saved !" message:@" " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [messageAlert show];
            break;
        case MFMailComposeResultSent:
            messageAlert = [[UIAlertView alloc]initWithTitle:@"Mail Sent !" message:@" " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [messageAlert show];
            break;
        case MFMailComposeResultFailed:
            messageAlert = [[UIAlertView alloc]initWithTitle:@"Mail sent failure" message:@" " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [messageAlert show];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
