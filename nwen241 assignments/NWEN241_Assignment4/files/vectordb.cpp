/**
 * vectordb.cpp
 * C++ source file that should contain implementation for member functions
 * - rows()
 * - get()
 * - add()
 * - update()
 * - remove()
 * 
 * You need to modify this file to implement the above-mentioned member functions
 * as specified in the hand-out (Task 3)
 */ 

#include "vectordb.hpp"

namespace nwen {
    VectorDbTable::VectorDbTable() { // constructor
        // table = std::vector<movie>();
    }

	VectorDbTable::~VectorDbTable() { // destructor
	}
	
    int VectorDbTable::rows() const {
        // return table.size();
        return static_cast<int>(table.size()); // return thr number of roes in the table
    }

    const movie* VectorDbTable::get(int ind) const { // get a movie record at the specified index, ind
		if (ind >= 0 && ind < table.size()) {
            return &table[ind];
            }
        return nullptr; // movie record with the given ind is not found
    }

    bool VectorDbTable::add(const movie& m) {
		// add a movie record to the table
        // check if the record with the same ID has already exist
        for (const auto& mov : table) {
            if (mov.id == m.id) {
                return false; // record with the same ID already exists -> don't insert
            }
        }
        table.push_back(m); // put the record into the table
        return true;
    }

    bool VectorDbTable::update(unsigned long id, const movie& m) {
		// update a movie record wih the given ID
        for (auto& mov : table) {
            if (mov.id == id) {
                mov = m; // update it
                return true;
            }
        }
        return false; // movie record with the given ID is not found
    }

    bool VectorDbTable::remove(unsigned long id) {
		// remove a movie record with the givemn ID
        for (auto it = table.begin(); it != table.end(); ++it) {
            if (it->id == id) {
                table.erase(it); // remove the record from the table
                return true;
            }
        }
        return false; // movie record with the given ID is not found
    }
}
