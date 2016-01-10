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
@property (nonatomic) BOOL isSlidingLowTempSlider;
@property (nonatomic) BOOL isSlidingHighTempSlider;

@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic) CGFloat ambientTemp;
@property (nonatomic) CGFloat targetTemp;
@property (nonatomic) CGFloat highTemp;
@property (nonatomic) CGFloat lowTemp;
@property (nonatomic) CGFloat minTemp;
@property (nonatomic) CGFloat maxTemp;
@property (nonatomic) CGFloat tempStep;
@property (nonatomic) CGFloat diffLowHighTemp;

@end

static const NSInteger kMinTempF = 50;
static const NSInteger kMaxTempF = 90;
static const NSInteger kTempStepF = 1;
static const NSInteger kDiffLowHighTempF = 3;

static const CGFloat kMinTempC = 9.0f;
static const CGFloat kMaxTempC = 32.0f;
static const CGFloat kTempStepC = 0.5f;
static const CGFloat kDiffLowHighTempC = 1.5f;

@implementation ThermostatDetailsViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setupNameLongLabel];

    [self setupTempScaleCaption];
    [self setupTempScaleValue];

    [self setupCurrentTempCaption];
    [self setupCurrentTempValue];

    [self setupFanTimerLabel];
    [self setupFanTimerSwitch];

    [self setupHvacModeSegmentedControl];

    [self setupTargetTempCaption];
    [self setupTargetTempValue];
    [self setupTargetTempSlider];
    
    [self setupLowTempCaption];
    [self setupLowTempValue];
    [self setupLowTempSlider];

    [self setupHighTempCaption];
    [self setupHighTempValue];
    [self setupHighTempSlider];

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

    self.nameLongCaption.text = thermostat.nameLong;
    self.tempScaleValue.text = thermostat.temperatureScale;
    self.currentTempValue.text = [self formattedTemp:self.ambientTemp];

    [self initFanControls];
    [self initHvacModeSegmentedControl];
    [self initTargetTempControls];
    [self initLowTempControls];
    [self initHighTempControls];
}

#pragma mark - init controls Method

- (void)initTargetTempControls
{
    self.targetTempValue.text = [self formattedTemp:self.targetTemp];

    CGFloat targetTempSliderValue = [self sliderValueByThermostatTemp:self.targetTemp fromMinTemp:self.minTemp toMaxTemp:self.maxTemp];
    if (!self.isSlidingTargetTempSlider)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.targetTempSlider setValue:targetTempSliderValue animated:YES];
        }];
    }
}

- (void)initLowTempControls
{
    self.lowTempValue.text = [self formattedTemp:self.lowTemp];

    CGFloat targetTempLowSliderValue =
        [self sliderValueByThermostatTemp:self.lowTemp
                              fromMinTemp:self.minTemp
                                toMaxTemp:self.highTemp - self.diffLowHighTemp];
    if (!self.isSlidingLowTempSlider)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.lowTempSlider setValue:targetTempLowSliderValue animated:YES];
        }];
    }
}

- (void)initHighTempControls
{
    self.highTempValue.text = [self formattedTemp:self.highTemp];

    CGFloat targetTempHighSliderValue =
        [self sliderValueByThermostatTemp:self.highTemp
                              fromMinTemp:self.lowTemp + self.diffLowHighTemp
                                toMaxTemp:self.maxTemp];
    if (!self.isSlidingHighTempSlider)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.highTempSlider setValue:targetTempHighSliderValue animated:YES];
        }];
    }
}

