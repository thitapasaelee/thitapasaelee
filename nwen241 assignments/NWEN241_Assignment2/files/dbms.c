#include <stdio.h>
#include <string.h>
#include "dbms.h"
#include <stdlib.h>

/* Task 1 : core */
int db_show_row(const struct db_table *db_table, unsigned int row) {
    if (row >= db_table -> rows_used) {
        printf("\n");
        return 0; // record does not exist
    }

    const struct album *album = &db_table -> table[row];

    char display[100] = "";
    sprintf(display, "%6lu:", album -> id); // 6 = 4 spaces + 2 chars of num

    // title
    char title[21];
    strncpy(title, album -> title, sizeof(title) - 1);
    title[sizeof(title) - 1] = '\0'; // null termination

    // calculate buffer space format
    int buffer_space = 20 - strlen(title);

    // add spaces to display string to align cols
    for (int i = 0; i < buffer_space; i++) {
        strcat(display, " ");
    }

    // add formatted title to display string
    strncat(display, title, strlen(title));
    strcat(display, ":");

    // add artist and year to display string
    sprintf(display + strlen(display), "%20s:%-4hu", album -> artist, album -> year); 
    printf("%s\n", display);
    return 1; // record exists
}

/* Task 2 : completion */
int db_add_row(struct db_table *db_table, struct album *album){ // pointer to the table and album

    // whether there is room in table for a new row/record or not by compareing num of used rows & total num of row
    if(db_table -> rows_used == db_table -> rows_total){ 
        // if no space(if full) in table -> allocate more memory for new 5 rows/records
        struct album *newtable = realloc(db_table -> table, (db_table -> rows_total + 5) * sizeof(struct album));
        // check if it succeeds in allocating memory 
        if(newtable == NULL){ // nothing in newtable 
            printf("memory allocation failed\n");
            return 0; // fail
        }
        // if succeeds in memory allocation
        db_table -> table = newtable; // table pointer of db_table updated to newtable
        db_table -> rows_total += 5; // add 5 more rows
    }
    // add new row/record to the table
    db_table -> table[db_table -> rows_used] = *album; // copies contents of album to next unused row in the table
    db_table -> rows_used++; // add 1 = more row
    return 1; // success
} 

/* Task 3 : challenge */
int db_remove_row(struct db_table *db_table, unsigned long int id) {
    int x;
    int y;
    
    // each row in the table
    for (x = 0; x < db_table -> rows_used; x++) {
        // whether current row's id matches with given id
        if (db_table -> table[x].id == id) {
            // move all rows one pos up after the removal
            for (y = x; y < db_table -> rows_used - 1; y++) {
                db_table -> table[y] = db_table -> table[y + 1];
            }
            // update the number of row_used by reducing one by one
            db_table -> rows_used--;
            // reduce the table size when there are more than 5 unused rows
            if (db_table -> rows_total - db_table -> rows_used >= 5) {
                db_table -> rows_total -= 5;
                db_table -> table = realloc(db_table -> table, db_table -> rows_total * sizeof(struct album));
                // check if realloc(reduce the table size) succeeded or not
                if (db_table -> table == NULL) {
                    printf("memory allocation failed\n");
                    return 0; // failure
                }
            }
            // free memory when there are no more rows left
            if (db_table -> rows_used == 0) {
                free(db_table -> table); // free memory
                db_table -> table = NULL; // set table as empty
                db_table -> rows_total = 0; // set total row to 0
            }
            return 1; // success
        }
    }
    return 0; // failure
}