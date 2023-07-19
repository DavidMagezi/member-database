//Copyright Dr. David A. Magezi (2023)
export module read; 

import <fstream>;
import <string>;
import <string_view>;

namespace read_from_csv{
///
///\brief Reads membership data from csv 
///
///Requires a clean .csv spreadsheet   
///
export class Read{
    public:
        Read();
        ~Read();

        const std::string& get_path() const;
        void set_path(std::string_view folder);

        int get_number_of_spreadsheets() const;

        bool is_open() const;

        int operator()();

        const std::string& get_raw_data() const;

        void close_spreadsheet();
        void open_spreadsheet();

    private:
        std::string path_ { "NOT_SET" };
        static constexpr int number_of_spreadsheets = 1;
        std::ifstream spreadsheet_;
        bool is_open_ { false };
        std::string raw_data_;

};
} //namespace read_from_csv
