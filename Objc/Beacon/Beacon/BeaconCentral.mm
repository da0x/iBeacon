//
//  BeaconCentral.m
//  preseNT
//
//  Created by Daher Alfawares on 1/15/15.
//  Copyright (c) 2015 Northern Trust. All rights reserved.
//

#import "BeaconCentral.h"
#import <CoreLocation/CoreLocation.h>

#import <map>

//C++
//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  Filename     : ASCII_Table.hpp                                          //
//  Created by   : Daher Alfawares                                          //
//  Created Date : 06/20/2009                                               //
//  License      : Apache License 2.0                                       //
//                                                                          //
// Copyright 2009 Daher Alfawares                                           //
//                                                                          //
// Licensed under the Apache License, Version 2.0 (the "License");          //
// you may not use this file except in compliance with the License.         //
// You may obtain a copy of the License at                                  //
//                                                                          //
// http://www.apache.org/licenses/LICENSE-2.0                               //
//                                                                          //
// Unless required by applicable law or agreed to in writing, software      //
// distributed under the License is distributed on an "AS IS" BASIS,        //
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. //
// See the License for the specific language governing permissions and      //
// limitations under the License.                                           //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

/*
 
 ASCII Table is a C++ class that allows you to format your data in an ASCII dynamic table structure.
 
 Example:
 
 ascii::table myTable("Table Title");
 myTable ("header 1")("header 2")++;
 myTable ("value 11")("value 12")++;
 myTable ("value 21")("value 22")++;
 
 std::cout << myTable;
 
 Output:
 
 +---------------------+
 |Table Title          |
 +----------+----------+
 | header 1 | header 2 |
 +----------+----------+
 | value 11 | value 12 |
 | value 21 | value 22 |
 +----------+----------+
 
 */


#ifndef _DA_ASCII_Table__0a61eabe_d038_4d30_a6fb_e202b2dfd6a9
#define _DA_ASCII_Table__0a61eabe_d038_4d30_a6fb_e202b2dfd6a9

#include <iostream>
#include <vector>
#include <string>
#include <iomanip>
#include <numeric>
#include <sstream>

namespace ascii
{
    // forward:
    
    // the following allows adding a C style string to an std::string and returns an std::string.
    // example:
    // std::string a = "abc";
    // std::string b = "123" + a;
    //
    inline std::string operator + ( const char*a, const std::string& b );
    inline std::string itoa( const int &i );
    inline int atoi( const std::string&s );
    
    // lexical cast.
    template<typename _To, typename _From> class lexical_cast;
    struct scoped_mute_s;
    // formats the output.
    std::string format( std::string _Name, int _Code );
    
    
    class table
    {
    public:
        std::string					title;
        size_t						column;
        std::vector<std::string>	columns;
        std::vector<std::size_t>	column_widths;
        bool						column_complete;
        std::string					comment;
        std::string					Prefix; // line prefix.
        
        table( std::string t ):title(t),column(0),column_complete(false){}
        
        
        std::vector< std::vector<std::string> > rows;
        
        
        table & operator()(std::string t)
        {
            if( column >= columns.size() )
            {
                columns.push_back("");
                column_widths.push_back(0);
            }
            
            columns[column] = t;
            if( column_widths[column] < t.size() )
                column_widths[column] = t.size();
            
            ++column;
            
            return *this;
        }
        table & operator()(int i)
        {
            return (*this)(itoa(i));
        }
        
        void operator ++(int)
        {
            column = 0;
            column_complete = true;
            rows.push_back( columns );
        }
        
        std::string prefix(){ return Prefix; }
        void prefix( std::string _P ){ Prefix=_P; }
        
        std::string endl(){ return "\r\n" + format("",1) + prefix() + " "; }
    };
    
    inline std::ostream& operator << ( std::ostream& _Str, table& T )
    {
        
        int width = std::accumulate( T.column_widths.begin(), T.column_widths.end(), 0 );
        width += 3*T.columns.size();
        
        _Str << std::setiosflags(std::ios::left);
        
        _Str << format("",1) << T.endl();
        
        // top border.
        _Str << '+'; for( int b=0; b< width-1; b++ ) _Str << '-'; _Str << '+' << T.endl();
        
        // title.
        _Str << "|" << std::setw(width-1) << T.title << "|" << T.endl();
        
        // middle border
        for( size_t i=0; i< T.columns.size(); i++ ) _Str << "+-" << std::setw( T.column_widths[i] ) << std::setfill('-') << "" << std::setfill(' ') << "-"; _Str << "+" << T.endl();
        
        
        if( !T.rows.empty() || !T.rows[0].empty() )
        {
            size_t i=0,j=0;
            
            // first row as header.
            for( i=0; i< T.columns.size(); i++ )
            {
                _Str << "| " << std::setw( T.column_widths[i] ) << T.rows[j][i] << " ";
            }
            _Str << "|" << T.endl();
            
            // middle border
            for( size_t i=0; i< T.columns.size(); i++ )
            {
                _Str << "+-" << std::setw( T.column_widths[i] ) << std::setfill('-') << "" << std::setfill(' ') << "-";
            }
            _Str << "+" << T.endl();
            
            // comment if available.
            if( !T.comment.empty() )
                _Str << "|" << std::setw(width-1) << T.comment << "|" << T.endl();
            
            // full table.
            for( size_t j=1; j< T.rows.size(); j++ )
            {
                for( size_t i=0; i< T.columns.size(); i++ )
                {
                    _Str << "| " << std::setw( T.column_widths[i] ) << T.rows[j][i] << " ";
                }
                _Str << "|" << T.endl();
            }
        }
        
        // bottom border.
        for( size_t i=0; i< T.columns.size(); i++ )
        {
            _Str << "+-" << std::setw( T.column_widths[i] ) << std::setfill('-') << "" << std::setfill(' ') << "-";
        }
        _Str << std::resetiosflags(std::ios::left);
        _Str << "+" << std::endl;
        
        return _Str;
    }
    
