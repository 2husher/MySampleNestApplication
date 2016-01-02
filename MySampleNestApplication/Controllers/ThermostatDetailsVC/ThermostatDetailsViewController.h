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

@property (nonatomic, strong) UILabel *nameLongLabel;
@property (nonatomic, strong) UILabel *currentTempLabel;
@property (nonatomic, strong) UILabel *currentTempValueLabel;
@property (nonatomic, strong) UILabel *targetTempLabel;
@property (nonatomic, strong) UILabel *targetTempValueLabel;
@property (nonatomic, strong) UISlider *targetTempSlider;
@property (nonatomic, strong) UILabel *fanTimerLabel;
@property (nonatomic, strong) UISwitch *fanTimerSwitch;

//@property (nonatomic, strong) UIActivityIndicatorView *activity;

- (void)fanSwitched:(UISwitch *)sender;
- (void)sliderValueChanged:(UISlider *)sender;

@end
