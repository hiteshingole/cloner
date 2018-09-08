#!/bin/bash

export package=kernel-3.10.0-327.10.1.el7.x86_64 
export name=`echo $package|sed -e 's/\([^.]*\).*/\1/' -e 's/\(.*\)-.*/\1/'`

traverse()
{
	parent=`curl $1 -L -s |grep -i index |awk '{print $3}'|sed 's/<\/title>/\//'` 
	

	for j in `curl -s -L $1 |awk -F "href=" '{print $2}'  |grep -v ^$|grep -i td|grep -v "Parent Directory" | cut -d \" -f2 |tr -d \/`
	do
	echo $j	
		for k in `curl -s -L https://buildlogs.centos.org$parent$j|awk -F "href=" '{print $2}'  |grep -v ^$|grep -i td|grep -v "Parent Directory" | cut -d \" -f2 |tr -d \/`
			do
			echo https://buildlogs.centos.org$parent$j
			if [[ $j == *.rpm ]]
        		        then
                        		if [[ $j == $package ]];then
		                                echo pacgae found

					else 
						echo leaf node found quiting this https://buildlogs.centos.org$parent$j/$k
						break
                        		fi
	                fi	
		

		done
	done 

}


for i in ` curl -s https://buildlogs.centos.org| awk -F "href=" '{print $2}' |cut -d \" -f2 |tr -d \/ |grep -v ^$ |grep -i c7.[0-9]|grep -iEv "32$|.ppc|.arm|.i386|.u.[a-z]|.a|.x|.e" |sort`
do 
	
	traverse https://buildlogs.centos.org/$i/$name 


done


