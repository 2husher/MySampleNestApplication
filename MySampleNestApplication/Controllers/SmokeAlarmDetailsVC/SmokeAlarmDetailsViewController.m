//
//  SmokeAlarmDetailsViewController.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "SmokeAlarmDetailsViewController.h"
#import "SmokeAlarmDetailsViewController+UIControls.h"
#import "NestSmokeCoAlarmManager.h"
#import "LoadingView.h"

@interface SmokeAlarmDetailsViewController()<NestSmokeCoAlarmManagerDelegate>

@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) NestSmokeCoAlarmManager *nestSmokeCoAlarmManager;

@end

@implementation SmokeAlarmDetailsViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setupNameLongLabel];
    [self setupBatteryHealthCaption];
    [self setupBatteryHealthValue];

    self.loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loadingView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Details";

    self.nestSmokeCoAlarmManager = [[NestSmokeCoAlarmManager alloc] init];
    self.nestSmokeCoAlarmManager.delegate = self;

    if (self.smokeAlarmItem)
    {
        [self.loadingView showLoading];
        [self.nestSmokeCoAlarmManager beginSubscriptionForSmokeCoAlarm:self.smokeAlarmItem];
    }
}

- (void)smokeCoAlarmValuesChanged:(SmokeCoAlarm *)smokeCoAlarm
{
    [self.loadingView hideLoading];

    self.nameLongLabel.text = smokeCoAlarm.nameLong;
    self.batteryHealthValue.text = smokeCoAlarm.batteryHealth;
}

@end
