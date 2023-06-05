#!/bin/bash
hexchars="0123456789ABCDEF"
end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )

file=/root/first

if [ -f "$file" ]; then
	cat $file
else
	echo 00:60:2F$end
        echo 00:60:2F$end > $file

fi


