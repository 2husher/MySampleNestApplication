//
//  ThermostatDetailsViewController.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "ThermostatDetailsViewController.h"
#import "ThermostatDetailsViewController+UIControls.h"
#import "ThermostatDetailsViewController+Contstraints.h"
#import "NestThermostatManager.h"

@interface ThermostatDetailsViewController ()<NestThermostatManagerDelegate>

@property (nonatomic, strong) NestThermostatManager *nestThermostatManager;
@property (nonatomic, strong) Thermostat *currentThermostat;

@end

NSInteger const kMinTargetTempF = 48;
NSInteger const kMaxTargetTempF = 90;
NSInteger const kTargetTempStepF = 1;

CGFloat const kMinTargetTempC = 9.0f;
CGFloat const kMaxTargetTempC = 32.0f;
CGFloat const kTargetTempStepC = 0.5f;

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

- (void)fanSwitched:(UISwitch *)sender
{
    self.currentThermostat.fanTimerActive = sender.isOn;
    [self saveThermostatChanges];
}

#pragma mark - NestThermostatManagerDelegate Methods

- (void)thermostatValuesChanged:(Thermostat *)thermostat
{
//    [self.activity stopAnimating];
//    self.activity.hidden = YES;

    self.currentThermostat = thermostat;

    self.nameLongLabel.text = thermostat.nameLong;


    if ([thermostat.temperatureScale isEqualToString:@"F"])
    {
        NSInteger ambientTemperatureF = thermostat.ambientTemperatureF;
        NSInteger targetTemperatureF  = thermostat.targetTemperatureF;
        self.currentTempValueLabel.text = [self formatFarenheitTemp:ambientTemperatureF];
        self.targetTempValueLabel.text = [self formatFarenheitTemp:targetTemperatureF];
    }
    else if ([thermostat.temperatureScale isEqualToString:@"C"])
    {
        CGFloat ambientTemperatureC = thermostat.ambientTemperatureC;
        CGFloat targetTemperatureC  = thermostat.targetTemperatureC;
        self.currentTempValueLabel.text = [self formatCelciumTemp: ambientTemperatureC];
        self.targetTempValueLabel.text = [self formatCelciumTemp:                                          targetTemperatureC];
    }


    if (thermostat.hasFan)
    {
        self.fanTimerSwitch.enabled = YES;
        self.fanTimerSwitch.on = thermostat.fanTimerActive;

        if (thermostat.fanTimerActive)
        {
            self.fanTimerLabel.text = @"Fan is on";
        }
        else
        {
            self.fanTimerLabel.text = @"Fan is off";
        }
    }
    else
    {
        self.fanTimerSwitch.enabled = NO;
        self.fanTimerLabel.text = @"Fan is disabled";
    }
}

- (NSString *)formatCelciumTemp:(CGFloat)temp
{
    NSString *celciumTemp = nil;
    CGFloat deltaTemp = fabs(temp - round(temp));
    if (deltaTemp == 0)
    {
        celciumTemp = [NSString stringWithFormat:@"%0.0lf", temp];
    }
    else if (deltaTemp == 0.5)
    {
        celciumTemp = [NSString stringWithFormat:@"%0.1lf", temp];
    }
    return celciumTemp;
}

- (NSString *)formatFarenheitTemp:(NSInteger)temp
{
    NSString *farenheitTemp = [NSString stringWithFormat:@"%lu", temp];
    return farenheitTemp;
}

- (void)saveThermostatChanges
{
    [self.nestThermostatManager saveChangesForThermostat:self.currentThermostat];
//    [self.delegate thermostatInfoChange:self.currentThermostat];
}

- (CGFloat)getValueBySlider:(UISlider *)slider
                    fromMin:(CGFloat)min
                      toMax:(CGFloat)max
                   withStep:(CGFloat)step
{
    // slider 0 1
    // ||-----|-----||-----|-----||
    CGFloat delta = step / 2.0;
    CGFloat currVal = min + (max - min) * slider.value;
    NSLog(@"currVal: %lf" , currVal);
    CGFloat roundDown = min - delta;
    CGFloat roundUp   = min + delta;
    CGFloat roundValue = -1.0f;
    for (;;)
    {
        roundDown += step;
        if (roundDown >= currVal)
        {
            roundValue = roundDown - delta;
            break;
        }
        roundUp += step;
        if (roundUp >= currVal)
        {
            roundValue = roundUp - delta;
            break;
        }
    }
    return roundValue;
}

- (void)sliderValueChanged:(UISlider *)sender
{
    if ([self.currentThermostat.temperatureScale isEqualToString:@"F"])
    {
        CGFloat tempF = [self getValueBySlider:sender
                                       fromMin:kMinTargetTempF
                                         toMax:kMaxTargetTempF
                                      withStep:kTargetTempStepF];
        self.targetTempValueLabel.text = [self formatFarenheitTemp:tempF];
    }
    else if ([self.currentThermostat.temperatureScale isEqualToString:@"C"])
    {
        CGFloat tempC = [self getValueBySlider:sender
                                       fromMin:kMinTargetTempC
                                         toMax:kMaxTargetTempC
                                      withStep:kTargetTempStepC];
        self.targetTempValueLabel.text = [self formatCelciumTemp:tempC];
    }

}

//- (void)equalizeSlider
//{
//    int range = (TEMP_MAX_VALUE - TEMP_MIN_VALUE);
//    int relative = (int)self.targetTempValueLabel - TEMP_MIN_VALUE;
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


@end
