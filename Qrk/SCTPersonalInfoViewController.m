//
//  SCTPersonalInfoViewController.m
//  Qrk
//
//  Created by Dylan Bourgeois on 05/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTPersonalInfoViewController.h"
#import "SCUI.h"

@interface SCTPersonalInfoViewController () 
@end

@implementation SCTPersonalInfoViewController

@synthesize info;

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
            self.info =(NSDictionary*) jsonResponse;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
        else NSLog(@"%@",[jsonError localizedDescription]);
    };

    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me.json"]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];

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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 3;
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"111-user.png"];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.info objectForKey:@"full_name"]];
                    break;
                    
                case 1:
                    cell.imageView.image = [UIImage imageNamed:@"switch_orange.png"];
                    cell.textLabel.text=[NSString stringWithFormat:@"Followers %@", [self.info objectForKey:@"followers_count"]];
                    break;
                    
                case 2:
                    cell.imageView.image = [UIImage imageNamed:@"switch_orange.png"];
                    cell.textLabel.text=[NSString stringWithFormat:@"Following %@", [self.info objectForKey:@"followings_count"]];
                    break;
                    
                case 3:
                    cell.imageView.image = [UIImage imageNamed:@"switch_orange.png"];
                    cell.textLabel.text=[NSString stringWithFormat:@"Favorites %@", [self.info objectForKey:@"public_favorites_count"]];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"service_facebook_page.png"];
                    cell.textLabel.text=@"Facebook";
                    break;
                
                case 1:
                    cell.imageView.image = [UIImage imageNamed:@"service_tumblr.png"];
                    cell.textLabel.text=@"Tumblr";
                    break;
                    
                case 2:
                    cell.imageView.image = [UIImage imageNamed:@"service_twitter.png"];
                    cell.textLabel.text=@"Twitter";
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 2:
            cell.imageView.image=[UIImage imageNamed:@"cancel_dark.png"];
            cell.textLabel.text=@"Disconnect";
        default:
            break;
    }
    
    return cell;
}



@end
