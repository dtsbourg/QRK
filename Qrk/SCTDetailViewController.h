//
//  SCTDetailViewController.h
//  Qrk
//
//  Created by Dylan Bourgeois on 30/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTDetailViewController : UIViewController
@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end
