#include "editor.h"
#include <stdio.h>
#include <string.h>

/* Task 1 */
int editor_insert_char(char editing_buffer[], int editing_buflen, char to_insert, int pos){

// checks if the pos is within the range of the editing buffer by comparing it to the editing_buflen
if(pos >= editing_buflen || pos < 0){
	return 0; // insertion not successful
}
// if within the range, move all char from pos to the end of buffer by one pos to the right
for(int index = editing_buflen - 1; index > pos; index--){ // start from the end of the array, decrementing the index until the pos is reached
	editing_buffer[index] = editing_buffer[index - 1]; 
}
editing_buffer[pos] = to_insert; // insert to_insert into pos
return 1; // succesful insertion 
}

/* Task 2 */
int editor_delete_char(char editing_buffer[], int editing_buflen, char to_delete, int offset){
	// search for first occurence of to_delete in the buffer (start from the offset)
	for(int index = offset; index < editing_buflen; index++){
		if(editing_buffer[index] == to_delete){
			// move characters pos to the left to overwrie the delete character
			for(int pos = index + 1; pos < editing_buflen; pos++){
				editing_buffer[pos - 1] = editing_buffer[pos];
			}
			// null character is inserted at the end of buffer
			editing_buffer[editing_buflen - 1] = '\0';
			return 1; // deletion occurred
		}
	}
return 0; // delection doesn't occur
}

/* Task 3*/
int editor_replace_str(char editing_buffer[], int editing_buflen, const char *str, const char *replacement, int offset){
	// lengths
	int str_length = strlen(str);
	int rpm_length = strlen(replacement);
	int buffer_length = strlen(editing_buffer);
	int x;
	int y;

	if(str_length == 0){ // if string is empty
		return -1; // no string replacement
	}
	if(rpm_length == 0){ // if rpm is an empty, deletes the string str
	// move char after str to the left to fill the empty space left by rpm
		for(int x = offset; x < buffer_length && x < offset + str_length; x++){
			editing_buffer[x] = editing_buffer[x + str_length];
		}
		// set all the remaining char of the buffer to null char
		for(int y = x; y < buffer_length; y++){ 
			editing_buffer[y] = '\0';
		}
		return x - 1; // return the index of last char in the edited buffer
		}
		
	// search for 1st occurence of str (start from index offset)
	for(x = offset; x < buffer_length - str_length + 1; x++){
		// check if found a matched str for the current substring
		int match = 1;
			for(y = 0; y < str_length; y++){
				// if there is a mismatch, the current substring is not a match
				if(editing_buffer[x + y] != str[y]){
					match = 0;
					break;
				}
			}
			if(match){
				// replace the match substring with rpm
				if(rpm_length > str_length){
					// move char after str to the right to make room for rpm
					for(y = buffer_length - 1; y >= x + str_length; y--){
					if(y + rpm_length - str_length < editing_buflen){
						// check if there's enough space in the buffer to move char
						editing_buffer[y + rpm_length - str_length] = editing_buffer[y];
					}
				}
			} else if(rpm_length < str_length){
				// move chaar after str to the left to fill the space left by rpm
				for(y = x + str_length; y < buffer_length; y++){
					if(y - str_length + rpm_length < editing_buflen){
						//check if there's enough space in buffer to move char
						editing_buffer[y - str_length + rpm_length] = editing_buffer[y];
					} else { // if not enough space in the buffer, set with null char
						editing_buffer[y] = '\0';
					}
				}
			}
			// insert rpm in editing_buffer
			for(y = 0; y < rpm_length && x + y < editing_buflen; y++){
				// check if theere's enough space in the buffer to insert rpm
				editing_buffer[x + y] = replacement[y];
			}
			// if rpm text go beyond the limits of editing_buffer
			if(x + rpm_length >= editing_buflen){
				return editing_buflen - 1; // return the last valid index
			}
			return x + rpm_length - 1; // return the index of the last char in the edited buffer
		}
	}
	// if str is not found
	return -1;
	}
	
	/* Task 4*/
	void editor_view(int rows, int cols, char viewing_buffer[rows][cols], const char editing_buffer[], int editing_buflen, int wrap){
		// initialise every char of viewing_buffer -> to null char
		for(int x =0; x < rows; x++){
			for(int y = 0; y < cols; y++){
				viewing_buffer[x][y] = '\0';
			}
		}
		int viewing_r = 0;
		int viewing_c = 0;

		// loop through each char in the editing_buffer -> then copy it to viewing_buffer
		for(int x = 0; x < editing_buflen && editing_buffer[x] != '\0'; x++){
			if(editing_buffer[x] == '\n'){
				viewing_r++; // move to the next row in viewing_buffer
				viewing_c = 0;
			} else {
				// copy the char from editing_buffer -> viewiing_buffer
				if(viewing_c < cols - 1){
					viewing_buffer[viewing_r][viewing_c] = editing_buffer[x];
					viewing_c++;
				} else {
					// wrap in not zero -> move to the next row in viewing_buffer
					if(wrap){
						viewing_r++;
						viewing_c = 0;
						// copy the char from editing_buffer to viewing_buffer
						viewing_buffer[viewing_r][viewing_c] = editing_buffer[x];
						viewing_c++;
					}
				}
			}
			// wrap is zero & has reached to th end of the row -> move to the next row
			if(!wrap && viewing_c == cols -1){
				viewing_r++;
				viewing_c = 0;
			}
			// if has reached to the end of viewing_buffer -> stop the copy
			if(viewing_r == rows){
				break;
			}
		}
	}