- (void)initFanControls
{
    Thermostat *thermostat = self.currentThermostat;
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

- (void)initHvacModeSegmentedControl
{
    Thermostat *thermostat = self.currentThermostat;
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
    [self toggleControlsByHvacMode:thermostat.hvacMode];
}

- (void) formatTempByScale:(NSString *)temperatureScale
{
    Thermostat *thermostat = self.currentThermostat;
    if ([temperatureScale isEqualToString:@"F"])
    {
        self.ambientTemp = thermostat.ambientTemperatureF;
        self.targetTemp  = thermostat.targetTemperatureF;
        self.highTemp = thermostat.targetTemperatureHighF;
        self.lowTemp  = thermostat.targetTemperatureLowF;
        self.maxTemp  = kMaxTempF;
        self.minTemp  = kMinTempF;
        self.tempStep = kTempStepF;
        self.diffLowHighTemp = kDiffLowHighTempF;
    }
    else if ([temperatureScale isEqualToString:@"C"])
    {
        self.ambientTemp = thermostat.ambientTemperatureC;
        self.targetTemp  = thermostat.targetTemperatureC;
        self.highTemp = thermostat.targetTemperatureHighC;
        self.lowTemp  = thermostat.targetTemperatureLowC;
        self.maxTemp  = kMaxTempC;
        self.minTemp  = kMinTempC;
        self.tempStep = kTempStepC;
        self.diffLowHighTemp = kDiffLowHighTempC;
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
    if (range == 0)
        return 0.5f;
    CGFloat offset = temperature - min;
    return offset / range;
}

#pragma mark - changes by sliders

- (CGFloat)valueBySlider:(UISlider *)slider
             fromMinTemp:(CGFloat)min
               toMaxTemp:(CGFloat)max
{
    // slider 0 1
    // ||-----|-----||-----|-----||
    CGFloat delta = self.tempStep / 2.0;
    CGFloat currVal = min + (max - min) * slider.value;
    CGFloat roundDown = min - delta;
    CGFloat roundUp   = min + delta;
    CGFloat roundValue = -1.0f;
    for (;;)
    {
        roundDown += self.tempStep;
        if (roundDown >= currVal)
        {
            roundValue = roundDown - delta;
            break;
        }
        roundUp += self.tempStep;
        if (roundUp >= currVal)
        {
            roundValue = roundUp - delta;
            break;
        }
    }
    return roundValue;
}

- (void)targetTempSliderValueChanged:(UISlider *)sender
{
    CGFloat temp = [self valueBySlider:sender
                           fromMinTemp:self.minTemp
                             toMaxTemp:self.maxTemp];
    self.targetTempValue.text = [self formattedTemp:temp];
}

- (void)lowTempSliderValueChanged:(UISlider *)sender
{
    CGFloat temp = [self valueBySlider:sender
                           fromMinTemp:self.minTemp
                             toMaxTemp:self.highTemp - self.diffLowHighTemp];
    self.lowTempValue.text = [self formattedTemp:temp];
}

- (void)highTempSliderValueChanged:(UISlider *)sender
{
    CGFloat temp = [self valueBySlider:sender
                           fromMinTemp:self.lowTemp + self.diffLowHighTemp
                             toMaxTemp:self.maxTemp];
    self.highTempValue.text = [self formattedTemp:temp];
}

- (void)targetTempSliderMoving:(UISlider *)sender
{
    self.isSlidingTargetTempSlider = YES;
}

- (void)lowTempSliderMoving:(UISlider *)sender
{
    self.isSlidingLowTempSlider = YES;
}

- (void)highTempSliderMoving:(UISlider *)sender
{
    self.isSlidingHighTempSlider = YES;
}

- (void)targetTempSliderValueSettled:(UISlider *)sender
{
    self.isSlidingTargetTempSlider = NO;

    if ([self.currentThermostat.temperatureScale isEqualToString:@"F"])
    {
        self.currentThermostat.targetTemperatureF = [self.targetTempValue.text integerValue];
    }
    else if ([self.currentThermostat.temperatureScale isEqualToString:@"C"])
    {
        self.currentThermostat.targetTemperatureC = [self.targetTempValue.text floatValue];
    }
    [self saveThermostatChanges];
}

- (void)lowTempSliderValueSettled:(UISlider *)sender
{
    self.isSlidingLowTempSlider = NO;

    if ([self.currentThermostat.temperatureScale isEqualToString:@"F"])
    {
        self.currentThermostat.targetTemperatureLowF = [self.lowTempValue.text integerValue];
    }
    else if ([self.currentThermostat.temperatureScale isEqualToString:@"C"])
    {
        self.currentThermostat.targetTemperatureLowC = [self.lowTempValue.text floatValue];
    }
    [self saveThermostatChanges];
}

- (void)highTempSliderValueSettled:(UISlider *)sender
{
    self.isSlidingHighTempSlider = NO;

    if ([self.currentThermostat.temperatureScale isEqualToString:@"F"])
    {
        self.currentThermostat.targetTemperatureHighF = [self.highTempValue.text integerValue];
    }
    else if ([self.currentThermostat.temperatureScale isEqualToString:@"C"])
    {
        self.currentThermostat.targetTemperatureHighC = [self.highTempValue.text floatValue];
    }
    [self saveThermostatChanges];
}

- (void)toggleControls:(UISegmentedControl *)sender
{
    NSString *hvacMode = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    [self toggleControlsByHvacMode:hvacMode];
    self.currentThermostat.hvacMode = hvacMode;
    [self saveThermostatChanges];
}

- (void)toggleControlsByHvacMode:(NSString *)hvacMode
{
    if ([hvacMode isEqualToString:@"heat"] ||
        [hvacMode isEqualToString:@"cool"])
    {
        self.targetTempCaption.hidden = NO;
        self.targetTempSlider.hidden = NO;
        self.targetTempValue.hidden = NO;

        self.lowTempCaption.hidden = YES;
        self.lowTempValue.hidden = YES;
        self.lowTempSlider.hidden = YES;

        self.highTempCaption.hidden = YES;
        self.highTempSlider.hidden = YES;
        self.highTempValue.hidden = YES;
    }
    else if ([hvacMode isEqualToString:@"heat-cool"])
    {
        self.targetTempCaption.hidden = YES;
        self.targetTempSlider.hidden = YES;
        self.targetTempValue.hidden = YES;

        self.lowTempCaption.hidden = NO;
        self.lowTempValue.hidden = NO;
        self.lowTempSlider.hidden = NO;

        self.highTempCaption.hidden = NO;
        self.highTempSlider.hidden = NO;
        self.highTempValue.hidden = NO;
    }
    else if ([hvacMode isEqualToString:@"off"])
    {
        self.targetTempCaption.hidden = YES;
        self.targetTempSlider.hidden = YES;
        self.targetTempValue.hidden = YES;

        self.lowTempCaption.hidden = YES;
        self.lowTempValue.hidden = YES;
        self.lowTempSlider.hidden = YES;

        self.highTempCaption.hidden = YES;
        self.highTempSlider.hidden = YES;
        self.highTempValue.hidden = YES;
    }
}

@end
