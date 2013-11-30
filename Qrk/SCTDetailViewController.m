//
//  SCTDetailViewController.m
//  Qrk
//
//  Created by Dylan Bourgeois on 30/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTDetailViewController.h"

@interface SCTDetailViewController ()

@end

@implementation SCTDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSURL *myURL = [NSURL URLWithString:[self.url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
        
        [self.webView loadRequest:request];
        self.title = @" ";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   NSURL *myURL = [NSURL URLWithString:[self.url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    
    [self.webView loadRequest:request];
    
    self.title = @" ";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
