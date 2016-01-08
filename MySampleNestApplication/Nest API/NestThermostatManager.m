/**
 *  Copyright 2014 Nest Labs Inc. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#import "NestThermostatManager.h"
#import "NestAuthManager.h"
#import "FirebaseManager.h"

@interface NestThermostatManager ()

@end

static NSString *const kThermostatsPath = @"devices/thermostats";

static NSString *const kFanTimerActive = @"fan_timer_active";
static NSString *const kHasFan =  @"has_fan";
static NSString *const kTargetTemperatureF = @"target_temperature_f";
static NSString *const kAmbientTemperatureF = @"ambient_temperature_f";
static NSString *const kTargetTemperatureC = @"target_temperature_c";
static NSString *const kAmbientTemperatureC = @"ambient_temperature_c";

static NSString *const kTargetTemperatureHighF = @"target_temperature_high_f";
static NSString *const kTargetTemperatureLowF = @"target_temperature_low_f";
static NSString *const kTargetTemperatureHighC = @"target_temperature_high_c";
static NSString *const kTargetTemperatureLowC = @"target_temperature_low_c";

static NSString *const kNameLong = @"name_long";
static NSString *const kTemperatureScale = @"temperature_scale";
static NSString *const kHvacMode = @"hvac_mode";
static NSString *const kCanHeat = @"can_heat";
static NSString *const kCanCool = @"can_cool";

@implementation NestThermostatManager

/**
 * Sets up a new Firebase connection for the thermostat provided
 * and observes for any change in /devices/thermostats/thermostatId.
 * @param thermostat The thermostat you want to watch changes for.
 */
- (void)beginSubscriptionForThermostat:(Thermostat *)thermostat
{
    [[FirebaseManager sharedManager] addSubscriptionToURL:[NSString stringWithFormat:@"%@/%@/", kThermostatsPath, thermostat.thermostatId] withBlock:^(FDataSnapshot *snapshot) {
        [self updateThermostat:thermostat forStructure:snapshot.value];
    }];
}

/**
 * Parse thermostat structure and put it in the thermostat object.
 * Then send the updated object to the delegate.
 * @param thermostat The thermostat you wish to update.
 * @param structure The structure you wish to update the thermostat with.
 */
- (void)updateThermostat:(Thermostat *)thermostat forStructure:(NSDictionary *)structure
{
    if (structure[kTemperatureScale]){
        thermostat.temperatureScale = structure[kTemperatureScale];
    }
    if ([thermostat.temperatureScale isEqualToString:@"F"])
    {
        if (structure[kAmbientTemperatureF]){
            thermostat.ambientTemperatureF = [structure[kAmbientTemperatureF] integerValue];
        }
        if (structure[kTargetTemperatureF]){
            thermostat.targetTemperatureF = [structure[kTargetTemperatureF]integerValue];
        }
        if (structure[kTargetTemperatureHighF]){
            thermostat.targetTemperatureHighF = [structure[kTargetTemperatureHighF] integerValue];
        }
        if (structure[kTargetTemperatureLowF]){
            thermostat.targetTemperatureLowF = [structure[kTargetTemperatureLowF]integerValue];
        }
    }
    if ([thermostat.temperatureScale isEqualToString:@"C"])
    {
        if (structure[kAmbientTemperatureC]){
            thermostat.ambientTemperatureC = [structure[kAmbientTemperatureC] floatValue];
        }
        if (structure[kTargetTemperatureC]){
            thermostat.targetTemperatureC = [structure[kTargetTemperatureC] floatValue];
        }
        if (structure[kTargetTemperatureHighC]){
            thermostat.targetTemperatureHighC = [structure[kTargetTemperatureHighC] floatValue];
        }
        if (structure[kTargetTemperatureLowC]){
            thermostat.targetTemperatureLowC = [structure[kTargetTemperatureLowC]floatValue];
        }
    }
    if (structure[kHasFan]){
        thermostat.hasFan = [structure[kHasFan] boolValue];
    }
    if (structure[kFanTimerActive]){
        thermostat.fanTimerActive = [structure[kFanTimerActive] boolValue];
    }
    if (structure[kNameLong]){
        thermostat.nameLong = structure[kNameLong];
    }
    if (structure[kHvacMode])
    {
        thermostat.hvacMode = structure[kHvacMode];
    }
    if (structure[kCanHeat]){
        thermostat.canHeat = structure[kCanHeat];
    }
    if (structure[kCanCool]){
        thermostat.canCool = structure[kCanCool];
    }

    [self.delegate thermostatValuesChanged:thermostat];
}

/**
 * Sets the thermostat values by using the Firebase API.
 * @param thermostat The thermost you wish to save.
 * @see https://www.firebase.com/docs/transactions.html
 */
- (void)saveChangesForThermostat:(Thermostat *)thermostat
{
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];

    if ([thermostat.temperatureScale isEqualToString:@"F"])
    {
        values[kTargetTemperatureF] = [NSNumber numberWithInteger:thermostat.targetTemperatureF];
        values[kTargetTemperatureLowF] = [NSNumber numberWithInteger:thermostat.targetTemperatureLowF];
        values[kTargetTemperatureHighF] = [NSNumber numberWithInteger:thermostat.targetTemperatureHighF];
    }
    else if ([thermostat.temperatureScale isEqualToString:@"C"])
    {
        values[kTargetTemperatureC] = [NSNumber numberWithFloat:thermostat.targetTemperatureC];
        values[kTargetTemperatureLowC] = [NSNumber numberWithFloat:thermostat.targetTemperatureLowC];
        values[kTargetTemperatureHighC] = [NSNumber numberWithFloat:thermostat.targetTemperatureHighC];
    }
    values[kFanTimerActive] = [NSNumber numberWithBool:thermostat.fanTimerActive];
    values[kHvacMode] = thermostat.hvacMode;
    
    [[FirebaseManager sharedManager] setValues:values forURL:[NSString stringWithFormat:@"%@/%@/", kThermostatsPath, thermostat.thermostatId]];
    NSLog(@"Changes saved");
    
//    // IMPORTANT to set withLocalEvents to NO
//    // Read more here: https://www.firebase.com/docs/transactions.html
//    [self.fireBase runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
//        [currentData setValue:values];
//        return [FTransactionResult successWithValue:currentData];
//    } andCompletionBlock:^(NSError *error, BOOL committed, FDataSnapshot *snapshot) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        }
//    } withLocalEvents:NO];

}



@end
