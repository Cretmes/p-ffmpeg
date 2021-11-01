#!/bin/bash

IFS=$'\n'

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

# echo "DEBUG : $selected_codec $selected_format"

declare -a command_ls=($(ls *.$1 2>/dev/null | sed 's/\.[^\.]*$//' 2>/dev/null))

if [ "${#command_ls[@]}" == 0 ]
then
	echo "\"$1\" file not found"
	exit 1
fi


# Ready Directory

declare -a already_exist=()

bDirectory="$3"
if [ -d $bDirectory ]
then
	for tmp_exist_file in "$3/${command_ls[@]}.$2"
	do
		if [ -e $tmp_exist_file ]
		then
			already_exist+=("$tmp_exist_file")
		fi
	done
else
	mkdir $3
fi

if [ ! "${#already_exist[@]}" == 0 ]
then
	echo "Some files already exist."
	for ef in "${already_exist[@]}"
	do
		echo "    $ef"
	done
	read -p "Remove them? (y/N): " response

	case "$response" in
	[yY]*)
		echo "Remove"
		;;
	* )
		echo "Aborted."
		exit
		;;
	esac
fi

# Converting

for file_name in "${command_ls[@]}"
do
	# echo "DEBUG : \"${file_name}.$1\" \"$3${file_name}.$2\""
	try_path="$3/${file_name}.$2"
	ffmpeg $default_option -i "${file_name}.$1" -acodec $selected_codec -f $selected_format $try_path 2>/dev/null

	if [ $? == 0 ]
	then
		echo "success : $try_path"
	else
		echo "Failed : $try_path"
	fi
done

echo "Done"