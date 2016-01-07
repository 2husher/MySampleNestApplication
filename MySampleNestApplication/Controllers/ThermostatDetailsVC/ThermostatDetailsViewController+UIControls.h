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
- (void)setupCurrentTemperatureLabel;
- (void)setupCurrentTemperatureValueLabel;
- (void)setupFanTimerLabel;
- (void)setupFanTimerSwitch;
- (void)setupHvacModeSegmentedControl;

- (void)setupTargetTemperatureLabel;
- (void)setupTargetTemperatureValueLabel;
- (void)setupTargetTemperatureSlider;

- (void)setupTargetTempLowCaptionLabel;
- (void)setupTargetTempLowValueLabel;
- (void)setupTargetTempLowSlider;

- (void)setupTargetTempHighCaptionLabel;
- (void)setupTargetTempHighValueLabel;
- (void)setupTargetTempHighSlider;

@end
