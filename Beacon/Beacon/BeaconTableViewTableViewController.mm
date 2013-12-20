//
//  BeaconTableViewTableViewController.m
//  Beacon
//
//  Created by Daher Alfawares on 12/20/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "BeaconTableViewTableViewController.h"
#import "BeaconViewController.h"

#include <map>
#include <string>
#include <vector>


namespace global {
    
    struct beacon_t {
        std::string name;
        std::string image;
        std::string uuid;
        int major;
        int minor;
    };
    std::vector<beacon_t> beacons = {
        {"Lowes",       "discover_ibeacon_signal_lowes",    "360F40D6-1375-4877-93FB-E48249C95B29", 0, 0},
        {"McDonald's",  "discover_ibeacon_signal_mcd",      "360F40D6-1375-4877-93FB-E48249C95B29", 1, 0}
    };
    
    int current_beacon = 1;
}



@interface BeaconTableViewTableViewController ()

@end

@implementation BeaconTableViewTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return global::beacons.size();
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text         = [NSString stringWithUTF8String:global::beacons[indexPath.row].name.c_str()];
    cell.detailTextLabel.text   = [NSString stringWithUTF8String:global::beacons[indexPath.row].uuid.c_str()];
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BeaconViewController* beaconViewController = [segue destinationViewController];
    int row = static_cast<int>( [self.tableView indexPathForSelectedRow].row );
    
    beaconViewController.beaconUUID         = global::beacons[row].uuid;
    beaconViewController.beaconMajor        = global::beacons[row].major;
    beaconViewController.beaconMinor        = global::beacons[row].minor;
    beaconViewController.beaconTitle        = global::beacons[row].name;
    beaconViewController.beaconImageName    = global::beacons[row].image;
}


@end