    inline std::string operator + ( const char*a, const std::string& b )
    {
        std::string c;
        c += a;
        c += b;
        return c;
    }
    
    inline std::string itoa( const int &i )
    {
        std::stringstream Str;
        Str << i;
        return Str.str();
    }
    
    inline int atoi( const std::string&s )
    {
        int i;
        std::istringstream Str(s);
        Str >> i;
        return i;
    }
    
    // lexical cast.
    template<typename _To, typename _From> class lexical_cast
    {
        _From * from;
    public:
        lexical_cast<_To, _From>( _From From )
        {
            this->from = & From;
        }
        
        operator _To()
        {
            throw( "Bad lexical cast: " );
        }
    };
    
    
    struct scoped_mute_s
    {
        scoped_mute_s();
        ~scoped_mute_s();
    };
    
#define scoped_mute() ascii::scoped_mute_s _6BBBC7E7_B5DB_41a0_9BE9_61BA1AFF2183_
#define once(a)	{static bool F399DD2E_11AA_4d81_90AD_A4130C8D96A8;if(!F399DD2E_11AA_4d81_90AD_A4130C8D96A8)(a),F399DD2E_11AA_4d81_90AD_A4130C8D96A8=true;}
    
    // formats the output.
    inline
    std::string format( std::string _Name, int _Code )
    {
        return "";
#ifndef _DEBUG
        if( _Name.length() > 10 ) _Name.erase(10);
        //		if( _Description.length() > 255 ) _Description.erase(254);
#endif
        char datetime[20];
        
        std::time_t Time_t = std::time(0);
        std::tm *Time;
        
#if defined (_MSC_VER) && (_MSC_VER >= 1300)
        // secure version.
        std::tm TimeS;
        Time = &TimeS;
        localtime_s( Time, &Time_t );
#else
        // insecure portable version
        Time = std::localtime( &Time_t );
#endif
        strftime( datetime, 20, "%Y-%m-%d %H:%M:%S", Time );
        
        std::stringstream _Str;
        _Str << std::setw(10) << _Name << " " << datetime << " " << std::setfill('0') << std::setw(3) << _Code << " ";
        
        return _Str.str();
    }
    
} /* ascii */

#endif




@interface BeaconCentral() <CLLocationManagerDelegate>
@property int proximity;
@property CLBeaconRegion *beaconRegion;
@property CLLocationManager* locationManager;
@property UILabel* distanceLabel1;// temporary
@property UILabel* distanceLabel2;// temporary
@end

@implementation BeaconCentral

-(id)initWithUUID:(NSString *)proximityUUID
{
    self = [super init];
    if(self)
    {
        NSLog(@"Monitoring availability       : %@",[CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]] ? @"Yes" : @"No");
        NSLog(@"Location authorization status : %d",[CLLocationManager authorizationStatus]);
        NSLog(@"Location ranging supported    : %@",[CLLocationManager isRangingAvailable] ? @"Yes":@"No");
        
        
        // Create the beacon region to be monitored.
        self.beaconRegion = [[CLBeaconRegion alloc]
                             initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:proximityUUID]
                             identifier:@"com.solstice-mobile.meetup"];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.proximity = CLProximityUnknown;
        
    }
    return self;
}

-(void)startListening
{
    
    // Register the beacon region with the location manager.
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

-(void)stopListening
{
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self.delegate beaconFound];
    return;
    
    
    if( [region isKindOfClass:[CLBeaconRegion class]] )
    {
        [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if( [region isKindOfClass:[CLBeaconRegion class]] )
    {
        [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    }
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    std::map<CLProximity,const char*> proximityText;
    
    proximityText[CLProximityUnknown]   = "The proximity of the beacon could not be determined.";
    proximityText[CLProximityImmediate] = "The beacon is in the user’s immediate vicinity.";
    proximityText[CLProximityNear]      = "The beacon is relatively close to the user.";
    proximityText[CLProximityFar]       = "The beacon is far away.";
    
    
    
    ascii::table myTable("Proximity Update");
    myTable ("Proximity")("Accuracy")("RSSI")++;
    
    for( int i=0; i< [beacons count]; i++ )
    {
        CLBeacon *beacon = [beacons objectAtIndex:i];
        
        NSLog(@"Beacon : %@",beacon);
        
        std::string proximity = proximityText[[beacon proximity]];
        
        std::stringstream accuracy;
        accuracy << [beacon accuracy];
        std::stringstream rssi;
        rssi << [beacon rssi];
        
        myTable (proximity)(accuracy.str())(rssi.str())++;
        
        NSString* distance;
        NSString* unit;
        
        if( [beacon accuracy] > 1 )
        {
            distance = [NSString stringWithFormat:@"%.2f",[beacon accuracy]];
            unit = @"m";
        }
        else
        {
            distance = [NSString stringWithFormat:@"%.2f",[beacon accuracy]*100];
            unit = @"cm";
        }
        
        if ( beacon.major > 0 )
            self.distanceLabel1.text = [NSString stringWithFormat:@"Beacon 1: %d +/- %@ %@", [beacon proximity], distance, unit];
        else
            self.distanceLabel2.text = [NSString stringWithFormat:@"Beacon 2: %d +/- %@ %@", [beacon proximity], distance, unit];
        
        self.proximity = beacon.proximity;
    }
    std::cout << myTable << std::endl;
}

@end

