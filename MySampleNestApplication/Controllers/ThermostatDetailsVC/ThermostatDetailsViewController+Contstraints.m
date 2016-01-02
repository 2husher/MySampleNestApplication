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
    self.currentTempLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *nameMap = @{ @"nameLongLabel" : self.nameLongLabel,
                               @"currentTemp" : self.currentTempLabel};

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
    self.currentTempValueLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *nameMap = @{ @"currentTemp" : self.currentTempLabel,
                               @"currentTempVal" : self.currentTempValueLabel };

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
    self.targetTempLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *nameMap = @{ @"targetTemp" : self.targetTempLabel,
                               @"currentTempVal" : self.currentTempValueLabel };

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
    self.targetTempValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.targetTempSlider.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *nameMap = @{ @"targetTemp" : self.targetTempLabel,
                               @"targetTempVal" : self.targetTempValueLabel,
                               @"targetSlider" : self.targetTempSlider };
    NSDictionary *metrics = @{ @"labelWidth" : @(self.targetTempValueLabel.frame.size.width) };

    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[targetTemp]-[targetTempVal]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalLabelConstraints];

    NSLayoutConstraint *verticalSliderConstraints =
    [NSLayoutConstraint constraintWithItem:self.targetTempSlider
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.targetTempValueLabel
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                  constant:0.0f];

    [self.view addConstraints:@[verticalSliderConstraints]];

    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[targetTempVal(labelWidth)]-[targetSlider]-|"
                                            options:0
                                            metrics:metrics
                                              views:nameMap];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupFanTimerLabelAndSwitchConstraints
{
    self.fanTimerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fanTimerSwitch.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *nameMap = @{ @"fanTimer" : self.fanTimerLabel,
                               @"targetTempVal" : self.targetTempValueLabel,
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
