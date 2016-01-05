//
//  SmokeCoAlarm.h
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmokeCoAlarm : NSObject

@property (nonatomic, strong) NSString *smokeAlarmId;
@property (nonatomic, strong) NSString *nameLong;
@property (nonatomic, strong) NSString *batteryHealth;
@property (nonatomic, strong) NSString *coAlarmState;
@property (nonatomic, strong) NSString *smokeAlarmState;
@property (nonatomic, strong) NSString *uiColorState;

@end
