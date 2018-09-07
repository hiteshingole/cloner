
download_packages()
{

	rpm_file=$1
	while read -r package
	do 
		echo Downloadin $package >> ../logs/Downloader.log
		yumdownloader --disablerepo=* --enablerepo=cloner* --destdir=/mnt/my.cluster.com/customerrepos $package
							
		if [ $? -ne 0 ]; then
			echo Failed to dowload the package $package  >> ../logs/Downloader.log
		fi

		

	done < $rpm_file
}



download_packages $1

