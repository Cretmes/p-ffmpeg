[Japanese](./readme.md)
# p-ffmpeg

p-ffmeg, parallel-ffmpeg is the shell script to convert the audio format by ffmpeg in parallel.

You aren't available to set advanced option and the vidio format is incompatible.

The format to convert is limited. If you want to know more, see below.

## Environment
Ubuntu or another Linux

Test environment is WSL Ubuntu 20.04

## Install

1. Install ffmpeg

	Example in Ubuntu
	```
	$ sudo apt install ffmpeg
	```
	If another distro, google yourself. yum?

2. Install p-ffmpeg(this script)
	1. Install p-ffmpeg by "git clone" and change directory.
		```
		$ cd p-ffmpeg
		```

	2. Change permision of `install.sh`
		```
		$ sudo chmod 555 install.sh
		```

	3. Run `install.sh` as root
		```
		$ sudo ./install.sh
		```
	
	If you installed, you can remove the file which you downloaded.

## Use

1. Move direcoty which you want to convert
	```
	$ cd target_dir
	```

2. p-ffmpeg
	```
	$p-ffmpeg flac m4a export
	```
	You can get converted m4a from flac and export to "./export".

## Supported format

ffmpeg is powerfull software and compatible with a various format, but p-ffmpeg is limitted for simply.
Support list is below.

### before
- wav
- flac
- wav

### after
- mp3
- m4a
- aac
- wma
- wav


