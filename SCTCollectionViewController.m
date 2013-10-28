//
//  SCTCollectionViewController.m
//  Qrk
//
//  Created by Dylan Bourgeois on 28/10/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCUI.h"
#import "SCTCollectionViewController.h"

@interface SCTCollectionViewController ()

@end

@implementation SCTCollectionViewController

@synthesize tracks;
@synthesize player;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)loadTracks:(id)sender {
    
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
    
    [self.collectionView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.tracks count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    //NSDictionary *userInfo = [track objectForKey:@"user"];
    
    UIImageView *trackImageView = (UIImageView *)[cell viewWithTag:100];
    
    if (!([[track objectForKey:@"artwork_url"] isKindOfClass:[NSNull class]])) {
        
        if ([[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[track objectForKey:@"artwork_url"]]]) {
            
            trackImageView.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[track objectForKey:@"artwork_url"]]]];
        }
    }
    
    else {
        trackImageView.image = [UIImage imageNamed:@"QUP.png"];
    }


    return cell;
}

@end
