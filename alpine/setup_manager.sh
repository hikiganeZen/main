#!/bin/sh

menu1() {
	INPUT=` dialog --nocancel \
		--title "[ M A I N - M E N U ]" \
		--backtitle "SETUP will MANAGE : setep_manager.sh" \
		--menu "Select what to run" 0 0 0 \
		APK_BULK "Install packages" \
		BUILD "Build packagesf from source" \
		PULL_DOT "Pull a dotfiles repo" \
		EXIT "Exit the manager" \
		3>&1 1>&2 2>&3 3>&- `
}

menu2() {
	BUILD_INPUT=` dialog \
		--title "[  M E N U ]" \
		--backtitle "SETUP will MANAGE : setep_manager.sh" \
		--checklist "Select what to build" 0 0 0 \
		ST "Simple Terminal" on \
		DMENU "Dynamic Menu" on \
		WALLPAPERD "Wallpaper Daemon" on \
		3>&1 1>&2 2>&3 3>&- `
}

buildit() {
	if [ "$line" == "ST" ]; then
		build st	
	fi

	if [ "$line" == "DMENU" ]; then
		build dmenu
	fi

	if [ "$line" == "WALLPAPERD" ]; then
		build wallpaperd
	fi
}

print_this() {
        echo "Adding $line"
}

if [ ! -x "$RUN_DIR/script/all_chmod_x" ]; then
	chmod +x $RUN_DIR/script/all_chmod_x
fi

all_chmod_x $RUN_DIR/script 
all_chmod_x $RUN_DIR/alpine 
all_chmod_x $RUN_DIR/alpine/install


menu1
case $INPUT in
	APK_BULK) $RUN_DIR/alpine/apk_bulk.sh
		break;;

	BUILD) menu2
		echo $BUILD_INPUT | sed 's/ /\n/g' > build_inputs.txt
		break;;

	PULL_DOT) pull_dot dotfiles $HOME
		break;;

	EXIT) echo "THANK YOUUU BYEE"
		break;;
esac

if [ ! -z "$BUILD_INPUT" ]; then
	while read line; do
		print_this
        	buildit
	done < build_inputs.txt
fi

rm -rf build_inputs.txt
