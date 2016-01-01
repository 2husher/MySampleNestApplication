//
//  ThermostatDetailsViewController+Contstraints.h
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "ThermostatDetailsViewController.h"

@interface ThermostatDetailsViewController (Contstraints)

- (void)setupNameLongLabelConstraints;
- (void)setupCurrentTemperatureLabelConstraints;
- (void)setupCurrentTemperatureValueLabelConstraints;
- (void)setupTargetTemperatureLabelConstraints;
- (void)setupTargetTemperatureValueLabelAndSliderConstraints;
- (void)setupFanTimerLabelAndSwitchConstraints;

@end
