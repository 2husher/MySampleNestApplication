//
//  ThermostatDetailsViewController+Contstraints.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "ThermostatDetailsViewController+Contstraints.h"

@implementation ThermostatDetailsViewController (Contstraints)

- (void)setupNameLongLabelConstraints
{
    self.nameLongLabel.translatesAutoresizingMaskIntoConstraints = NO;

    id topGuide = self.topLayoutGuide;
    NSDictionary *nameMap = @{ @"topGuide" : topGuide,
                               @"nameLongLabel" : self.nameLongLabel };

    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-50-[nameLongLabel]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];

    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[nameLongLabel]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupCurrentTemperatureLabelConstraints
{
    self.currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *nameMap = @{ @"nameLongLabel" : self.nameLongLabel,
                               @"currentTemp" : self.currentTemperatureLabel};

    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLongLabel]-50-[currentTemp]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];

    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[currentTemp]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupCurrentTemperatureValueLabelConstraints
{
    self.currentTemperatureValueLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *nameMap = @{ @"currentTemp" : self.currentTemperatureLabel,
                               @"currentTempVal" : self.currentTemperatureValueLabel };

    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[currentTemp]-[currentTempVal]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];

    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[currentTempVal]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupTargetTemperatureLabelConstraints
{
    self.targetTemperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *nameMap = @{ @"targetTemp" : self.targetTemperatureLabel,
                               @"currentTempVal" : self.currentTemperatureValueLabel };

    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[currentTempVal]-50-[targetTemp]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];

    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[targetTemp]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupTargetTemperatureValueLabelAndSliderConstraints
{
    self.targetTemperatureValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.targetTemperatureSlider.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *nameMap = @{ @"targetTemp" : self.targetTemperatureLabel,
                               @"targetTempVal" : self.targetTemperatureValueLabel,
                               @"targetSlider" : self.targetTemperatureSlider };

    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[targetTemp]-[targetTempVal]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalLabelConstraints];

    NSLayoutConstraint *verticalSliderConstraints =
    [NSLayoutConstraint constraintWithItem:self.targetTemperatureSlider
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.targetTemperatureValueLabel
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                  constant:0.0f];

    [self.view addConstraints:@[verticalSliderConstraints]];

    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[targetTempVal]-[targetSlider]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupFanTimerLabelAndSwitchConstraints
{
    self.fanTimerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fanTimerSwitch.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *nameMap = @{ @"fanTimer" : self.fanTimerLabel,
                               @"targetTempVal" : self.targetTemperatureValueLabel,
                               @"fanSwitch" : self.fanTimerSwitch };

    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[targetTempVal]-50-[fanTimer]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalLabelConstraints];

    NSLayoutConstraint *verticalSwitchConstraints =
    [NSLayoutConstraint constraintWithItem:self.fanTimerSwitch
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.fanTimerLabel
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                  constant:0.0f];

    [self.view addConstraints:@[verticalSwitchConstraints]];

    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[fanTimer]-[fanSwitch]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:horizontalConstraints];
}

@end
