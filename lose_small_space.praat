# This script removes all intervals with a specified label by merging them with the interval on the left.
# TextGrid must be selected 
#
# This script is distributed under the GNU General Public License.
# Copyright 2015 Emer Gilmartin
#

form Remove intervals below threshold
	comment Which IntervalTier in this TextGrid would you like to process?
	integer Tier 1
	comment Which label?
	sentence Wanted ""
	positive Threshold 0.03
endform


# Default values for variables
intervalstart = 0
intervalend = 0
numberOfIntervals = Get number of intervals... tier

appendInfoLine: "First number of intervals is ", numberOfIntervals

# Loop through all intervals in the selected tier of the TextGrid starting at 2
intervalnumber = 2
while intervalnumber < numberOfIntervals
	appendInfoLine: "In while loop"
	xxx$ = Get label of interval... tier intervalnumber
	appendInfoLine: "label is ",xxx$
	if xxx$ = ""
		appendInfoLine: "got one"
		intervalstart = Get starting point... tier intervalnumber
		intervalend = Get end point... tier intervalnumber
		intervalDur = intervalend - intervalstart
		appendInfoLine: "Duration is ", intervalDur
		if intervalDur <= threshold
			Remove right boundary... tier intervalnumber
			numberOfIntervals = Get number of intervals... tier
		else 
			intervalnumber = intervalnumber + 1
		endif
	appendInfoLine: "just before --------------------------------------------------else"
	else 
		intervalnumber = intervalnumber + 1		
	endif
endwhile