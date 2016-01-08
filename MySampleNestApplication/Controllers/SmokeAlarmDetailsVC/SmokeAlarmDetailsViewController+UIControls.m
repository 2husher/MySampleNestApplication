//
//  SmokeAlarmDetailsViewController+UIControls.m
//  MySampleNestApplication
//
//  Created by X on 05/01/16.
//  Copyright (c) 2016 Alex Izotov. All rights reserved.
//

#import "SmokeAlarmDetailsViewController+UIControls.h"

@implementation SmokeAlarmDetailsViewController (UIControls)

- (void)setupNameLongLabel
{
    self.nameLongCaption = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLongCaption.text = @"Smoke CO alarm name";
    [self.nameLongCaption sizeToFit];
    [self.view addSubview:self.nameLongCaption];

    self.nameLongCaption.translatesAutoresizingMaskIntoConstraints = NO;
    id topGuide = self.topLayoutGuide;
    NSDictionary *nameMap = @{ @"topGuide" : topGuide,
                               @"nameLongCaption" : self.nameLongCaption };
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-50-[nameLongCaption]"
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

- (void)setupBatteryHealthCaption
{
    self.batteryHealthCaption = [[UILabel alloc] initWithFrame:CGRectZero];
    self.batteryHealthCaption.text = @"Battery Health";
    [self.batteryHealthCaption sizeToFit];
    [self.view addSubview:self.batteryHealthCaption];

    self.batteryHealthCaption.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"nameLongCaption" : self.nameLongCaption,
                               @"batteryHealthCaption" : self.batteryHealthCaption };
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLongCaption]-50-[batteryHealthCaption]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];
}

- (void)setupBatteryHealthValue
{
    self.batteryHealthValue = [[UILabel alloc] initWithFrame:CGRectZero];
    self.batteryHealthValue.text = @"value";
    [self.batteryHealthValue sizeToFit];
    [self.view addSubview:self.batteryHealthValue];

    self.batteryHealthValue.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *nameMap = @{ @"batteryHealthCaption" : self.batteryHealthCaption,
                               @"batteryHealthValue" : self.batteryHealthValue };
    NSLayoutConstraint *verticalConstraints =
    [NSLayoutConstraint constraintWithItem:self.batteryHealthValue
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.batteryHealthCaption
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                  constant:0.0f];
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[batteryHealthCaption]-[batteryHealthValue]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:@[verticalConstraints]];
    [self.view addConstraints:horizontalConstraints];
}

@end
