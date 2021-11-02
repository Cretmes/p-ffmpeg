#!/bin/bash

local_dir="/usr/local/bin"
pf_dir="${local_dir}/cretmes/p-ffmpeg"
sl_path="${local_dir}/p-ffmpeg"
if [ ! ${EUID:-${UID}} = 0 ]
then
	echo "Excute as root"
	exit 1
fi

if [ -d $pf_dir ]
then
	sudo rm -rf $pf_dir
fi

sudo rm -f $sl_path

echo "p-ffmpeg is uninstalled."
