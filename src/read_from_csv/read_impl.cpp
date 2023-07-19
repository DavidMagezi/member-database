//Copyright Dr. David A. Magezi (2023)
module read;

import <sstream>;

namespace read_from_csv{
Read::Read(){
}

Read::~Read(){
    close_spreadsheet();
}


const std::string& Read::get_path() const{
    return path_;
}

void Read::set_path(std::string_view path){
    path_ = path;
}

int Read::get_number_of_spreadsheets() const{
    return number_of_spreadsheets;
}

bool Read::is_open() const {
    return is_open_;
}

int Read::operator()(){ 
    int number_of_lines{0};
    std::string line;
    std::stringstream ss;
    while (std::getline(spreadsheet_,line)){
        number_of_lines++;
        ss << line << '\n'; 
    }
    raw_data_ = ss.str();
    return number_of_lines;
}

const std::string& Read::get_raw_data() const{
    return raw_data_;
}

void Read::close_spreadsheet() {
    if (spreadsheet_.is_open()) {
        spreadsheet_.close();
    }
}

void Read::open_spreadsheet() {
    spreadsheet_ = std::ifstream(path_);
    is_open_ = spreadsheet_.is_open();
}
} //namespace read_from_csv
