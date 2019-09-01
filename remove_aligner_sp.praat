# This script removes all intervals with a specified label in word tier by merging them with the interval on the left or right depending on which boundary is shared with the ip tier.
# TextGrid must be selected 
#
# This script is distributed under the GNU General Public License.
# Copyright 2015 Emer Gilmartin
#

form Remove sp intervals
	comment Which IntervalTier do you want to remove sp from?
	integer Tier_sp 4
	comment Which label?
	sentence Wanted "sp"
	
	comment Which IntervalTier in this TextGrid is IP reference?
	integer Tier_ip 1
endform


# Default values for variables
intervalstart = 0
intervalend = 0
numberOfIntervals = Get number of intervals... tier_sp

appendInfoLine: "First number of intervals is ", numberOfIntervals

# Loop through all intervals in the selected tier of the TextGrid
intervalnumber = 1
while intervalnumber < numberOfIntervals
	#appendInfoLine: "In while loop"
	xxx$ = Get label of interval... tier_sp intervalnumber
	#appendInfoLine: "label is ",xxx$
	if xxx$ = "sp"
		#appendInfoLine: "got one"
		# change label to ""
		nothing$ = ""
		Set interval text... tier_sp intervalnumber 'nothing$'
		
		intervalstart = Get starting point... tier_sp intervalnumber
		intervalend = Get end point... tier_sp intervalnumber
		
		# check if left boundary is shared with ip tier
		refint = Get interval at time... tier_ip intervalstart
		refstart = Get starting point... tier_ip refint
		
		if refstart == intervalstart
			Remove right boundary... tier_sp intervalnumber
			numberOfIntervals = Get number of intervals... tier_sp
		else 
			Remove left boundary... tier_sp intervalnumber
			numberOfIntervals = Get number of intervals... tier_sp
		endif
	#appendInfoLine: "just before --------------------------------------------------else"
	else 
		intervalnumber = intervalnumber + 1		
	endif
endwhile