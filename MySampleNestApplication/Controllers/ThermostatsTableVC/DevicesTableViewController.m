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
#import "NestThermostatManager.h"
#import "NestSmokeAlarmManager.h"
#import "NestStructureManager.h"
#import "ThermostatsTableView.h"

static NSString *TableViewCellIdentifier = @"SimpleTableIdentifier";

@interface DevicesTableViewController () <UITableViewDataSource, UITableViewDelegate, NestStructureManagerDelegate>

//@property (nonatomic, strong) Thermostat *currentThermostat;
//@property (nonatomic, strong) SmokeAlarm *currentSmokeAlarm;

//@property (nonatomic, strong) NestThermostatManager *nestThermostatManager;
@property (nonatomic, strong) NestStructureManager *nestStructureManager;

@property (nonatomic, strong) NSDictionary *currentStructure;

//@property (nonatomic, strong) NSMutableArray *allThermostats;

@property (nonatomic) NSInteger numberOfThermostats;
@property (nonatomic) NSInteger numberOfSmokeAlarms;

@end

@implementation DevicesTableViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Thermostats";

//    self.allThermostats = [[NSMutableArray alloc] init];

    self.nestStructureManager = [[NestStructureManager alloc] init];
    self.nestStructureManager.delegate = self;
    [self.nestStructureManager initialize];

 //   self.nestThermostatManager = [[NestThermostatManager alloc] init];
 //   [self.nestThermostatManager setDelegate:self];

    [self setupTableView];

    [self.tableView showLoading];
}

- (void)setupTableView
{
    self.tableView = [[ThermostatsTableView alloc] initWithFrame:self.view.frame];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:TableViewCellIdentifier];
    //self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [self.tableView reloadData];
    [self.tableView enableView];
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

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Thermostat #%lu", indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Smoke Alarm #%lu", indexPath.row];
    }

//    Thermostat *thermostat = (Thermostat *)self.allThermostats[indexPath.row];
//    if (thermostat)
//    {
//        cell.textLabel.text = thermostat.nameLong;
//    }
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
    }
    else if (indexPath.section == 1)
    {
        self.smokeAlarmDetailsVC = [[SmokeAlarmDetailsViewController alloc] init];
        self.smokeAlarmDetailsVC.smokeAlarmItem = [[self.currentStructure objectForKey:@"smoke_co_alarms"]
                                                   objectAtIndex:indexPath.row];
    }

    [self.navigationController pushViewController:self.thermostatDetailsVC
                                         animated:YES];
}

#pragma mark - Private Methods

//- (void)subscribeToThermostat:(Thermostat *)thermostat
//{
//    // See if the structure has any thermostats --
//    if (thermostat) {
//
//        // Update the current thermostats
//        //self.currentThermostat = thermostat;
//
//        [self.tableView showLoading];
//
//        // Load information for just the first thermostat
//        [self.nestThermostatManager beginSubscriptionForThermostat:thermostat];
//    }
//}

//#pragma mark - NestThermostatManagerDelegate Methods
//
///**
// * Called from NestThermostatManagerDelegate, lets us know thermostat
// * information has been updated online.
// * @param thermostat The updated thermostat object.
// */
//- (void)thermostatValuesChanged:(Thermostat *)thermostat
//{
////    if ([thermostat.thermostatId isEqualToString:[self.currentThermostat thermostatId]]) {
//        [self.tableView hideLoading];
//        [self.tableView reloadData];
//    //    [self.thermostatView updateWithThermostat:thermostat];
////    }
//
//}

//- (UILabel *) headerLabelWithTitle:(NSString *)paramTitle
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//    label.text = paramTitle;
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    return label;
//}
//
//- (UIView *) tableView:(UITableView *)tableView
//viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return [self headerLabelWithTitle:@"Thermostats section"];
//    }
//    else if (section == 1)
//    {
//        return [self headerLabelWithTitle:@"Cmoke alarms section"];
//    }
//    return nil;
//}
//
//- (CGFloat) tableView:(UITableView *)tableView
//heightForHeaderInSection:(NSInteger)section
//{
//    return 30.0f;
//}

@end
