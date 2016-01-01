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
@property (nonatomic, strong) UILabel *currentTemperatureLabel;
@property (nonatomic, strong) UILabel *currentTemperatureValueLabel;
@property (nonatomic, strong) UILabel *targetTemperatureLabel;
@property (nonatomic, strong) UILabel *targetTemperatureValueLabel;
@property (nonatomic, strong) UISlider *targetTemperatureSlider;
@property (nonatomic, strong) UILabel *fanTimerLabel;
@property (nonatomic, strong) UISwitch *fanTimerSwitch;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end
