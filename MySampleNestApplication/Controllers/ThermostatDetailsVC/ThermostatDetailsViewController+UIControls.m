//
//  ThermostatDetailsViewController+UIControls.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "ThermostatDetailsViewController+UIControls.h"

@implementation ThermostatDetailsViewController (UIControls)

- (void)setupNameLongLabel
{
    self.nameLongLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.nameLongLabel.backgroundColor = [UIColor grayColor];
    self.nameLongLabel.text = @"Thermostat name";
    [self.nameLongLabel sizeToFit];
    [self.view addSubview:self.nameLongLabel];
}

- (void)setupCurrentTemperatureValueLabel
{
    self.currentTempValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.currentTempValueLabel.backgroundColor = [UIColor grayColor];
    self.currentTempValueLabel.text = @"XXXX";
    [self.currentTempValueLabel sizeToFit];
    [self.view addSubview:self.currentTempValueLabel];
}

- (void)setupCurrentTemperatureLabel
{
    self.currentTempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
 //   self.currentTempLabel.backgroundColor = [UIColor grayColor];
    self.currentTempLabel.text = @"Current temperature";
    [self.currentTempLabel sizeToFit];
    [self.view addSubview:self.currentTempLabel];
}

- (void)setupTargetTemperatureValueLabel
{
    self.targetTempValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.targetTempValueLabel.backgroundColor = [UIColor grayColor];
    self.targetTempValueLabel.text = @"YYYY";
    [self.targetTempValueLabel sizeToFit];
    [self.view addSubview:self.targetTempValueLabel];
}

- (void)setupTargetTemperatureLabel
{
    self.targetTempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  //  self.targetTempLabel.backgroundColor = [UIColor grayColor];
    self.targetTempLabel.text = @"Target temperature";
    [self.targetTempLabel sizeToFit];
    [self.view addSubview:self.targetTempLabel];
}

- (void)setupTargetTemperatureSlider
{
    self.targetTempSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    self.targetTempSlider.minimumValue = 0.0f;
    self.targetTempSlider.maximumValue = 1.0f;
   // self.targetTempSlider.value = self.targetTempSlider.maximumValue / 2.0f;

    [self.targetTempSlider addTarget:self
                              action:@selector(sliderValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
    [self.targetTempSlider addTarget:self
                              action:@selector(sliderMoving:)
                    forControlEvents:UIControlEventTouchDown];
    [self.targetTempSlider addTarget:self
                              action:@selector(sliderValueSettled:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.targetTempSlider];
}

- (void)setupFanTimerLabel
{
    self.fanTimerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //self.fanTimerLabel.backgroundColor = [UIColor grayColor];
    self.fanTimerLabel.text = @"Timer is timer";
    [self.fanTimerLabel sizeToFit];
    [self.view addSubview:self.fanTimerLabel];
}

- (void)setupFanTimerSwitch
{
    self.fanTimerSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.fanTimerSwitch addTarget:self
                        action:@selector(fanSwitched:)
              forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.fanTimerSwitch];
}

@end
