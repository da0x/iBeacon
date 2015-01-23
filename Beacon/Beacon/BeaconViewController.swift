//
//  BeaconViewController.swift
//  Beacon
//
//  Created by Daher Alfawares on 1/19/15.
//  Copyright (c) 2015 Daher Alfawares. All rights reserved.
//

import UIKit

class BeaconViewController: UIViewController {

    var beaconName      : String
    var beaconUUID      : String
    var beaconImageName : String
    var beaconMajor     : Int
    var beaconMinor     : Int

    var beacon          : Beacon?

    @IBOutlet var beaconLogo    : UIImageView?
    @IBOutlet var beaconSwitch  : UISwitch?

    required init(coder aDecoder: NSCoder) {
        self.beaconName         = ""
        self.beaconUUID         = ""
        self.beaconImageName    = ""
        self.beaconMajor        = 0
        self.beaconMinor        = 0

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.beacon = Beacon( uuid: self.beaconUUID, major: self.beaconMajor, minor: self.beaconMinor )
        self.beaconLogo?.image = UIImage(named: self.beaconImageName)
        self.beaconSwitch?.addTarget(self, action: Selector("switchChanged"), forControlEvents: UIControlEvents.ValueChanged)
    }

    func switchChanged()
    {
        if self.beaconSwitch!.on
        {
            self.beacon?.startAdvertising()
        }
        else
        {
            self.beacon?.stopAdvertising()
        }
    }

    @IBAction func toggle(sender: AnyObject?) {

        self.beaconSwitch!.setOn(!self.beaconSwitch!.on, animated: true)
        self.switchChanged()
    }

}
