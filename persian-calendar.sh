 #!/bin/bash

  isLeap(){
        idLeapTempYear=$1
        (( idLeapTempYear = ($idLeapTempYear - 474) % 128 ));
		(( idLeapTempYear = (($idLeapTempYear >= 30) ? 0 : 29) + $idLeapTempYear ));
		(( idLeapTempYear = $idLeapTempYear - ($idLeapTempYear / 33) - 1 ));
		if(( (($idLeapTempYear % 4) == 0) )); then
			echo "true"
		else
			echo "false"
		fi
}
gregorian_to_jalali(){
	year=$(date +%Y);
	month=$(date +%m);
	day=$(date +%d);
	grgSumOfDays1=(0 31 59 90 120 151 181 212 243 273 304 334 365);
	grgSumOfDays2=(0 31 60 91 121 152 182 213 244 274 305 335 366);
	hshSumOfDays1=(0 31 62 93 124 155 186 216 246 276 306 336 365);
	hshSumOfDays2=(0 31 62 93 124 155 186 216 246 276 306 336 366);
    (( hshDay= 0 ))
	(( hshMonth= 0 ))
	(( hshElapsed= 0 )) 
	(( hshYear= year - 621 ));
	grgLeap= "false";
	if (( (($year % 4) == 0 && (($year % 100) != 0 || ($year % 400) == 0)) )); then
		grgLeap= "true";
	fi
		
	(( tmpHshYear= $hshYear - 1 ))
	
	hshLeap=$(isLeap $tmpHshYear)

	(( grgElapsed= 0 ))
	if [[ $grgLeap = "true" ]]; then
		(( grgElapsed= grgSumOfDays1[$month - 1] + $day ));
	else
		(( grgElapsed= grgSumOfDays2[$month - 1] + $day ));
	fi
	
	if [[ $($hshLeap = "true") && $($grgLeap = "true") ]]; then
		(( XmasToNorooz= 80 ));
	else
		(( XmasToNorooz= 79 ));
	fi
	
		if [ $grgElapsed -le $XmasToNorooz ]; then 
			(( hshElapsed = $grgElapsed + 286 ));
			hshYear--;
			if (( $(hshLeap == "true") && $(grgLeap == "false") )); then
				hshElapsed++;
			fi
		else
			(( hshElapsed = $grgElapsed - $XmasToNorooz ));
			hshLeap=$(isLeap $hshYear);
		fi 
		
		if (( ($year >= 2029) && ((($year-2029)%4) == 0) )); then
			hshElapsed++;
		fi
		
		for ((i= 1; $i <= 12; i++)); do
		if [ hshLeap == "true" ]; then
			if (( hshSumOfDays1[$i] >= $hshElapsed )); then
				hshMonth= $i;
				(( hshDay= $hshElapsed - hshSumOfDays1[(($i - 1))] ));
				break;
			fi
		else 
			if (( hshSumOfDays2[$i] >= $hshElapsed )); then
				(( hshMonth= $i));
				(( hshDay= $hshElapsed - hshSumOfDays2[(($i - 1))] ));
				break;
			fi	
		fi
		done

	if [ ${#hshMonth} -lt 2 ]; then
	jmstr="-0${hshMonth}";
	else
	jmstr="-${hshMonth}";
	fi 
	
	if [ ${#hshDay} -lt 2 ]; then
	jdstr="-0${hshDay}";
	else
	jdstr="-${hshDay}";
	fi 

	retVal="${hshYear:2}${jmstr}${jdstr}";
	
    echo "$retVal";
}

export DATE=$(gregorian_to_jalali)
echo "gregorian_to_jalali ==> ${DATE}"
