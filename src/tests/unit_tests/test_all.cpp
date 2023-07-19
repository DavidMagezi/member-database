import <iostream>;
import <string>;

#define BOOST_TEST_MODULE test_all
#include <boost/test/unit_test.hpp>

namespace boost::unit_test::ut_detail {
    std::string normalize_test_case_name(const_string name) {
        return ( name[0] == '&' ? std::string(name.begin()+1, name.size()-1) : std::string(name.begin(), name.size() ));
    }
}
