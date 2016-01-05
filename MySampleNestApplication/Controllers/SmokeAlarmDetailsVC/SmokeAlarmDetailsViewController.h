//
//  SmokeAlarmDetailsViewController.h
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SmokeCoAlarm;

@interface SmokeAlarmDetailsViewController : UIViewController

@property (nonatomic, strong) SmokeCoAlarm *smokeAlarmItem;
@property (nonatomic, strong) UILabel *nameLongLabel;
@property (nonatomic, strong) UILabel *batteryHealthCaption;
@property (nonatomic, strong) UILabel *batteryHealthValue;

@end
