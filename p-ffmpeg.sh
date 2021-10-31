#!/bin/bash



declare -a target_format=("wav" "flac" "wma")
declare -a convert_to_format=("m4a" "mp3" "mwa")

arg_check()
{
	declare arg_1=$1
	if [ ! -z $arg_1 ]
	then
		case $arg_1 in
		"-h" | "-help" )
			echo "command : p-ffmpeg (target) (converted) [option: path]"
			echo "p-ffmpeg supported extension(target)"
			declare tmp_target_list="    "
			for i in "${target_format[@]}"
			do
				tmp_target_list+="$i "
			done
			echo "$tmp_target_list"

			echo "p-ffmpeg supported extension(converted)"
			declare tmp_converted_list="    "
			for i in "${convert_to_format[@]}"
			do
				tmp_converted_list+="$i "
			done
			echo "$tmp_converted_list"

			exit 0
			;;
		esac
	else
		echo "command : p-ffmpeg (target) (converted) [option: path]"
		exit 1
	fi

	return
}

check_contain()
{
	declare arg_1=$1
	if [ ! -z $arg_1 ]
	then
		declare -n array=$2

		for i in "${array[@]}"
		do
			if [ $i = $arg_1 ]
			then
				echo 0
				return
			fi
		done
	else
		echo 2
		return
	fi
	echo 1
	return
}

flag_check()
{
	case $1 in
	1 )
		echo "Unsupported target format : $2"
		echo "[Notice] This script limits format to convert. But, ffmpeg may support your input."
		exit 1
		;;
	2 )
		echo $3
		echo "command : p-ffmpeg (target) (converted) [option: path]"
		exit 1
		;;
	esac

	return
}

arg_check $1

bTarget=`check_contain "$1" "target_format"`
flag_check $bTarget $1 "Input the target extension"

bConvert=`check_contain "$2" "convert_to_format"`
flag_check $bConvert $1 "Input the converted extension"

# Get Current dir file



