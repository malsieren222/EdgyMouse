#!/bin/bash
path=$(pwd)
X1=$path/X.dat
Y1=$path/Y.dat
i=0
ratiofile=$path/ratio.dat
alarm=$path/alarm.dat
if test -f $X; then
	file=true
fi
while true
do
sleep 2
if [ $file = true ]; then
	eval $(xdotool getmouselocation --shell)

	if nc -zw1 google.com 443; then
  		echo "We have connectivity to the internet."
		connectivity="0"
	else
		echo "We are fucked, no connection."
		connectivity="0"
	fi
	
	X3=sudo cat $X1 | xargs 
	Y3=sudo cat $Y1 | xargs
	D1=`expr $X3-$X`
	D2=`expr $Y3-$Y`
	ratio=`expr $D1 / $D2`
	ratiosaved=$(sudo cat $ratiofile | tr -s '\n' ' ')
	ratiosaved=`expr $ratiosaved + 0`
	echo ratio is $ratio while ratiofile is $ratiosaved
	if [ "$ratio" != "$ratiosaved" ] && [ "$i" -gt '0' ];then 
		echo "Movement detected! Triggering security! "
		echo '1' > $alarm
	else
		echo '0'>$alram
	fi
	echo $X>X.dat
	echo $Y>Y.dat
        echo $ratio > $ratiofile | xargs
	i=$((i+1))
fi
done
