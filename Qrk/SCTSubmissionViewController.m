//
//  SCTSubmissionViewController.m
//  Qrk
//
//  Created by Dylan Bourgeois on 08/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTSubmissionViewController.h"


@interface SCTSubmissionViewController ()

@end

@implementation SCTSubmissionViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (IBAction)sendMessage:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"[QRK Submission]";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"<ul> \n"
                             "<li> Title :  </li> \n"
                             "<li> Artist :  </li> \n"
                             "<li> Comment : </li> \n"
                             "<li> Link : </li> \n"
                             "</ul>"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:@[@"submission.quark.up@gmail.com"]];
    
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
