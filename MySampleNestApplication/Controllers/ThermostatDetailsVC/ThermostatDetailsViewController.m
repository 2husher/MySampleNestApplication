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

@property (nonatomic) BOOL isSlidingTargetTempSlider;
@property (nonatomic) BOOL isSlidingTargetLowTempSlider;
@property (nonatomic) BOOL isSlidingTargetHighTempSlider;

@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic) CGFloat ambientTemp;
@property (nonatomic) CGFloat targetTemp;
@property (nonatomic) CGFloat targetTempHigh;
@property (nonatomic) CGFloat targetTempLow;
@property (nonatomic) CGFloat minTargetTemp;
@property (nonatomic) CGFloat maxTargetTemp;
@property (nonatomic) CGFloat targetTempStep;
@property (nonatomic) CGFloat lowHighDelta;

@end

static const NSInteger kMinTargetTempF = 48;
static const NSInteger kMaxTargetTempF = 90;
static const NSInteger kTargetTempStepF = 1;
static const NSInteger kLowHighDeltaF = 3;

static const CGFloat kMinTargetTempC = 9.0f;
static const CGFloat kMaxTargetTempC = 32.0f;
static const CGFloat kTargetTempStepC = 0.5f;
static const NSInteger kLowHighDeltaC = 1.5f;

@implementation ThermostatDetailsViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setupNameLongLabel];
    [self setupCurrentTemperatureLabel];
    [self setupCurrentTemperatureValueLabel];
    [self setupFanTimerLabel];
    [self setupFanTimerSwitch];

    [self setupHvacModeSegmentedControl];

    [self setupTargetTemperatureLabel];
    [self setupTargetTemperatureValueLabel];
    [self setupTargetTemperatureSlider];
    
    [self setupTargetTempLowCaptionLabel];
    [self setupTargetTempLowValueLabel];
    [self setupTargetTempLowSlider];

    [self setupTargetTempHighCaptionLabel];
    [self setupTargetTempHighValueLabel];
    [self setupTargetTempHighSlider];

    self.loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loadingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Details";

    self.nestThermostatManager = [[NestThermostatManager alloc] init];
    self.nestThermostatManager.delegate = self;

    if (self.thermostatItem)
    {
        [self.loadingView showLoading];
        [self.nestThermostatManager beginSubscriptionForThermostat:self.thermostatItem];
    }
}

- (void)fanSwitched:(UISwitch *)sender
{
    self.currentThermostat.fanTimerActive = sender.isOn;
    [self saveThermostatChanges];
}

#pragma mark - NestThermostatManagerDelegate Method

- (void)thermostatValuesChanged:(Thermostat *)thermostat
{
    [self.loadingView hideLoading];
    self.currentThermostat = thermostat;

    NSLog(thermostat.canHeat ? @"can_heat: Yes" : @"can_heat: No");
    NSLog(thermostat.canCool ? @"can_cool: Yes" : @"can_cool: No");
    NSLog(thermostat.fanTimerActive ? @"fan_timer_active: Yes" : @"fan_timer_active: No");

    [self formatTempByScale:thermostat.temperatureScale];

    self.nameLongLabel.text = thermostat.nameLong;

    self.currentTempValueLabel.text = [self formattedTemp:self.ambientTemp];

    [self initFanControls:thermostat];
    [self initHvacModeSegmentedControl:thermostat];
    [self initTargetTempControls:thermostat];
    [self initTargetTempLowControls:thermostat];
    [self initTargetTempHighControls:thermostat];
}

#pragma mark - init controls Method

- (void)initTargetTempControls:(Thermostat *)thermostat
{
    self.targetTempValueLabel.text = [self formattedTemp:self.targetTemp];

    CGFloat targetTempSliderValue = [self sliderValueByThermostatTemp:self.targetTemp fromMinTemp:self.minTargetTemp toMaxTemp:self.maxTargetTemp];
    if (!self.isSlidingTargetTempSlider)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.targetTempSlider setValue:targetTempSliderValue animated:YES];
        }];
    }
}

- (void)initTargetTempLowControls:(Thermostat *)thermostat
{
    self.targetTempLowValueLabel.text = [self formattedTemp:self.targetTempLow];

    CGFloat targetTempLowSliderValue =
        [self sliderValueByThermostatTemp:self.targetTempLow
                              fromMinTemp:self.minTargetTemp
                                toMaxTemp:self.targetTempHigh - self.lowHighDelta];
    if (!self.isSlidingTargetLowTempSlider)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.targetTempLowSlider setValue:targetTempLowSliderValue animated:YES];
        }];
    }
}

