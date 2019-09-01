# This script finds all textgrid files in a directory, finds the global start time for textfile from filename, for each interval writes out start (global start + start), stop(global stop +stop), label, and tier to a text file.

#
# This script is distributed under the GNU General Public License.
# Copyright Emer Gilmartin 2015
#

form save intervals in each text grid to csv textfile.
	comment Each interval in the selected tier for each textgrid will be written out to textfile25
	comment Which IntervalTier on TextGrid would you like to process?
	integer Tier 1
	comment Starting and ending at which interval? 
	integer Start_from 1
	integer End_at_(0=last) 0
	comment Give the folder containing textgrids:
	sentence Folder /Users/emergilmartin/Documents/phd/Corpora/d64_small/s1audio/s1_f_textgrids/s1_f5to9_audio/testtable/
endform

strings = Create Strings as file list: "list", folder$ + "*.TextGrid"
numberOfFiles = Get number of strings
textfilename$="'folder$'"+"outfile_table.txt"
fileappend "'textfilename$'" 'hello'

    
    


# Default values for variables
intervalstart = 0
intervalend = 0
interval = 1

intname$ = ""
intervalfile$ = ""


for ifile to numberOfFiles
	fileappend "'textfilename$'" 'hello2'
    	selectObject: strings
    	fileName$= Get string: ifile
	fileIwant$= fileName$
	fileappend "'textfilename$'" "'fileIwant$'"

    	Read from file...  'fileIwant$'
	fileappend "'textfilename$'" 'hello3'
    	currenttg$ = selected$("TextGrid")
    	#select TextGrid 'currenttg$'

# Loop through all intervals in the selected tier of the TextGrid
    	for interval from start_from to end_at

	
	    	select TextGrid 'currenttg$'
		fileappend "'textfilename$'" 'hello4'
	    	ispeaker$ = "ANDY"
	    	intname$ = ""
	    	itext$ = Get label of interval... tier interval
	    	intervalstart = Get starting point... tier interval
	    	imin = intervalstart + globstart
	   	intervalend = Get end point... tier interval
	    	imax = globstart + intervalend
	
	    	intline$ = "'imin'" +","+ "'ispeaker$'"+","+ "'itext$'"+","+ "'imax'"+"'newline$'"
	    	fileappend "'textfilename$'" 'intline$'
	    
	endfor
	
	Remove
endfor


