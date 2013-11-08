//
//  SCTSubmissionViewController.m
//  Qrk
//
//  Created by Dylan Bourgeois on 08/11/2013.
//  Copyright (c) 2013 Dylan Bourgeois. All rights reserved.
//

#import "SCTSubmissionViewController.h"
#import "JVFloatLabeledTextField.h"

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;

const static CGFloat kJVFieldFontSize = 16.0f;

const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

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
    CGFloat topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    JVFloatLabeledTextField *titleField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, topOffset, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    titleField.placeholder = NSLocalizedString(@"Track Name", @"");
    titleField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    titleField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    titleField.floatingLabelTextColor = floatingLabelColor;
    titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:titleField];
    
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(kJVFieldHMargin, titleField.frame.origin.y + titleField.frame.size.height,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div1];
    
    
    JVFloatLabeledTextField *nameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin,
                                                      div1.frame.origin.y + div1.frame.size.height,
                                                      150.0f,
                                                      kJVFieldHeight)];
    
    nameField.placeholder = NSLocalizedString(@"Artist", @"");
    nameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    nameField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    nameField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:nameField];
    
    UIView *div2 = [UIView new];
    div2.frame = CGRectMake(kJVFieldHMargin + nameField.frame.size.width,
                            titleField.frame.origin.y + titleField.frame.size.height,
                            1.0f, kJVFieldHeight);
    div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div2];
    
    
    
    JVFloatLabeledTextField *locationField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                              CGRectMake(kJVFieldHMargin*2 + nameField.frame.size.width + 1.0f,
                                                         div1.frame.origin.y + div1.frame.size.height,
                                                         self.view.frame.size.width - 3*kJVFieldHMargin - nameField.frame.size.width - 1.0f,
                                                         kJVFieldHeight)];
    
    locationField.placeholder = NSLocalizedString(@"Location", @"");
    locationField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    locationField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    locationField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:locationField];
    
    
    UIView *div3 = [UIView new];
    div3.frame = CGRectMake(kJVFieldHMargin,
                            nameField.frame.origin.y + nameField.frame.size.height,
                            self.view.frame.size.width - 2*kJVFieldHMargin,
                            1.0f);
    div3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div3];
    
    
    JVFloatLabeledTextField *descriptionField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                                 CGRectMake(kJVFieldHMargin,
                                                            div3.frame.origin.y + div3.frame.size.height,
                                                            self.view.frame.size.width - 2*kJVFieldHMargin,
                                                            kJVFieldHeight)];
    
    descriptionField.placeholder = NSLocalizedString(@"Description", @"");
    descriptionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    descriptionField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    descriptionField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:descriptionField];
    
    UIView *div4 = [UIView new];
    div4.frame= CGRectMake(kJVFieldHMargin,
                           descriptionField.frame.origin.y + descriptionField.frame.size.height,
                           self.view.frame.size.width - 2*kJVFieldHMargin,
                           1.0f);
    div4.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div4];
    
    JVFloatLabeledTextField *linkField= [[JVFloatLabeledTextField alloc] initWithFrame:
                                         CGRectMake(kJVFieldHMargin,
                                                    div4.frame.origin.y+div4.frame.size.height,
                                                    self.view.frame.size.width-2*kJVFieldHMargin,
                                                    kJVFieldHeight)];
    
    linkField.placeholder = NSLocalizedString(@"Link", @"");
    linkField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    linkField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    linkField.floatingLabelActiveTextColor = floatingLabelColor;
    [self.view addSubview:linkField];
    
    
    [titleField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
