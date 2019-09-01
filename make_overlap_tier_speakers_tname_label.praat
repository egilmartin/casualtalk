    tiers = Get number of tiers

    # Insert a new tier to find overlaps at the bottom
    overlap_tier = tiers + 1
    Insert interval tier: overlap_tier, "overlap"

    # Populate overlap tier with "flattened" intervals from all tiers
    for tier to tiers
      intervals = Get number of intervals: tier
      for interval to intervals-1
        end = Get end point: tier, interval
        # We use nocheck because there might already be a boundary there
        nocheck Insert boundary: overlap_tier, end
      endfor
    endfor

    # Cycle through the flattened intervals to check how many spoken intervals
    # align with each. A segment in the overlap tier will be considered to have no
    # overlap if and only if there is one tier with a speech labeled interval which
    # coincides with it.

    flat_intervals = Get number of intervals: overlap_tier
    for interval to flat_intervals
     
      start = Get start point: overlap_tier, interval
      end = Get end point: overlap_tier, interval
      midpoint = (end - start) / 2 + start

      # Count how many speakers are speaking over that flattened interval 
      speakers = 0
      st$ = ""
      for tier to tiers
        interval_number = Get interval at time: tier, midpoint
        label$ = Get label of interval: tier, interval_number
        if label$ != "{SL}"
          # Increment the number of speakers for each labeled coinciding interval
          # on any tier. We also save the tier number of the (last) speaker, so we
          # know where to look for measurements later. 
          speakers += 1
          speaker_tier = tier
		  tname$ = Get tier name: speaker_tier
          st$ = st$ + tname$ + label$

        endif
      endfor

      # Label the overlap intervals. Blank intervals are matched by no speakers in
      # any tier and marked {GS}. Intervals e matched by more than one speaker, in
      # more than one tier, are marked with speaker tier code plus label for each speaker and tier involved. The rest contain the tier number of the single speaker
      # speaking at that time and the label.
      if speakers = 1
        Set interval text: overlap_tier, interval, st$
      elif speakers > 1
      	Set interval text: overlap_tier, interval, st$
      else
        Set interval text: overlap_tier, interval, "{GS}"
      endif
     
    endfor

