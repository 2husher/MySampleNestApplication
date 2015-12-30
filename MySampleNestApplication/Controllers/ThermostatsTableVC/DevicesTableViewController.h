//
//  DevicesTableViewController.h
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThermostatDetailsViewController;
@class SmokeAlarmDetailsViewController;
@class ThermostatsTableView;

@interface DevicesTableViewController : UIViewController

@property (nonatomic, strong) ThermostatDetailsViewController *thermostatDetailsVC;
@property (nonatomic, strong) SmokeAlarmDetailsViewController *smokeAlarmDetailsVC;
@property (nonatomic, strong) ThermostatsTableView *tableView;

@end
