//
//  ThermostatDetailsViewController+UIControls.h
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "ThermostatDetailsViewController.h"

@interface ThermostatDetailsViewController (UIControls)

- (void)setupNameLongLabel;
- (void)setupCurrentTempCaption;
- (void)setupCurrentTempValue;
- (void)setupFanTimerLabel;
- (void)setupFanTimerSwitch;
- (void)setupHvacModeSegmentedControl;

- (void)setupTargetTempCaption;
- (void)setupTargetTempValue;
- (void)setupTargetTempSlider;

- (void)setupLowTempCaption;
- (void)setupLowTempValue;
- (void)setupLowTempSlider;

- (void)setupHighTempCaption;
- (void)setupHighTempValue;
- (void)setupHighTempSlider;

@end
