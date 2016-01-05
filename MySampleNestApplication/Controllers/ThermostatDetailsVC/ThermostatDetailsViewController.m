//
//  ThermostatDetailsViewController.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "ThermostatDetailsViewController.h"
#import "ThermostatDetailsViewController+UIControls.h"
#import "NestThermostatManager.h"
#import "LoadingView.h"

@interface ThermostatDetailsViewController ()<NestThermostatManagerDelegate>

@property (nonatomic, strong) NestThermostatManager *nestThermostatManager;
@property (nonatomic, strong) Thermostat *currentThermostat;
@property (nonatomic) BOOL isSlidingSlider;
@property (nonatomic, strong) LoadingView *loadingView;

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
    [self setupCurrentTemperatureLabel];
    [self setupCurrentTemperatureValueLabel];
    [self setupTargetTemperatureLabel];
    [self setupTargetTemperatureValueLabel];
    [self setupTargetTemperatureSlider];
    [self setupFanTimerLabel];
    [self setupFanTimerSwitch];

    self.loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loadingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Details";

    self.nestThermostatManager = [[NestThermostatManager alloc] init];
    self.nestThermostatManager.delegate = self;

    [self subscribeToThermostat:self.thermostatItem];
}

- (void)subscribeToThermostat:(Thermostat *)thermostat
{
    if (thermostat)
    {
        [self.loadingView showLoading];
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
    [self.loadingView hideLoading];
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

    CGFloat sliderValue = [self getSliderValue:thermostat];
    if (!self.isSlidingSlider)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.targetTempSlider setValue:sliderValue animated:YES];
        }];
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

- (CGFloat)getSliderValue:(Thermostat *)thermostat
{
    CGFloat targetTemp  = -1;
    CGFloat sliderValue = -1;
    if ([thermostat.temperatureScale isEqualToString:@"F"])
    {
        targetTemp = thermostat.targetTemperatureF;
        sliderValue = [self getSliderValueFromTargetTemp:targetTemp
                                                 withMin:kMinTargetTempF
                                                  andMax:kMaxTargetTempF];
    }
    else if ([thermostat.temperatureScale isEqualToString:@"C"])
    {
        targetTemp = thermostat.targetTemperatureC;
        sliderValue = [self getSliderValueFromTargetTemp:targetTemp
                                                 withMin:kMinTargetTempC
                                                  andMax:kMaxTargetTempC];
    }
    return sliderValue;
}

- (CGFloat)getSliderValueFromTargetTemp:(CGFloat)targetTemp
                                withMin:(CGFloat)min
                                 andMax:(CGFloat)max
{
    CGFloat range = max - min;
    CGFloat offset = targetTemp - min;
    return offset / range;
}

- (void)sliderMoving:(UISlider *)sender
{
    self.isSlidingSlider = YES;
}

- (void)sliderValueSettled:(UISlider *)sender
{
    self.isSlidingSlider = NO;

    if ([self.currentThermostat.temperatureScale isEqualToString:@"F"])
    {
        self.currentThermostat.targetTemperatureF = [self.targetTempValueLabel.text integerValue];
    }
    else if ([self.currentThermostat.temperatureScale isEqualToString:@"C"])
    {
        self.currentThermostat.targetTemperatureC = [self.targetTempValueLabel.text floatValue];
    }
    [self saveThermostatChanges];
}

@end
