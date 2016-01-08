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
    self.nameLongCaption = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLongCaption.text = @"Thermostat name";
    [self.nameLongCaption sizeToFit];
    [self.view addSubview:self.nameLongCaption];

    self.nameLongCaption.translatesAutoresizingMaskIntoConstraints = NO;
    id topGuide = self.topLayoutGuide;
    NSDictionary *nameMap = @{ @"topGuide" : topGuide,
                               @"nameLongCaption" : self.nameLongCaption };
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-[nameLongCaption]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[nameLongCaption]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupCurrentTempCaption
{
    self.currentTempCaption = [[UILabel alloc] initWithFrame:CGRectZero];
    self.currentTempCaption.text = @"Current temperature";
    [self.currentTempCaption sizeToFit];
    [self.view addSubview:self.currentTempCaption];

    self.currentTempCaption.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"nameLongCaption" : self.nameLongCaption,
                               @"currentTemp" : self.currentTempCaption};
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLongCaption]-[currentTemp]"
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

- (void)setupCurrentTempValue
{
    self.currentTempValue = [[UILabel alloc] initWithFrame:CGRectZero];
    self.currentTempValue.text = @"XXXX";
    [self.currentTempValue sizeToFit];
    [self.view addSubview:self.currentTempValue];

    self.currentTempValue.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"currentTemp" : self.currentTempCaption,
                               @"currentTempVal" : self.currentTempValue };
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

- (void)setupFanTimerLabel
{
    self.fanTimerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.fanTimerLabel.text = @"Timer is timer";
    [self.fanTimerLabel sizeToFit];
    [self.view addSubview:self.fanTimerLabel];

    self.fanTimerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"fanTimer" : self.fanTimerLabel,
                               @"currentTempVal" : self.currentTempValue };
    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[currentTempVal]-[fanTimer]"
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

- (void)setupHvacModeSegmentedControl
{
    self.hvacModeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"off"]];
    [self.hvacModeSegmentedControl addTarget:self
                                     action:@selector(toggleControls:)
                           forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.hvacModeSegmentedControl];

    self.hvacModeSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"fanSwitch" : self.fanTimerSwitch,
                               @"hvacMode" : self.hvacModeSegmentedControl };
    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[fanSwitch]-[hvacMode]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[hvacMode]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalLabelConstraints];
}

- (void)setupTargetTempCaption
{
    self.targetTempCaption = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetTempCaption.text = @"Target temperature";
    [self.targetTempCaption sizeToFit];
    [self.view addSubview:self.targetTempCaption];

    self.targetTempCaption.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTemp" : self.targetTempCaption,
                               @"hvacMode" : self.hvacModeSegmentedControl};
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[hvacMode]-[targetTemp]"
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

- (void)setupTargetTempValue
{
    self.targetTempValue = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetTempValue.text = @"YYYY";
    [self.targetTempValue sizeToFit];
    [self.view addSubview:self.targetTempValue];

    self.targetTempValue.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTemp" : self.targetTempCaption,
                               @"targetTempVal" : self.targetTempValue };
    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[targetTemp]-[targetTempVal]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalLabelConstraints];
}

