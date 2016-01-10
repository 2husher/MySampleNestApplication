//
//  ThermostatDetailsViewController.h
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Thermostat;

@interface ThermostatDetailsViewController : UIViewController

@property(strong, nonatomic) Thermostat *thermostatItem;

@property (nonatomic, strong) UILabel *nameLongCaption;

@property (nonatomic, strong) UILabel *tempScaleCaption;
@property (nonatomic, strong) UILabel *tempScaleValue;

@property (nonatomic, strong) UILabel *currentTempCaption;
@property (nonatomic, strong) UILabel *currentTempValue;

@property (nonatomic, strong) UILabel *fanTimerLabel;
@property (nonatomic, strong) UISwitch *fanTimerSwitch;

@property (nonatomic, strong) UISegmentedControl *hvacModeSegmentedControl;
@property (nonatomic, strong) UILabel *targetTempCaption;
@property (nonatomic, strong) UILabel *targetTempValue;
@property (nonatomic, strong) UISlider *targetTempSlider;

@property (nonatomic, strong) UILabel *lowTempCaption;
@property (nonatomic, strong) UILabel *lowTempValue;
@property (nonatomic, strong) UISlider *lowTempSlider;

@property (nonatomic, strong) UILabel *highTempCaption;
@property (nonatomic, strong) UILabel *highTempValue;
@property (nonatomic, strong) UISlider *highTempSlider;

- (void)fanSwitched:(UISwitch *)sender;

- (void)targetTempSliderValueChanged:(UISlider *)sender;
- (void)targetTempSliderMoving:(UISlider *)sender;
- (void)targetTempSliderValueSettled:(UISlider *)sender;

- (void)lowTempSliderValueChanged:(UISlider *)sender;
- (void)lowTempSliderMoving:(UISlider *)sender;
- (void)lowTempSliderValueSettled:(UISlider *)sender;

- (void)highTempSliderValueChanged:(UISlider *)sender;
- (void)highTempSliderMoving:(UISlider *)sender;
- (void)highTempSliderValueSettled:(UISlider *)sender;

- (void)toggleControls:(UISegmentedControl *)sender;

@end
