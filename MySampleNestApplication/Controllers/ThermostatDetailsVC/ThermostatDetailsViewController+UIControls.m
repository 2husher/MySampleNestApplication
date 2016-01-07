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
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-[nameLongLabel]"
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
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLongLabel]-[currentTemp]"
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

- (void)setupFanTimerLabel
{
    self.fanTimerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.fanTimerLabel.text = @"Timer is timer";
    [self.fanTimerLabel sizeToFit];
    [self.view addSubview:self.fanTimerLabel];

    self.fanTimerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"fanTimer" : self.fanTimerLabel,
                               @"currentTempVal" : self.currentTempValueLabel };
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

- (void)setupTargetTemperatureLabel
{
    self.targetTempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetTempLabel.text = @"Target temperature";
    [self.targetTempLabel sizeToFit];
    [self.view addSubview:self.targetTempLabel];

    self.targetTempLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTemp" : self.targetTempLabel,
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

- (void)setupTargetTempLowCaptionLabel
{
    self.targetTempLowCaptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetTempLowCaptionLabel.text = @"Target temperature low";
    [self.targetTempLowCaptionLabel sizeToFit];
    [self.view addSubview:self.targetTempLowCaptionLabel];

    self.targetTempLowCaptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempCaption" : self.targetTempLowCaptionLabel,
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

- (void)setupTargetTempLowValueLabel
{
    self.targetTempLowValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetTempLowValueLabel.text = @"YYYY";
    [self.targetTempLowValueLabel sizeToFit];
    [self.view addSubview:self.targetTempLowValueLabel];

    self.targetTempLowValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempCaption" : self.targetTempLowCaptionLabel,
                               @"targetTempVal" : self.targetTempLowValueLabel };
    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[targetTempCaption]-[targetTempVal]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalLabelConstraints];
}

- (void)setupTargetTempLowSlider
{
    self.targetTempLowSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    self.targetTempLowSlider.minimumValue = 0.0f;
    self.targetTempLowSlider.maximumValue = 1.0f;

    [self.targetTempLowSlider addTarget:self
                              action:@selector(sliderValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
    [self.targetTempLowSlider addTarget:self
                              action:@selector(sliderMoving:)
                    forControlEvents:UIControlEventTouchDown];
    [self.targetTempLowSlider addTarget:self
                              action:@selector(sliderLowValueSettled:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.targetTempLowSlider];

    self.targetTempLowSlider.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempVal" : self.targetTempLowValueLabel,
                               @"targetSlider" : self.targetTempLowSlider };
    NSDictionary *metrics = @{ @"labelWidth" : @(self.targetTempLowValueLabel.frame.size.width) };
    NSLayoutConstraint *verticalSliderConstraints =
    [NSLayoutConstraint constraintWithItem:self.targetTempLowSlider
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.targetTempLowValueLabel
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

- (void)setupTargetTempHighCaptionLabel
{
    self.targetTempHighCaptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetTempHighCaptionLabel.text = @"Target temperature high";
    [self.targetTempHighCaptionLabel sizeToFit];
    [self.view addSubview:self.targetTempHighCaptionLabel];

    self.targetTempHighCaptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempLowVal" : self.targetTempLowValueLabel,
                               @"targetTempHighCaption" : self.targetTempHighCaptionLabel };
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

- (void)setupTargetTempHighValueLabel
{
    self.targetTempHighValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetTempHighValueLabel.text = @"YYYY";
    [self.targetTempHighValueLabel sizeToFit];
    [self.view addSubview:self.targetTempHighValueLabel];

    self.targetTempHighValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempCaption" : self.targetTempHighCaptionLabel,
                               @"targetTempVal" : self.targetTempHighValueLabel };
    NSArray *verticalLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[targetTempCaption]-[targetTempVal]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalLabelConstraints];
}

- (void)setupTargetTempHighSlider
{
    self.targetTempHighSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    self.targetTempHighSlider.minimumValue = 0.0f;
    self.targetTempHighSlider.maximumValue = 1.0f;

    [self.targetTempHighSlider addTarget:self
                                 action:@selector(sliderHighValueChanged:)
                       forControlEvents:UIControlEventValueChanged];
    [self.targetTempHighSlider addTarget:self
                                 action:@selector(sliderHighMoving:)
                       forControlEvents:UIControlEventTouchDown];
    [self.targetTempHighSlider addTarget:self
                                 action:@selector(sliderHighValueSettled:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.targetTempHighSlider];

    self.targetTempHighSlider.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"targetTempVal" : self.targetTempHighValueLabel,
                               @"targetSlider" : self.targetTempHighSlider };
    NSDictionary *metrics = @{ @"labelWidth" : @(self.targetTempHighValueLabel.frame.size.width) };
    NSLayoutConstraint *verticalSliderConstraints =
    [NSLayoutConstraint constraintWithItem:self.targetTempHighSlider
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.targetTempHighValueLabel
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
