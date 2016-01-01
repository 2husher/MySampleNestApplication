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
    self.nameLongLabel.backgroundColor = [UIColor grayColor];
    self.nameLongLabel.text = @"Thermostat name";
    [self.nameLongLabel sizeToFit];
    [self.view addSubview:self.nameLongLabel];
}

- (void)setupCurrentTemperatureValueLabel
{
    self.currentTemperatureValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.currentTemperatureValueLabel.backgroundColor = [UIColor grayColor];
    self.currentTemperatureValueLabel.text = @"XX";
    [self.currentTemperatureValueLabel sizeToFit];
    [self.view addSubview:self.currentTemperatureValueLabel];
}

- (void)setupCurrentTemperatureLabel
{
    self.currentTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.currentTemperatureLabel.backgroundColor = [UIColor grayColor];
    self.currentTemperatureLabel.text = @"Current temperature";
    [self.currentTemperatureLabel sizeToFit];
    [self.view addSubview:self.currentTemperatureLabel];
}

- (void)setupTargetTemperatureValueLabel
{
    self.targetTemperatureValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetTemperatureValueLabel.backgroundColor = [UIColor grayColor];
    self.targetTemperatureValueLabel.text = @"YY";
    [self.targetTemperatureValueLabel sizeToFit];
    [self.view addSubview:self.targetTemperatureValueLabel];
}

- (void)setupTargetTemperatureLabel
{
    self.targetTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetTemperatureLabel.backgroundColor = [UIColor grayColor];
    self.targetTemperatureLabel.text = @"Target temperature";
    [self.targetTemperatureLabel sizeToFit];
    [self.view addSubview:self.targetTemperatureLabel];
}

- (void)setupTargetTemperatureSlider
{
    self.targetTemperatureSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    self.targetTemperatureSlider.minimumValue = 0.0f;
    self.targetTemperatureSlider.maximumValue = 100.0f;
    self.targetTemperatureSlider.value = self.targetTemperatureSlider.maximumValue / 2.0f;

    [self.targetTemperatureSlider addTarget:self
                    action:@selector(sliderChanged:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.targetTemperatureSlider];
}

- (void)setupFanTimerLabel
{
    self.fanTimerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.fanTimerLabel.backgroundColor = [UIColor grayColor];
    self.fanTimerLabel.text = @"Timer is timer";
    [self.fanTimerLabel sizeToFit];
    [self.view addSubview:self.fanTimerLabel];
}

- (void)setupFanTimerSwitch
{
    self.fanTimerSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.fanTimerSwitch addTarget:self
                        action:@selector(fanDidSwitch:)
              forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.fanTimerSwitch];
}

@end
