//
//  ViewController.swift
//  Beacon
//
//  Created by Daher Alfawares on 1/19/15.
//  Copyright (c) 2015 Daher Alfawares. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let beacons = BeaconDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate   = self;
        self.tableView.dataSource = self;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beacons.count()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // View
        let cell        = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        // Model
        let beaconInfo  = self.beacons.beaconInfoAtIndex(indexPath.row)
        
        // Control
        cell.textLabel?.text        = beaconInfo.name
        cell.detailTextLabel?.text  = beaconInfo.uuid
        
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // View
        let beaconViewController = segue.destinationViewController as BeaconViewController
        
        // Model
        let tableView = self.tableView;
        let index = tableView.indexPathForCell(sender as UITableViewCell)
        let row = index?.row
        let beacon = self.beacons.beaconInfoAtIndex (row!)
        
        beaconViewController.beaconName         = beacon.name
        beaconViewController.beaconUUID         = beacon.uuid
        beaconViewController.beaconImageName    = beacon.image
        beaconViewController.beaconMajor        = beacon.major
        beaconViewController.beaconMinor        = beacon.minor
    }
}

