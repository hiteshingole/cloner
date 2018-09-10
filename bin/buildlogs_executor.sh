#!/bin/bash


while read -r package_name
do 
	sh buildlogs_search.sh $package_name
	if [ $? -eq 554 ]
	then
	 sh $(basename $0) && exit
	fi
done < /tmp/buildlogs 
