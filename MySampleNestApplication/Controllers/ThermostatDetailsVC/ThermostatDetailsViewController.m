//
//  ThermostatDetailsViewController.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "ThermostatDetailsViewController.h"
#import "DetailsView.h"
#import "NestThermostatManager.h"
#import "NestStructureManager.h"


@interface ThermostatDetailsViewController ()<NestThermostatManagerDelegate>

@property (nonatomic, strong) DetailsView *detailsView;
@property (nonatomic, strong) NestThermostatManager *nestThermostatManager;

@end

@implementation ThermostatDetailsViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setupThermostatNameLongLabel];
    [self setupThermostatNameLongLabelConstraints];

    [self setupDetailsView];
}

- (void)setupDetailsView
{
    self.detailsView = [[DetailsView alloc] initWithFrame:self.view.frame];
    //[detailsView setDelegate:self];
    [self.view addSubview:self.detailsView];
}

- (void)setupThermostatNameLongLabel
{
    self.thermostatNameLongLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.thermostatNameLongLabel.backgroundColor = [UIColor grayColor];
    self.thermostatNameLongLabel.text = @"Word:";
    [self.thermostatNameLongLabel sizeToFit];
    [self.view addSubview:self.thermostatNameLongLabel];
}

- (void)setupThermostatNameLongLabelConstraints
{
    self.thermostatNameLongLabel.translatesAutoresizingMaskIntoConstraints = NO;

    id topGuide = self.topLayoutGuide;
    NSDictionary *nameMap = @{ @"topGuide" : topGuide,
                               @"nameLongLable" : self.thermostatNameLongLabel };

    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-50-[nameLongLable]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:verticalConstraints];

    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[nameLongLable]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    [self.view addConstraints:horizontalConstraints];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Details";

    self.nestThermostatManager = [[NestThermostatManager alloc] init];
    self.nestThermostatManager.delegate = self;

    [self subscribeToThermostat:self.thermostatItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)subscribeToThermostat:(Thermostat *)thermostat
{
    if (thermostat)
    {
        [self.detailsView showLoading];

        [self.nestThermostatManager beginSubscriptionForThermostat:thermostat];
    }
}

#pragma mark - NestThermostatManagerDelegate Methods

- (void)thermostatValuesChanged:(Thermostat *)thermostat
{
    [self.detailsView hideLoading];

//    if ([thermostat.thermostatId isEqualToString:[self.currentThermostat thermostatId]]) {
    [self updateViewWithThermostat:thermostat];
//    }

}

- (void)updateViewWithThermostat:(Thermostat *)thermostat
{
    self.thermostatNameLongLabel.text = thermostat.nameLong;
}

@end
