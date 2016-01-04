//
//  DevicesTableViewController.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "DevicesTableViewController.h"
#import "ThermostatDetailsViewController.h"
#import "SmokeAlarmDetailsViewController.h"
#import "NestStructureManager.h"
#import "LoadingView.h"

static NSString *TableViewCellIdentifier = @"SimpleTableIdentifier";

@interface DevicesTableViewController () <UITableViewDataSource, UITableViewDelegate, NestStructureManagerDelegate>

@property (nonatomic, strong) NestStructureManager *nestStructureManager;
@property (nonatomic, strong) NSDictionary *currentStructure;
@property (nonatomic) NSInteger numberOfThermostats;
@property (nonatomic) NSInteger numberOfSmokeAlarms;
@property (nonatomic, strong) LoadingView *loadingView;

@end

@implementation DevicesTableViewController

- (void)loadView
{
    self.view = [[UIView alloc]
                 initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Devices";


    [self setupTableView];
    self.loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
//    NSLog(@"%@", self.loadingView);
    [self.view addSubview:self.loadingView];
//
//    NSLog(@"subview[0] = %@\nsubview[1] = %@", self.view.subviews[0], self.view.subviews[1]);
//    [self.view bringSubviewToFront:self.view.subviews[1]];
//    NSLog(@"subview[0] = %@\nsubview[1] = %@", self.view.subviews[0], self.view.subviews[1]);
//    [self.view bringSubviewToFront:self.view.subviews[0]];
//    NSLog(@"subview[0] = %@\nsubview[1] = %@", self.view.subviews[0], self.view.subviews[1]);
 //   [self.view sendSubviewToBack:self.loadingView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.nestStructureManager = [[NestStructureManager alloc] init];
    self.nestStructureManager.delegate = self;
    [self.nestStructureManager initialize];

    [self.loadingView showLoading];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:TableViewCellIdentifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - NestStructureManagerDelegate Methods

//One time in the life of the app
- (void)structureUpdated:(NSDictionary *)structure
{
    self.currentStructure = structure;

    if ([self.currentStructure objectForKey:@"thermostats"])
    {
        self.numberOfThermostats = [[self.currentStructure objectForKey:@"thermostats"] count];
    }
    if ([self.currentStructure objectForKey:@"smoke_co_alarms"])
    {
        self.numberOfSmokeAlarms = [[self.currentStructure objectForKey:@"smoke_co_alarms"] count];
    }
    [self.loadingView hideLoading];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.currentStructure objectForKey:@"thermostats"] &&
        [self.currentStructure objectForKey:@"smoke_co_alarms"])
    {
        return  2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [[self.currentStructure objectForKey:@"thermostats"] count];
            break;
        case 1:
            return [[self.currentStructure objectForKey:@"smoke_co_alarms"] count];
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView
            dequeueReusableCellWithIdentifier:TableViewCellIdentifier
            forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (indexPath.section == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Thermostat #%lu", indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Smoke Alarm #%lu", indexPath.row];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        self.thermostatDetailsVC = [[ThermostatDetailsViewController alloc] init];
        self.thermostatDetailsVC.thermostatItem = [[self.currentStructure objectForKey:@"thermostats"]
                                                   objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:self.thermostatDetailsVC
                                             animated:YES];
    }
    else if (indexPath.section == 1)
    {
        self.smokeAlarmDetailsVC = [[SmokeAlarmDetailsViewController alloc] init];
        self.smokeAlarmDetailsVC.smokeAlarmItem = [[self.currentStructure objectForKey:@"smoke_co_alarms"]
                                                   objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:self.smokeAlarmDetailsVC
                                             animated:YES];
    }
}

@end