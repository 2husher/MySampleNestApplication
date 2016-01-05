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

static NSString *TableViewCellIdentifier = @"DeviceIdentifier";

@interface DevicesTableViewController () <UITableViewDataSource, UITableViewDelegate, NestStructureManagerDelegate>

@property (nonatomic, strong) NestStructureManager *nestStructureManager;
@property (nonatomic, strong) NSDictionary *currentStructure;
@property (nonatomic, strong) NSArray *structureSectionTitles;
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
    [self.view addSubview:self.loadingView];
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
    self.structureSectionTitles = [self.currentStructure allKeys];
    [self.loadingView hideLoading];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.structureSectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return self.structureSectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = self.structureSectionTitles[section];
    NSArray *sectionDevices = self.currentStructure[sectionTitle];
    return [sectionDevices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView
            dequeueReusableCellWithIdentifier:TableViewCellIdentifier
            forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSString *sectionTitle = self.structureSectionTitles[indexPath.section];
    cell.textLabel.text =
        [NSString stringWithFormat:@"%@ #%lu", sectionTitle, indexPath.row];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = self.structureSectionTitles[indexPath.section];
    if ([sectionTitle isEqualToString:@"thermostats"])
    {
        self.thermostatDetailsVC = [[ThermostatDetailsViewController alloc] init];
        self.thermostatDetailsVC.thermostatItem = self.currentStructure[@"thermostats"][indexPath.row];
        [self.navigationController pushViewController:self.thermostatDetailsVC animated:YES];
    }
    else if ([sectionTitle isEqualToString:@"smoke_co_alarms"])
    {
        self.smokeAlarmDetailsVC = [[SmokeAlarmDetailsViewController alloc] init];
        self.smokeAlarmDetailsVC.smokeAlarmItem = self.currentStructure[@"smoke_co_alarms"][indexPath.row];
        [self.navigationController pushViewController:self.smokeAlarmDetailsVC animated:YES];
    }
}

@end