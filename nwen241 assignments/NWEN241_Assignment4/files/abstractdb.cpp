/**
 * abstractdb.cpp
 * C++ source file that should contain implementation for member functions
 * - loadCSV()
 * - saveCSV()
 * 
 * You need to modify this file to implement the above-mentioned member functions
 * as specified in the hand-out (Tasks 4 and 5)
 */ 

#include "abstractdb.hpp"
#include "vectordb.hpp"
#include <fstream>
#include <iostream>
#include <sstream>
#include <vector>
#include <cstring>
#include <string>



namespace nwen{
	// task 4 - saveCSV()
     bool AbstractDbTable::saveCSV(const std::string& filename) const {
        std::ofstream file(filename);

    if (!file.is_open()) { // if the file can't be opned for writing
        std::cerr << "could not open file for writing: " << filename << std::endl;
        return false;
    }
    
    const VectorDbTable* derivedTable = dynamic_cast<const VectorDbTable*>(this);
        if (derivedTable == nullptr) {
			// if the derived table type is invalid
            std::cerr << "invalid table type" << std::endl;
            return false;
        }

        for (const auto& record : derivedTable->getTable()) {
			// write each record to the file CSV format
            file << record.id << ",\"" << record.title << "\"," << record.year << ",\"" << record.director << "\"\n";
        }

        file.close();
        if (file.fail()) {
			// if writing the file fails 
			std::cerr << "failed to write a file: " << filename << std::endl;
			return false;
		}

        return true; // after a successful file has written
	}
	
	// task 5 - loadCSV()
	bool AbstractDbTable::loadCSV(const std::string& filename) {
        std::ifstream file(filename); // open the file and read

        if (!file.is_open()) { // check if the file was successfully opened or not
            std::cerr << "failed to open file for reading: " << filename << std::endl;
            return false;
        }
		
		// read each line
        std::string line;
        while (std::getline(file, line)) {
			// split the line into individual tokens using comma as the delimiter
            std::istringstream iss(line);
            std::string token;
            std::vector<std::string> values;

            while (std::getline(iss, token, ',')) {
                values.push_back(token);
            }
			
			// check if the number of the line is not equal to 4
            if (values.size() != 4) {
                std::cerr << "invalid record: " << line << std::endl;
                file.close();
                return false;
            }

            movie m;
            m.id = std::stoul(values[0]);
            // copy the title string into movie struct - to make sure it doesn't exceed the maximum size
            std::strncpy(m.title, values[1].c_str(), sizeof(m.title) - 1);
            m.title[sizeof(m.title) - 1] = '\0';
            m.year = std::stoi(values[2]);
            // copy the director string into movie struct - to make sure it doesn't exceed the maximum size
            std::strncpy(m.director, values[3].c_str(), sizeof(m.director) - 1);
            m.director[sizeof(m.director) - 1] = '\0';

            if (!add(m)) { // add movie record to the table
                std::cerr << "failed to add record: " << line << std::endl;
                file.close();
                return false;
            }
        }
		file.close();
		return true;
		}
	}


