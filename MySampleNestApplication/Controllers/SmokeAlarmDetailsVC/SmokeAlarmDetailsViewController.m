//
//  SmokeAlarmDetailsViewController.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "SmokeAlarmDetailsViewController.h"
#import "SmokeAlarmDetailsViewController+UIControls.h"

@interface SmokeAlarmDetailsViewController ()

@end

@implementation SmokeAlarmDetailsViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setupNameLongLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
