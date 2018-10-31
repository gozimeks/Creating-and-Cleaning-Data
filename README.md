# Creating-and-Cleaning-Data

This project creates a script to collect and clean 2 datasets and builds a tidy data file to be used for further analysis.

This is  accomplished by creating a vector variable cvector, along with 2 data tables. Cvector is derived from the features.txt file using gsub and holds the column name values for later assignment to the data tables.

The test and training datasets are worked on separately.

NOTE: This process described did not work for fread so read.table was used.

After each table is loaded, label and subject columns  are added using cbind and all columns are renamed. The grep command is then used to pair down the data to include needed columns and both datasets are merged.

To facilitate aggregation the activity column is coerced to factor. A new data table with aggregate data is created and a csv file for further analysis derived from it.


