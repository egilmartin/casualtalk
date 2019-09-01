###Description of this script
##  creates tables for each textgrid in a directory
###End of description

##  Specify the directory containing your sound files in the next line:

directory$ = "./"




##  Now we make a list of all the text grids in the directory we're using, and put the number of
##  filenames into the variable "number_of_files":

Create Strings as file list...  list 'directory$'*.TextGrid
number_files = Get number of strings

# Then we set up a "for" loop that will iterate once for every file in the list:

for j from 1 to number_files

     #    Query the file-list to get the first filename from it, then read that file in:

     select Strings list
     current_token$ = Get string... 'j'
     Read from file... 'directory$''current_token$'

     #    Here we make a variable called "object_name$" that will be equal to the filename minus the ".wav" extension:

     object_name$ = selected$ ("TextGrid")

     #  Now write table
	 #WRITE TO TABLE
	 Down to Table: "no", 4, "yes", "yes"
	 select Table 'object_name$'
	 Save as tab-separated file... 'object_name$'.Table


     endfor