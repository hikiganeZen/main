#!/bin/sh

#Enable community repo.
if ! grep -q '^[^#].*/community$' /etc/apk/repositories; then
        repo=` grep '^[^#].*/main$' /etc/apk/repositories | sed 's:/main$:/community:' `
        escaped_repo=` echo $repo | sed -e 's:/:\\/:g' -e 's:\.:\\.:g' `
        sed -i -e "/^[^#].*\/main$/a $repo" \
                -e "/^#${escaped_repo}$/d" \
                /etc/apk/repositories \
                && echo ">> Enabling community repository"
        apk update
fi

echo "Installing shadow, sudo, and zsh ....."
apk add shadow sudo zsh

echo "Creating User ....."
read -p "Enter username : " user
adduser -s /bin/zsh $user
addgroup $user wheel
echo "User is added to the wheel group."

#source @ buchireddy/modify_sudoers_for_requiretty.sh.
echo "Editing Sudoers file ....."

#Take a backup of sudoers file then edit.
cp /etc/sudoers /tmp/sudoers.bak
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /tmp/sudoers.bak

#Check the backup file to make sure it is correct and replace the sudoers file with the new only if syntax is correct.
visudo -cf /tmp/sudoers.bak
if [ $? -eq 0 ]; then
	cp /tmp/sudoers.bak /etc/sudoers
else
	echo "Could not modify /etc/sudoers file. Please do this manually."
fi

#Ask to create dotfiles dir and delete shadow afterwards.
while true; do
        read -p "Change home DIR to /home/$user/dotfiles? [y/n]: " yn
        case $yn in
                [Yy]* ) su -c "mkdir /home/$user/dotfiles" $user;
			usermod -d /home/$user/dotfiles $user;
			echo "Uninstalling shadow .....";
			apk del shadow;
                        break;;
                [Nn]* ) echo "Uninstalling shadow .....";
                        apk del shadow;
			exit;;
                * ) echo "y or n only.";;
        esac
done

echo "The setup is done you can now exit and login!"
