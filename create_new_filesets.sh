#! /bin/bash
# ericmars
# 1/2019
# one shot script to create a 'project' fileset based on a list of directories 

# gss_listing_of_project.txt  created via:
#        mmlsfileset home | grep projects | awk '{print $1}'

# contents of gss_listing_of_project.txt look like:
# somerville /gpfs/home/projects/somerville
# kopp /gpfs/home/projects/kopp
# brooks /gpfs/home/projects/brooks
# etc.

locations='/root/gss_listing_of_project.txt'
filesystem='projects'
target_directory="/$filesystem/"

for fileset in `cat $locations`; do
	echo "########### $fileset ############"
	if [[  $fileset == *'prefileset'* ]]; then
		echo "skipping $fileset - not a fileset we want to make"
		continue
	fi 

	full_path_fileset="${target_directory}${fileset}"

	look=`/usr/lpp/mmfs/bin/mmlsfileset projects` 
	seek=`echo $look | /usr/bin/grep $fileset`

	if [[  $seek != '' ]]; then
		
		echo "skipping $fileset - already exists"
		continue
	fi 

	# with inode option
	#echo "mmcrfileset projects $fileset --inode-space new --inode-limit  134217728"
	#mmcrfileset projects $fileset --inode-space new --inode-limit 134217728 

	echo "mmcrfileset projects $fileset"
	mmcrfileset projects $fileset 

	echo "mmlinkfileset projects $fileset -J ${full_path_fileset}" 
	mmlinkfileset projects $fileset -J ${full_path_fileset}

	echo "mmlsfileset $filesystem $fileset -L "
	mmlsfileset $filesystem $fileset -L 


done
