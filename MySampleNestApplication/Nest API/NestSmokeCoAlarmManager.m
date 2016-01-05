//
//  NestSmokeCoAlarmManager.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "NestSmokeCoAlarmManager.h"
#import "FirebaseManager.h"

static NSString *const kNameLong = @"name_long";

static NSString *const kSmokeCoAlarmsPath = @"devices/smoke_co_alarms";
static NSString *const kBatteryHealth = @"battery_health";
static NSString *const kCoAlarmState = @"co_alarm_state";
static NSString *const kSmokeAlarmState = @"smoke_alarm_state";
static NSString *const kUiColorState = @"ui_color_state";

@implementation NestSmokeCoAlarmManager

- (void)beginSubscriptionForSmokeCoAlarm:(SmokeCoAlarm *)smokeCoAlarm
{
    [[FirebaseManager sharedManager] addSubscriptionToURL:[NSString stringWithFormat:@"%@/%@/",kSmokeCoAlarmsPath, smokeCoAlarm.smokeAlarmId] withBlock:^(FDataSnapshot *snapshot) {
        [self updateSmokeCoAlarm:smokeCoAlarm forStructure:snapshot.value];
    }];
}

- (void)updateSmokeCoAlarm:(SmokeCoAlarm *)smokeCoAlarm
              forStructure:(NSDictionary *)structure
{
    if (structure[kNameLong])
    {
        smokeCoAlarm.nameLong = structure[kNameLong];
    }
    if (structure[kBatteryHealth])
    {
        smokeCoAlarm.batteryHealth = structure[kBatteryHealth];
    }
    if (structure[kCoAlarmState])
    {
        smokeCoAlarm.coAlarmState = structure[kCoAlarmState];
    }
    if (structure[kSmokeAlarmState])
    {
        smokeCoAlarm.smokeAlarmState = structure[kSmokeAlarmState];
    }
    if (structure[kUiColorState])
    {
        smokeCoAlarm.uiColorState = structure[kUiColorState];
    }
    [self.delegate smokeCoAlarmValuesChanged:smokeCoAlarm];
}

@end
