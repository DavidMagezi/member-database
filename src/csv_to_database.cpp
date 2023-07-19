//Copyright Dr. David A. Magezi (2023)
import <iostream>;
import read;

namespace FROM = read_from_csv;

///
///\brief Converts membership data from csv to database
///
///Once membership database (in Excel format) is saved as 
///a .csv spreadsheet and cleaned, the following program  
///will save it as a database
///
int main(int argc, char **argv){
    std::cout << "Converting from spreadsheet to database" << std::endl;
    FROM::Read r;
}
