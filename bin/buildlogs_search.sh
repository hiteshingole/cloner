#!/bin/bash

export package=$1
export name=`echo $package|sed -e 's/\([^.]*\).*/\1/' -e 's/\(.*\)-.*/\1/'`

traverse()
{
	parent=`curl $1 -L -s |grep -i index |awk '{print $3}'|sed 's/<\/title>/\//'` 
	
# searching the pakage in all th eposible version 
	for version in `curl -s -L $1 |awk -F "href=" '{print $2}'  |grep -v ^$|grep -i td|grep -v "Parent Directory" | cut -d \" -f2 |tr -d \/`
	do
		for archv in `curl -s -L https://buildlogs.centos.org$parent$version|awk -F "href=" '{print $2}'  |grep -v ^$|grep -i td|grep -v "Parent Directory" | cut -d \" -f2 |tr -d \/`
			do
				parent_archv=`curl  https://buildlogs.centos.org$parent$version  -L -s |grep -i index |awk '{print $3}'|sed 's/<\/title>/\//'`

				for rpms in `curl -s -L https://buildlogs.centos.org$parent_archv$archv|grep -i rpm |awk -F 'href=' '{print $2}'|cut -d \" -f2 |tr -d \/ |grep -v ^$`
				do
	
					if [[ $rpms == *.rpm ]]
        				        then
                		        		if [[ $rpms == $package.rpm ]];then
		        		                        echo Package found $rpms >> ../logs/buildlogs.log
									 for rpms_download  in `curl -s -L https://buildlogs.centos.org$parent_archv$archv|grep -i rpm |awk -F 'href=' '{print $2}'|cut -d \" -f2 |tr -d \/ |grep -v src.rpm |grep -v ^$` 
								do 
									#download all the pakages and removing them from the package list which needs to be downloaded
									echo Downloading $rpms_download >> ../logs/buildlogs.log
									wget  https://buildlogs.centos.org$parent_archv$archv/$rpms_download -P /mnt/my.cluster.com/customerrepos
									sed -i "/$rpms_download/d" /tmp/buildlogs 
								done	
								exit 554
	
							else 
								echo not the version I was looking for $rpms 
								

                        				fi
	               		 	fi	
				done


		done
	done 

}


for i in ` curl -s https://buildlogs.centos.org| awk -F "href=" '{print $2}' |cut -d \" -f2 |tr -d \/ |grep -v ^$ |grep -i c7.[0-9]|grep -iEv "32$|.ppc|.arm|.i386|.u.[a-z]|.a|.x|.e" |sort`
do 
	echo Searching  $package >> ../logs/buildlogs.log
	traverse https://buildlogs.centos.org/$i/$name 
	

done
# if you are here that means that you havent found anything 
echo Failed to download $package >> ../logs/buildlogs.log


