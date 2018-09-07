#!/bin/bash

repo_create()
{
	export	centosVer=$1 
	export	arch=$2
	echo $centosVer
	echo $arch

	rm -rf /tmp/Cloner-Base.repo*
	
	cp -rf ../repos/Cloner-Base.repo /tmp	
	cp -rf ../repos/epel.repo /tmp
	
	sed  -i  '/^baseurl/d' /tmp/Cloner-Base.repo
	
	awk   'FNR==3{print $0 ORS "baseurl=http://vault.centos.org/centos/#centosVer#/os/#arch#/";next }1'  /tmp/Cloner-Base.repo >/tmp/Cloner-Base.repo_new
	mv /tmp/Cloner-Base.repo_new /tmp/Cloner-Base.repo

	awk   'FNR==12{print $0 ORS "baseurl=http://vault.centos.org/centos/#centosVer#/extras/#arch#/";next }1'  /tmp/Cloner-Base.repo >>/tmp/Cloner-Base.repo_new
	
	sed -i  "s/#arch#/$arch/g" /tmp/Cloner-Base.repo_new
	sed -i "s/#centosVer#/$centosVer/g"  /tmp/Cloner-Base.repo_new
	mv /tmp/Cloner-Base.repo_new /tmp/Cloner-Base.repo
	mv /tmp/Cloner-Base.repo /etc/yum.repos.d/
}


repo_create $1 x86_64


exit 0
