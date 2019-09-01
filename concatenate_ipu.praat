# This script concatenates adjoining intervals of speech into one interval
# TextGrid must be selected 
#
# This script is distributed under the GNU General Public License.
# Copyright 2015 Emer Gilmartin
#

form concatenate ipus
	comment Which IntervalTier in this TextGrid would you like to process?
	integer Tier 1
endform


# Default values for variables
intervalstart = 0
intervalend = 0
numberOfIntervals = Get number of intervals... tier

#appendInfoLine: "First number of intervals is ", numberOfIntervals

# Loop through all intervals in the selected tier of the TextGrid
#for each interval, check if it's speech, then check if next interval is speech, 
# if next interval is speech,  remove right boundary of first interval and make new label
# from original labels plus space between
# else increment index by 1
intervalnumber = 1
while intervalnumber < numberOfIntervals
	#appendInfoLine: "In while loop"
	#appendInfoLine: "now intervalno and intervals are ======================", intervalnumber, "   ", numberOfIntervals
	label1$ = Get label of interval... tier intervalnumber
        label2$ = Get label of interval... tier intervalnumber +1
	#appendInfoLine: "label1 is ",label1$
	if left$(label1$,1) != "{" 
		#appendInfoLine: "got one"
		if left$(label2$,1) != "{"
			#appendInfoLine: "got two"
			space$ = " "
			newlabel$ = label1$ + space$ + label2$
			#appendInfoLine: "new label is =====================================",newlabel$
			Remove right boundary... tier intervalnumber
			label3$ = Get label of interval... tier intervalnumber
			#appendInfoLine:"label of concatenated before adding newlabel===========",label3$
			Set interval text... tier intervalnumber 'newlabel$'
			numberOfIntervals = Get number of intervals... tier
		else 
			intervalnumber = intervalnumber + 1
		endif
	#appendInfoLine: "just before --------------------------------------------------else"
	else 
		intervalnumber = intervalnumber + 1		
	endif
endwhile
appendInfoLine: "Done!"