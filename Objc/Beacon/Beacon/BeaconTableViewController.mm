//
//  BeaconTableViewController.m
//  Beacon
//
//  Created by Daher Alfawares on 12/20/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "BeaconTableViewController.h"
#import "BeaconViewController.h"
#import "BeaconDataSource.h"


@interface BeaconTableViewController()
@property(nonatomic)         BeaconDataSource  *beacons;
@property(nonatomic,retain)  UITableView       *tableView;
@end

@implementation BeaconTableViewController

-(void)awakeFromNib
{
    self.beacons = [[BeaconDataSource alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.beacons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        // View
    UITableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
        // Model
    BeaconInfo*       info = [self.beacons beaconInfoAtIndex:indexPath.row];
    
        // Control
    cell.textLabel.text         = info.name;
    cell.detailTextLabel.text   = info.uuid;
    
    return cell;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        // View
    BeaconViewController* beaconViewController = [segue destinationViewController];
    
        // Model
    BeaconInfo* info = [self.beacons beaconInfoAtIndex:[self.tableView indexPathForSelectedRow].row];
    
        // Controlling: set the beacon info.
    beaconViewController.beaconTitle     = info.name;
    beaconViewController.beaconImageName = info.image;
    beaconViewController.beaconUUID      = info.uuid;
    beaconViewController.beaconMajor     = info.major;
    beaconViewController.beaconMinor     = info.minor;
}


@end