- (void)setupTargetTempSlider
{
    self.targetTempSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    self.targetTempSlider.minimumValue = 0.0f;
    self.targetTempSlider.maximumValue = 1.0f;

    [self.targetTempSlider addTarget:self
                              action:@selector(targetTempSliderValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
    [self.targetTempSlider addTarget:self
                              action:@selector(targetTempSliderMoving:)
                    forControlEvents:UIControlEventTouchDown];
    [self.targetTempSlider addTarget:self
                              action:@selector(targetTempSliderValueSettled:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.targetTempSlider];

    self.targetTempSlider.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTemp" : self.targetTempCaption,
                               @"targetTempVal" : self.targetTempValue,
                               @"targetSlider" : self.targetTempSlider };
    NSDictionary *metrics = @{ @"labelWidth" : @(self.targetTempValue.frame.size.width) };
    NSLayoutConstraint *verticalSliderConstraints =
    [NSLayoutConstraint constraintWithItem:self.targetTempSlider
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.targetTempValue
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

- (void)setupLowTempCaption
{
    self.lowTempCaption = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lowTempCaption.text = @"Target temperature low";
    [self.lowTempCaption sizeToFit];
    [self.view addSubview:self.lowTempCaption];

    self.lowTempCaption.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempCaption" : self.lowTempCaption,
                               @"hvacMode" : self.hvacModeSegmentedControl};
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[hvacMode]-[targetTempCaption]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[targetTempCaption]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupLowTempValue
{
    self.lowTempValue = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lowTempValue.text = @"YYYY";
    [self.lowTempValue sizeToFit];
    [self.view addSubview:self.lowTempValue];

    self.lowTempValue.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempCaption" : self.lowTempCaption,
                               @"targetTempVal" : self.lowTempValue };
    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[targetTempCaption]-[targetTempVal]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalLabelConstraints];
}

- (void)setupLowTempSlider
{
    self.lowTempSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    self.lowTempSlider.minimumValue = 0.0f;
    self.lowTempSlider.maximumValue = 1.0f;

    [self.lowTempSlider addTarget:self
                           action:@selector(lowTempSliderValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
    [self.lowTempSlider addTarget:self
                           action:@selector(lowTempSliderMoving:)
                 forControlEvents:UIControlEventTouchDown];
    [self.lowTempSlider addTarget:self
                           action:@selector(lowTempSliderValueSettled:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lowTempSlider];

    self.lowTempSlider.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempVal" : self.lowTempValue,
                               @"targetSlider" : self.lowTempSlider };
    NSDictionary *metrics = @{ @"labelWidth" : @(self.lowTempValue.frame.size.width) };
    NSLayoutConstraint *verticalSliderConstraints =
    [NSLayoutConstraint constraintWithItem:self.lowTempSlider
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.lowTempValue
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

- (void)setupHighTempCaption
{
    self.highTempCaption = [[UILabel alloc] initWithFrame:CGRectZero];
    self.highTempCaption.text = @"Target temperature high";
    [self.highTempCaption sizeToFit];
    [self.view addSubview:self.highTempCaption];

    self.highTempCaption.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempLowVal" : self.lowTempValue,
                               @"targetTempHighCaption" : self.highTempCaption };
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[targetTempLowVal]-[targetTempHighCaption]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[targetTempHighCaption]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalConstraints];
}

- (void)setupHighTempValue
{
    self.highTempValue = [[UILabel alloc] initWithFrame:CGRectZero];
    self.highTempValue.text = @"YYYY";
    [self.highTempValue sizeToFit];
    [self.view addSubview:self.highTempValue];

    self.highTempValue.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempCaption" : self.highTempCaption,
                               @"targetTempVal" : self.highTempValue };
    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[targetTempCaption]-[targetTempVal]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalLabelConstraints];
}

- (void)setupHighTempSlider
{
    self.highTempSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    self.highTempSlider.minimumValue = 0.0f;
    self.highTempSlider.maximumValue = 1.0f;

    [self.highTempSlider addTarget:self
                            action:@selector(highTempSliderValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    [self.highTempSlider addTarget:self
                            action:@selector(highTempSliderMoving:)
                  forControlEvents:UIControlEventTouchDown];
    [self.highTempSlider addTarget:self
                            action:@selector(highTempSliderValueSettled:)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.highTempSlider];

    self.highTempSlider.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempVal" : self.highTempValue,
                               @"targetSlider" : self.highTempSlider };
    NSDictionary *metrics = @{ @"labelWidth" : @(self.highTempValue.frame.size.width) };
    NSLayoutConstraint *verticalSliderConstraints =
    [NSLayoutConstraint constraintWithItem:self.highTempSlider
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.highTempValue
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

@end
