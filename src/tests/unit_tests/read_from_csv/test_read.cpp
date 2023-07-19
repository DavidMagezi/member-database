//Copyright Dr. David A. Magezi (2023)
import <iostream>;
import <string>;
import read;

#include <boost/test/unit_test.hpp>

BOOST_AUTO_TEST_SUITE( test_read )

namespace FROM = read_from_csv;

BOOST_AUTO_TEST_CASE( test_spreadsheets_number ){

    FROM::Read read;

    BOOST_CHECK ( read.get_number_of_spreadsheets() == 1);
}

BOOST_AUTO_TEST_CASE( test_folder ){

    FROM::Read read;

    std::string path {"yo.txt"};
    const std::string expected_text {"yo\n"};

    read.set_path(path);

    BOOST_CHECK_EQUAL( path, read.get_path() ); 

    read.open_spreadsheet();

    BOOST_REQUIRE( read.is_open() ); 

    BOOST_CHECK_EQUAL( 1,read() ); 

    std::cout << "This data was read: \n"; 
    std::cout << read.get_raw_data() << std::endl;

    BOOST_CHECK_EQUAL( expected_text, read.get_raw_data() ); 

}

BOOST_AUTO_TEST_SUITE_END( )
