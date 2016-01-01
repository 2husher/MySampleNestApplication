//
//  ThermostatDetailsViewController.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "ThermostatDetailsViewController.h"
#import "DetailsView.h"
#import "NestThermostatManager.h"
#import "NestStructureManager.h"
#import "ThermostatDetailsViewController+UIControls.h"
#import "ThermostatDetailsViewController+Contstraints.h"

@interface ThermostatDetailsViewController ()<NestThermostatManagerDelegate>

@property (nonatomic, strong) DetailsView *detailsView;
@property (nonatomic, strong) NestThermostatManager *nestThermostatManager;

//@property (nonatomic) BOOL isSlidingSlider;

@end

//#define TEMP_MIN_VALUE 50
//#define TEMP_MAX_VALUE 90
//
//#define FAN_TIMER_SUFFIX_ON @"fan timer (on)"
//#define FAN_TIMER_SUFFIX_OFF @"fan timer (off)"
//#define FAN_TIMER_SUFFIX_DISABLED @"fan timer (disabled)"

@implementation ThermostatDetailsViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setupNameLongLabel];
    [self setupNameLongLabelConstraints];

    [self setupCurrentTemperatureLabel];
    [self setupCurrentTemperatureLabelConstraints];

    [self setupCurrentTemperatureValueLabel];
    [self setupCurrentTemperatureValueLabelConstraints];

    [self setupTargetTemperatureLabel];
    [self setupTargetTemperatureLabelConstraints];

    [self setupTargetTemperatureValueLabel];
    [self setupTargetTemperatureSlider];
    [self setupTargetTemperatureValueLabelAndSliderConstraints];

    [self setupFanTimerLabel];
    [self setupFanTimerSwitch];
    [self setupFanTimerLabelAndSwitchConstraints];

//    [self setupActivity];
}

//- (void)setupActivity
//{
//    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//
//    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame), self.activity.frame.size.width, self.activity.frame.size.height)];
//
//    self.activity.hidden = YES;
//    [self.activity startAnimating];
//
//    [self.view addSubview:self.activity];
//}

//- (void)setupDetailsView
//{
//    self.detailsView = [[DetailsView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:self.detailsView];
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Details";

    self.nestThermostatManager = [[NestThermostatManager alloc] init];
    self.nestThermostatManager.delegate = self;

    [self subscribeToThermostat:self.thermostatItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)subscribeToThermostat:(Thermostat *)thermostat
{
    if (thermostat)
    {
//        self.activity.hidden = NO;
//        [self.activity startAnimating];

        [self.nestThermostatManager beginSubscriptionForThermostat:thermostat];
    }
}

#pragma mark - NestThermostatManagerDelegate Methods

- (void)thermostatValuesChanged:(Thermostat *)thermostat
{
//    [self.activity stopAnimating];
//    self.activity.hidden = YES;

    [self updateViewWithThermostat:thermostat];
}

- (void)updateViewWithThermostat:(Thermostat *)thermostat
{
    self.nameLongLabel.text = thermostat.nameLong;
    self.currentTemperatureValueLabel.text = [NSString stringWithFormat:@"%lu", thermostat.ambientTemperatureF];
    self.targetTemperatureValueLabel.text = [NSString stringWithFormat:@"%lu", thermostat.targetTemperatureF];
//    [self equalizeSlider];

//    if (thermostat.hasFan)
//    {
//        self.fanTimerSwitch.enabled = YES;
//        self.fanTimerSwitch.on = thermostat.fanTimerActive;
//
//        if (thermostat.fanTimerActive)
//        {
//            self.fanTimerLabel.text = FAN_TIMER_SUFFIX_ON;
//        }
//        else
//        {
//            self.fanTimerLabel.text = FAN_TIMER_SUFFIX_OFF;
//        }
//    }
//    else
//    {
//        self.fanTimerSwitch.enabled = NO;
//        self.fanTimerLabel.text = FAN_TIMER_SUFFIX_DISABLED;
//    }
}

//- (void)equalizeSlider
//{
//    int range = (TEMP_MAX_VALUE - TEMP_MIN_VALUE);
//    int relative = (int)self.targetTemperatureValueLabel - TEMP_MIN_VALUE;
//    float percent = (float)relative/(float)range;
//
// //   if (!self.isSlidingSlider) {
//        [self animateSliderToValue:percent];
// //   }
//}

//- (void)animateSliderToValue:(float)value
//{
//    [UIView animateWithDuration:.5 animations:^{
//        [self.targetTemperatureSlider setValue:value animated:YES];
//    } completion:^(BOOL finished) {
//
//    }];
//}
//
//- (void)sliderMoving:(UISlider *)sender
//{
//    self.isSlidingSlider = YES;
//}
//
//- (void)fanDidSwitch:(UISwitch *)sender
//{
//    [self.currentThermostat setFanTimerActive:sender.isOn];
//    [self saveThermostatChange];
//}

@end