- (void)initTargetTempHighControls:(Thermostat *)thermostat
{
    self.targetTempHighValueLabel.text = [self formattedTemp:self.targetTempHigh];

    CGFloat targetTempHighSliderValue =
        [self sliderValueByThermostatTemp:self.targetTempHigh
                              fromMinTemp:self.targetTempLow + self.lowHighDelta
                                toMaxTemp:self.maxTargetTemp];
    if (!self.isSlidingTargetHighTempSlider)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.targetTempHighSlider setValue:targetTempHighSliderValue animated:YES];
        }];
    }
}

- (void)initFanControls:(Thermostat *)thermostat
{
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

- (void)initHvacModeSegmentedControl:(Thermostat *)thermostat
{
    [self.hvacModeSegmentedControl removeAllSegments];
    NSMutableArray *hvacMode = [[NSMutableArray alloc] init];
    if (thermostat.canHeat)
    {
        [hvacMode addObject:@"heat"];
        if (thermostat.canCool)
        {
            [hvacMode addObject:@"cool"];
            [hvacMode addObject:@"heat-cool"];
        }
    }
    else if (thermostat.canCool)
    {
        [hvacMode addObject:@"cool"];
    }
    [hvacMode addObject:@"off"];
    NSUInteger len = [hvacMode count];
    for (NSUInteger i = 0; i < len; i++)
    {
        [self.hvacModeSegmentedControl insertSegmentWithTitle:hvacMode[i] atIndex:i animated:NO];
    }
    self.hvacModeSegmentedControl.selectedSegmentIndex = [hvacMode indexOfObject:thermostat.hvacMode];
    [self showHideControlsByHvacMode:thermostat.hvacMode];
}

- (void) formatTempByScale:(NSString *)temperatureScale
{
    Thermostat *thermostat = self.currentThermostat;
    if ([temperatureScale isEqualToString:@"F"])
    {
        self.ambientTemp = thermostat.ambientTemperatureF;
        self.targetTemp  = thermostat.targetTemperatureF;
        self.targetTempHigh = thermostat.targetTemperatureHighF;
        self.targetTempLow  = thermostat.targetTemperatureLowF;
        self.maxTargetTemp  = kMaxTargetTempF;
        self.minTargetTemp  = kMinTargetTempF;
        self.targetTempStep = kTargetTempStepF;
        self.lowHighDelta = kLowHighDeltaF;
    }
    else if ([temperatureScale isEqualToString:@"C"])
    {
        self.ambientTemp = thermostat.ambientTemperatureC;
        self.targetTemp  = thermostat.targetTemperatureC;
        self.targetTempHigh = thermostat.targetTemperatureHighC;
        self.targetTempLow  = thermostat.targetTemperatureLowC;
        self.maxTargetTemp  = kMaxTargetTempC;
        self.minTargetTemp  = kMinTargetTempC;
        self.targetTempStep = kTargetTempStepC;
        self.lowHighDelta = kLowHighDeltaC;
    }
}

#pragma mark - formatted Methods

- (NSString *)formattedTemp:(CGFloat)temperature
{
    Thermostat *thermostat =  self.currentThermostat;
    if ([thermostat.temperatureScale isEqualToString:@"F"])
    {
        return [self formattedFarenheitTemp:temperature];
    }
    else if ([thermostat.temperatureScale isEqualToString:@"C"])
    {
        return [self formattedCelciumTemp:temperature];
    }
    return nil;
}

- (NSString *)formattedCelciumTemp:(CGFloat)temp
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

- (NSString *)formattedFarenheitTemp:(NSInteger)temp
{
    NSString *farenheitTemp = [NSString stringWithFormat:@"%lu", temp];
    return farenheitTemp;
}

- (void)saveThermostatChanges
{
    [self.nestThermostatManager saveChangesForThermostat:self.currentThermostat];
}

#pragma mark - change slider by thermostat

- (CGFloat)sliderValueByThermostatTemp:(CGFloat)temperature
                           fromMinTemp:(CGFloat)min
                             toMaxTemp:(CGFloat)max
{
    CGFloat range = max - min;
    CGFloat offset = temperature - min;
    return offset / range;
}

#pragma mark - changes by sliders

- (CGFloat)getValueBySlider:(UISlider *)slider
                fromMinTemp:(CGFloat)min
                  toMaxTemp:(CGFloat)max
{
    // slider 0 1
    // ||-----|-----||-----|-----||
    CGFloat delta = self.targetTempStep / 2.0;
    CGFloat currVal = min + (max - min) * slider.value;
    CGFloat roundDown = min - delta;
    CGFloat roundUp   = min + delta;
    CGFloat roundValue = -1.0f;
    for (;;)
    {
        roundDown += self.targetTempStep;
        if (roundDown >= currVal)
        {
            roundValue = roundDown - delta;
            break;
        }
        roundUp += self.targetTempStep;
        if (roundUp >= currVal)
        {
            roundValue = roundUp - delta;
            break;
        }
    }
    return roundValue;
}

- (void)targetSliderValueChanged:(UISlider *)sender
{
    CGFloat temp = [self getValueBySlider:sender
                              fromMinTemp:self.minTargetTemp
                                toMaxTemp:self.maxTargetTemp];
    self.targetTempValueLabel.text = [self formattedTemp:temp];
}

- (void)sliderLowValueChanged:(UISlider *)sender
{
    CGFloat temp = [self getValueBySlider:sender
                              fromMinTemp:self.minTargetTemp
                                toMaxTemp:self.targetTempHigh - self.lowHighDelta];
    self.targetTempLowValueLabel.text = [self formattedTemp:temp];
}

- (void)sliderHighValueChanged:(UISlider *)sender
{
    CGFloat temp = [self getValueBySlider:sender
                              fromMinTemp:self.targetTempLow + self.lowHighDelta
                                toMaxTemp:self.maxTargetTemp];
    self.targetTempHighValueLabel.text = [self formattedTemp:temp];
}

- (void)targetSliderMoving:(UISlider *)sender
{
    self.isSlidingTargetTempSlider = YES;
}

- (void)sliderLowMoving:(UISlider *)sender
{
    self.isSlidingTargetLowTempSlider = YES;
}

- (void)sliderHighMoving:(UISlider *)sender
{
    self.isSlidingTargetHighTempSlider = YES;
}

- (void)targetSliderValueSettled:(UISlider *)sender
{
    self.isSlidingTargetTempSlider = NO;

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

- (void)sliderLowValueSettled:(UISlider *)sender
{
    self.isSlidingTargetLowTempSlider = NO;

    if ([self.currentThermostat.temperatureScale isEqualToString:@"F"])
    {
        self.currentThermostat.targetTemperatureLowF = [self.targetTempLowValueLabel.text integerValue];
    }
    else if ([self.currentThermostat.temperatureScale isEqualToString:@"C"])
    {
        self.currentThermostat.targetTemperatureLowC = [self.targetTempLowValueLabel.text floatValue];
    }
    [self saveThermostatChanges];
}

- (void)sliderHighValueSettled:(UISlider *)sender
{
    self.isSlidingTargetHighTempSlider = NO;

    if ([self.currentThermostat.temperatureScale isEqualToString:@"F"])
    {
        self.currentThermostat.targetTemperatureHighF = [self.targetTempHighValueLabel.text integerValue];
    }
    else if ([self.currentThermostat.temperatureScale isEqualToString:@"C"])
    {
        self.currentThermostat.targetTemperatureHighC = [self.targetTempHighValueLabel.text floatValue];
    }
    [self saveThermostatChanges];
}

- (void)toggleControls:(UISegmentedControl *)sender
{
    NSString *hvacMode = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    [self showHideControlsByHvacMode:hvacMode];
    self.currentThermostat.hvacMode = hvacMode;
    [self saveThermostatChanges];
}

- (void)showHideControlsByHvacMode:(NSString *)hvacMode
{
    if ([hvacMode isEqualToString:@"heat"] ||
        [hvacMode isEqualToString:@"cool"])
    {
        self.targetTempLabel.hidden = NO;
        self.targetTempSlider.hidden = NO;
        self.targetTempValueLabel.hidden = NO;

        self.targetTempLowCaptionLabel.hidden = YES;
        self.targetTempLowValueLabel.hidden = YES;
        self.targetTempLowSlider.hidden = YES;

        self.targetTempHighCaptionLabel.hidden = YES;
        self.targetTempHighSlider.hidden = YES;
        self.targetTempHighValueLabel.hidden = YES;
    }
    else if ([hvacMode isEqualToString:@"heat-cool"])
    {
        self.targetTempLabel.hidden = YES;
        self.targetTempSlider.hidden = YES;
        self.targetTempValueLabel.hidden = YES;

        self.targetTempLowCaptionLabel.hidden = NO;
        self.targetTempLowValueLabel.hidden = NO;
        self.targetTempLowSlider.hidden = NO;

        self.targetTempHighCaptionLabel.hidden = NO;
        self.targetTempHighSlider.hidden = NO;
        self.targetTempHighValueLabel.hidden = NO;
    }
    else if ([hvacMode isEqualToString:@"off"])
    {
        self.targetTempLabel.hidden = YES;
        self.targetTempSlider.hidden = YES;
        self.targetTempValueLabel.hidden = YES;

        self.targetTempLowCaptionLabel.hidden = YES;
        self.targetTempLowValueLabel.hidden = YES;
        self.targetTempLowSlider.hidden = YES;

        self.targetTempHighCaptionLabel.hidden = YES;
        self.targetTempHighSlider.hidden = YES;
        self.targetTempHighValueLabel.hidden = YES;
    }
}

@end
