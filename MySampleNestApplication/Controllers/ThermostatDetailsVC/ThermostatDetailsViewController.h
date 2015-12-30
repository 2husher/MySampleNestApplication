//
//  ThermostatDetailsViewController.h
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Thermostat;

@interface ThermostatDetailsViewController : UIViewController

@property(strong, nonatomic) Thermostat *thermostatItem;

@property (nonatomic, strong) UILabel *thermostatNameLongLabel;

@end
