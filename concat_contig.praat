# This script concatenates adjoining intervals with the same label into one interval
# TextGrid must be selected 
#
# This script is distributed under the GNU General Public License.
# Copyright 2015 Emer Gilmartin
#

form concat_contig
	comment Which IntervalTier in this TextGrid would you like to process?
	integer Tier 1
endform


# Default values for variables
intervalstart = 0
intervalend = 0
numberOfIntervals = Get number of intervals... tier

#appendInfoLine: "First number of intervals is ", numberOfIntervals

# Loop through all intervals in the selected tier of the TextGrid
#for each interval, check if it's the same as the next interval, 
# if so,  remove right boundary of first interval and use first interval label for new merged interval
# else increment index by 1
intervalnumber = 1
while intervalnumber < numberOfIntervals
	#appendInfoLine: "In while loop"
	#appendInfoLine: "now intervalno and intervals are ======================", intervalnumber, "   ", numberOfIntervals
	label1$ = Get label of interval... tier intervalnumber
    label2$ = Get label of interval... tier intervalnumber +1
	#appendInfoLine: "label1 is ",label1$
	if label1$ = label2$ 
		newlabel$ = label1$
		appendInfoLine: "new label is =====================================",newlabel$
		Remove right boundary... tier intervalnumber
		label3$ = Get label of interval... tier intervalnumber
		#appendInfoLine:"label of concatenated before adding newlabel===========",label3$
		Set interval text... tier intervalnumber 'newlabel$'
		numberOfIntervals = Get number of intervals... tier
	else 
		intervalnumber = intervalnumber + 1	
	endif
endwhile
appendInfoLine: "Done!"