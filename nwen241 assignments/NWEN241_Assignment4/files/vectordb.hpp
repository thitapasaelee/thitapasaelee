/**
 * vectordb.hpp
 * C++ header file that should contain declaration for
 * - VectorDbTable class
 * 
 * You need to modify this file to declare VectorDbTable class 
 * as specified in the hand-out (Task 2)
 */ 

#ifndef ___VECTOR_DB_TABLE_HPP___
#define ___VECTOR_DB_TABLE_HPP___

#include <vector>
#include "abstractdb.hpp"

namespace nwen{
	// derive class VectorDbTable inheriting from AbstractDbTable
	class VectorDbTable : public AbstractDbTable {
		// make friend class
		friend class AbstractDbTable;
		
		private:
		std::vector<movie> table; // store movie as vector
		
		public:
		VectorDbTable();
		~VectorDbTable() override;
		int rows() const override;
		const movie* get(int ind) const override;
		bool add(const movie& m) override;
		bool update(unsigned long id, const movie& m) override;
		bool remove(unsigned long id) override;
		
		protected:
		// new protected member functions to provide the access to the table vector
		const std::vector<movie>& getTable() const { 
            return table;
        }
	};
}
#endif
		
		
