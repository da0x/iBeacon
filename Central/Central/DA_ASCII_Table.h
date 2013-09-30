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