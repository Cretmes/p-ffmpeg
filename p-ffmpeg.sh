#!/bin/bash

IFS=$'\n'

declare version="1.0"

declare -a target_format=("wav" "flac" "wma")
declare -a convert_to_format=("m4a" "mp3" "mwa" "aac" "wav")

declare default_option="-vn"

declare -A format_m4a=(
	["acodec"]="aac"
	["format"]="mp4"
)
declare -A format_aac=(
	["acodec"]="aac"
	["format"]="mp4"
)
declare -A format_wav=(
	["acodec"]="pcm_s16le"
	["format"]="wav"
)
declare -A format_mp3=(
	["acodec"]="libmp3lame"
	["format"]="mp3"
)
declare -A format_wma=(
	["acodec"]="wav2"
	["format"]="asf"
)

arg_check()
{
	declare arg_1=$1
	if [ ! -z $arg_1 ]
	then
		case $arg_1 in
		"-h" | "-help" | "--h" | "--help" )
			echo "command : p-ffmpeg (target) (converted) (directory to save)"
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
		"-v" | "-version" | "--v" | "--version" )
			echo "p-ffmpeg version ${version}"
			echo ""
			echo "(C) 2021 Cretmes"
			exit 0
			;;
		esac
	else
		echo "command : p-ffmpeg (target) (converted) (directory to save)"
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
		echo "command : p-ffmpeg (target) (converted) (directory to save)"
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

if [ -z $3 ]
then
	echo "Specify directory to save."
	exit
fi

case $2 in
"m4a" )
	declare -g selected_codec="${format_m4a["acodec"]}"
	declare -g selected_format="${format_m4a["format"]}"
	;;
"aac" )
	declare -g selected_codec="${format_aac["acodec"]}"
	declare -g selected_format="${format_aac["format"]}"
	;;
"wav" )
	declare -g selected_codec="${format_wav["acodec"]}"
	declare -g selected_format="${format_wav["format"]}"
	;;
"mp3" )
	declare -g selected_codec="${format_mp3["acodec"]}"
	declare -g selected_format="${format_mp3["format"]}"
	;;
"wma" )
	declare -g selected_codec="${format_wma["acodec"]}"
	declare -g selected_format="${format_wma["format"]}"
	;;
* )
	echo "Why come here"
	exit 1
	;;
esac

declare -a command_ls=($(ls *.$1 2>/dev/null | sed 's/\.[^\.]*$//' 2>/dev/null))

if [ "${#command_ls[@]}" == 0 ]
then
	echo "\"$1\" file not found"
	exit 1
fi

normarized_3=`echo $3 | sed -e 's/^\.\?\/*//' -e 's/\/*$//'`

declare -a already_exist=()

bDirectory="./$normarized_3"
if [ -d $bDirectory ]
then
	for tmp_exist_file in "${command_ls[@]}"
	do
		declare exist_file_ext="./$normarized_3/${tmp_exist_file}.$2"

		if [ -e $exist_file_ext ]
		then
			already_exist+=("$exist_file_ext")
		fi
	done
else
	echo "$normarized_3 does not exist."
	read -p "Create directory? (y/N): " response
	case "$response" in
	[yY]*)
		mkdir $normarized_3
		;;
	* )
		echo "Aborted."
		exit
		;;
	esac
fi

if [ ${#already_exist[@]} -gt 0 ]
then
	echo "Some files already exist."
	for ef in "${already_exist[@]}"
	do
		echo "    \"$ef\""
	done
	read -p "Remove them? (y/N): " response

	case "$response" in
	[yY]*)
		text_rl=""
		for rl in "${already_exist[@]}"
		do
			rm -f "$rl"
		done
		echo "Removed"
		;;
	* )
		echo "Aborted."
		exit
		;;
	esac
fi

for file_name in "${command_ls[@]}"
do
	ffmpeg_convert()
	{
		try_path="./$3/${file_name}.$2"
		ffmpeg $default_option -i "${file_name}.$1" -acodec $selected_codec -f $selected_format $try_path 2>/dev/null

		if [ $? == 0 ]
		then
			echo "Success : $try_path"
		else
			echo "Failed : $try_path"
		fi
	}

	ffmpeg_convert $1 $2 $normarized_3 &
done
wait

echo "Done"
