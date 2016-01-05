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
    self.nameLongLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLongLabel.text = @"Smoke CO alarm name";
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

@end
