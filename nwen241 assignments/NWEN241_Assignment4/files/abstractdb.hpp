/**
 * abstractdb.hpp
 * C++ header file that should contain declaration for
 * - struct movie (given)
 * - AbstractDbTable abstract class
 * 
 * You need to modify this file to declare AbstractDbTable abstract class 
 * as specified in the hand-out (Task 1)
 */ 



#ifndef __ABSTRACT_DB_HPP__
#define __ABSTRACT_DB_HPP__

#include <string>
#include <vector>

namespace nwen {
	// structure for a movie record
    struct movie {
		unsigned long id;
		char title[50];
		unsigned short year;
		char director[50];
    };
	
	// Abstract base class for database table
    class AbstractDbTable {
    public:
		virtual ~AbstractDbTable() {} // add virtual destructor
		
		// pure virtual functions that would be implemented by derived class
        virtual int rows() const = 0;
        virtual const movie* get(int id) const = 0;
        virtual bool add(const movie& m) = 0;
        virtual bool update(unsigned long id, const movie& m) = 0;
        virtual bool remove(unsigned long id) = 0;
        
        // for loading and saving CSV file
        bool loadCSV(const std::string& filename);
        bool saveCSV(const std::string& filename) const;
    };
}
#endif
