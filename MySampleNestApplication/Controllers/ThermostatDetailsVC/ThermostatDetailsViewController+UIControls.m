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
    self.nameLongLabel.text = @"Thermostat name";
    [self.nameLongLabel sizeToFit];
    [self.view addSubview:self.nameLongLabel];

    self.nameLongLabel.translatesAutoresizingMaskIntoConstraints = NO;
    id topGuide = self.topLayoutGuide;
    NSDictionary *nameMap = @{ @"topGuide" : topGuide,
                               @"nameLongLabel" : self.nameLongLabel };
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-50-[nameLongLabel]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[nameLongLabel]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupCurrentTemperatureLabel
{
    self.currentTempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.currentTempLabel.text = @"Current temperature";
    [self.currentTempLabel sizeToFit];
    [self.view addSubview:self.currentTempLabel];

    self.currentTempLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"nameLongLabel" : self.nameLongLabel,
                               @"currentTemp" : self.currentTempLabel};
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLongLabel]-50-[currentTemp]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[currentTemp]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalConstraints];
}


- (void)setupCurrentTemperatureValueLabel
{
    self.currentTempValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.currentTempValueLabel.text = @"XXXX";
    [self.currentTempValueLabel sizeToFit];
    [self.view addSubview:self.currentTempValueLabel];

    self.currentTempValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"currentTemp" : self.currentTempLabel,
                               @"currentTempVal" : self.currentTempValueLabel };
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[currentTemp]-[currentTempVal]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[currentTempVal]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupTargetTemperatureLabel
{
    self.targetTempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetTempLabel.text = @"Target temperature";
    [self.targetTempLabel sizeToFit];
    [self.view addSubview:self.targetTempLabel];

    self.targetTempLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTemp" : self.targetTempLabel,
                               @"currentTempVal" : self.currentTempValueLabel };
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[currentTempVal]-50-[targetTemp]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[targetTemp]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupTargetTemperatureValueLabel
{
    self.targetTempValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetTempValueLabel.text = @"YYYY";
    [self.targetTempValueLabel sizeToFit];
    [self.view addSubview:self.targetTempValueLabel];

    self.targetTempValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTemp" : self.targetTempLabel,
                               @"targetTempVal" : self.targetTempValueLabel };
    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[targetTemp]-[targetTempVal]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalLabelConstraints];
}


- (void)setupTargetTemperatureSlider
{
    self.targetTempSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    self.targetTempSlider.minimumValue = 0.0f;
    self.targetTempSlider.maximumValue = 1.0f;

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

    self.targetTempSlider.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTemp" : self.targetTempLabel,
                               @"targetTempVal" : self.targetTempValueLabel,
                               @"targetSlider" : self.targetTempSlider };
    NSDictionary *metrics = @{ @"labelWidth" : @(self.targetTempValueLabel.frame.size.width) };
    NSLayoutConstraint *verticalSliderConstraints =
    [NSLayoutConstraint constraintWithItem:self.targetTempSlider
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.targetTempValueLabel
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                  constant:0.0f];
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[targetTempVal(labelWidth)]-[targetSlider]-|"
                                            options:0
                                            metrics:metrics
                                              views:nameMap];
    [self.view addConstraints:@[verticalSliderConstraints]];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupFanTimerLabel
{
    self.fanTimerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.fanTimerLabel.text = @"Timer is timer";
    [self.fanTimerLabel sizeToFit];
    [self.view addSubview:self.fanTimerLabel];

    self.fanTimerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"fanTimer" : self.fanTimerLabel,
                               @"targetTempVal" : self.targetTempValueLabel };
    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[targetTempVal]-50-[fanTimer]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalLabelConstraints];
}

- (void)setupFanTimerSwitch
{
    self.fanTimerSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.fanTimerSwitch addTarget:self
                        action:@selector(fanSwitched:)
              forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.fanTimerSwitch];

    self.fanTimerSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"fanTimer" : self.fanTimerLabel,
                               @"targetTempVal" : self.targetTempValueLabel,
                               @"fanSwitch" : self.fanTimerSwitch };
    NSLayoutConstraint *verticalSwitchConstraints =
    [NSLayoutConstraint constraintWithItem:self.fanTimerSwitch
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.fanTimerLabel
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                  constant:0.0f];
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[fanTimer]-[fanSwitch]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:@[verticalSwitchConstraints]];
    [self.view addConstraints:horizontalConstraints];
}

@end
