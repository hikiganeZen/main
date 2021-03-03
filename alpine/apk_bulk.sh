#!/bin/sh

INPUT=` dialog \
	--title "[M E N U ]" \
	--backtitle "APK is BULK : apk_bulk.sh" \
	--checklist "Select to install" 0 0 0 \
	X "X org base + fonts" on \
	GD "Graphics Driver + video acceleration" on \
	WM "Window Manager" on \
	KEY "Keyboard Binder" on \
	RUN "Runtime tools" on \
	MUL "Alsa, pulseaudio, media library" on \
	BUILD "Building tools" on \
	3>&1 1>&2 2>&3 3>&- `

print_this() {
	echo "Adding $line"
}

install() {
	if [ "$line" == "X" ]; then 
		sudo setup-xorg-base font-noto-cjk ttf-hack
	fi
	
	if [ "$line" == "GD" ]; then 
		sudo apk add xf86-video-intel intel-media-driver 
	fi
	
	if [ "$line" == "WM" ]; then 
		sudo apk add bspwm 
	fi
	
	if [ "$line" == "KEY" ]; then 
		sudo apk add xbindkeys 
	fi
	
	if [ "$line" == "RUN" ]; then 
		sudo apk add xrandr 
	fi

	if [ "$line" == "MUL" ]; then 
		sudo apk add alsa-utils alsa-lib alsaconf pulseaudio pulseaudio-alsa alsa-plugins-pulse ffmpeg-libs
		sudo addgroup $USER audio
		sudo addgroup root audio
		sudo rc-update add alsa
		echo "Run 'sudo alsamixer' and umute channels" > ALSA_YOU_HAS_BEEN_WARNED!!!.txt
	fi

	if [ "$line" == "BUILD" ]; then 
		sudo apk add build-base gcc abuild binutils cmake extra-cmake-modules 
	fi	
}

echo $INPUT | sed 's/ /\n/g' > inputs.txt
while read line; do
	print_this
	install
done < inputs.txt

rm  inputs.txt
