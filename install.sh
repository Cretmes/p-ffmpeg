#!/bin/bash

local_dir="/usr/local/bin"
cretmes_dir="${local_dir}/cretmes"
pf_dir="${cretmes_dir}/p-ffmpeg"

if [ ! ${EUID:-${UID}} = 0 ]
then
	echo "Excute as root"
	exit 1
fi

if [ ! -e $cretmes_dir ]
then
	sudo mkdir $cretmes_dir
fi

if [ ! -d $cretmes_dir ]
then
	sudo mkdir $cretmes_dir
fi

if [ -e "${pf_dir}/*" ]
then
	sudo rm -rf "${pf_dir}/"
else
	if [ ! -d "${pf_dir}" ]
	then
		sudo mkdir "${pf_dir}"
	fi
fi

sudo rm -f "${local_dir}/p-ffmpeg"

sudo cp ./p-ffmpeg.sh "${pf_dir}/"

sudo chmod 755 "${pf_dir}/p-ffmpeg.sh"

sudo ln -s "${pf_dir}/p-ffmpeg.sh" "${local_dir}/p-ffmpeg"


echo "p-ffmpeg is installed."
echo "You can use p-ffmpeg like bellow"
echo ""
echo "\$ p-ffmpeg wav m4a export/"
echo ""
echo "(You can convert \"wav\" file to \"m4a\" and save to \"export/\")"
