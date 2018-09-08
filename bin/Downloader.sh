#!/bin/bash


# Syntax Downloader.sh /root/rpm_qa" $arch $epelv $centosVer

download_packages()
{

	rpm_file=$1
	arch=$2
	epelv=$3
	centosVer=$4
	yum clean all 
	while read -r package
	do 
		echo Downloadin $package >> ../logs/Downloader.log
		yumdownloader --disablerepo=* --enablerepo=cloner* --destdir=/mnt/my.cluster.com/customerrepos $package
							
		if [ $? -ne 0 ]; then
			echo Failed to dowload the package $package  >> ../logs/Downloader.log
		fi

		

	done < $rpm_file
	failed_packages=`grep -i failed ../logs/Downloader.log|wc -l`
	if [ $failed_packages -ne 0 ];then
	
		echo "we failed to download all the packages please execute 
		failed_packages "  $arch $epelv $centosVer
	fi
}



download_packages $1 $2 $3 $4

