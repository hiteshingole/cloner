while read -r line
do
	sh test $line
	if [ $? -eq 154 ]
	then
		echo I have updated file 
	sh $(basename $0) && exit
	fi
done < /tmp/test
