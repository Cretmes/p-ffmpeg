#!/bin/bash

declare -a target_format=("wav" "flac" "wma")
declare -a convert_to_format=("m4a" "mp3" "mwa")

check_contain()
{
	local arg_1=$1
	if [ ! -z $arg_1 ]
	then
		declare -n local array=$2

		for i in "${array[@]}"
		do
			if [ $i = $arg_1 ]
			then
				echo 1
				return
			fi
		done
	fi
	echo 0
	return
}

btarget=`check_contain "$1" "target_format"`
echo $btarget

if [ $btarget -eq 1 ]
then
	echo "CONTAIN"
else
	echo "NOT CONTAIN"
fi
