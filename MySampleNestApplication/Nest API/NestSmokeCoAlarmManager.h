//
//  NestSmokeCoAlarmManager.h
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "SmokeCoAlarm.h"

@protocol NestSmokeCoAlarmManagerDelegate <NSObject>

- (void)smokeCoAlarmValuesChanged:(SmokeCoAlarm *)smokeCoAlarm;

@end

@interface NestSmokeCoAlarmManager : NSObject

@property (nonatomic, strong) id <NestSmokeCoAlarmManagerDelegate>delegate;
- (void)beginSubscriptionForSmokeCoAlarm:(SmokeCoAlarm *)SmokeCoAlarm;

@end
