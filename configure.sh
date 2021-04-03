#!/usr/bin/env bash

###################
### For Ubuntu ####
###################

sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

sudo apt install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libxcb-xrm-dev \
libstartup-notification0-dev libxcb-randr0-dev \
libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev \
libanyevent-i3-perl libanyevent-perl libasync-interrupt-perl \
libcommon-sense-perl libev-perl libguard-perl libjson-xs-perl \
libtypes-serialiser-perl libxcb-cursor0

sudo apt install -y libxext-dev libxcb1-dev libxcb-damage0-dev \
libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev \
libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev \
libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev \
libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev \
libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev \
uthash-dev libev-dev libx11-xcb-dev

sudo apt install -y build-essential cmake ninja-build meson vim \
rustc cargo make libpcre3 libpcre3-dbg libpcre3-dev autoconf automake \
libtool libpcap-dev libnet1-dev libyaml-0-2 libyaml-dev zlib1g zlib1g-dev \
libcap-ng-dev libcap-ng0 make libmagic-dev libjansson-dev libjansson4 pkg-config \
libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev libnfnetlink0 \
python3-pip python3-virtualenv wget screen

mkdir -p ~/.i3
mkdir -p ~/.config/dunst

cp Xresources ~/.Xresources && cp dunstrc ~/.config/dunst/ && cp config i3status.conf autostart ~/.i3
chmod +x ~/.i3/autostart
sudo cp sysctl.conf /etc/sysctl.conf
cp vimrc ~/.vimrc

git config --global user.email "klimenkomaximsergievich@gmail.com"
git config --global user.name "Klimenko Maxim Sergievich"

###################

if [ -d "Appsource" ]; then
	cd ~/Appssource
else
	mkdir ~/Appssource
	cd ~/Appssource
fi

### Compile and install suricata

# wget https://www.openinfosecfoundation.org/download/suricata-6.0.2.tar.gz
# tar -xvzf suricata-6.0.2.tar.gz
# cd suricata-6.0.2
# ./configure --enable-nfqueue --prefix=/usr --sysconfdir=/etc --localstatedir=/var
# make
# make install-full
# make install-rules
# cd ../../

### Compile Picom

if [ -d "picom" ]; then
	cd picom && git pull
else
	git clone https://github.com/tryone144/picom.git
	cd picom
fi

git submodule update --init --recursive
meson --reconfigure . build
meson --buildtype=release . build
ninja reconfigure -C build
ninja -C build install

cd ..

### Compile i3-gaps

# if [ -d "i3-gaps"  ]; then
#	cd i3-gaps && git pull
# else
#	git clone https://www.github.com/Airblader/i3 i3-gaps
#	cd i3-gaps
# fi

# mkdir -p build && cd build
# meson --reconfigure
# meson ..
# ninja reconfigure
# ninja

# sudo cp i3 i3bar i3-config-wizard i3-dump-log i3-input i3-msg i3-nagbar /usr/bin/

# cd ../../

sudo add-apt-repository ppa:regolith-linux/release -y
sudo apt-get update
sudo apt install -y i3-gaps
### Connect to nvidia ppa
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda-repo-ubuntu2004-11-2-local_11.2.2-460.32.03-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-2-local_11.2.2-460.32.03-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu2004-11-2-local/7fa2af80.pub
sudo apt-get update

### Get some interesting repos
if [ -d "HiddenWall" ]; then
	cd HiddenWall && git pull && cd ..
else
	git clone https://github.com/CoolerVoid/HiddenWall
fi

### Purge unused apps

sudo apt purge -y firefox gnome-shell gnome-shell-common gnome-screenshot yelp snapd fwupd* fwupd-signed* \
gnome-online-accounts gnome-settings-daemon gnome-settings-daemon-common gnome-startup-applications \
gnome-system-monitor gnome-terminal gnome-terminal-data gnome-session-bin gnome-session-canberra \
gnome-session-common gnome-disk-utility gnome-desktop3-data gnome-control-center-faces \
gnome-control-center-data gnome-control-center nautilus* speech-dispatcher
sudo apt autoremove -y

### Install Soft
sudo apt install -y rofi dmenu python3-pydbus dunst usbguard py3status ranger htop nitrogen \
xfce4-power-manager tlp tlp-rdw clipit redshift unclutter blueman firejail pavucontrol pasystray \
scrot pcmanfm pass pwgen net-tools nmap bind9-utils sddm gparted python3-notify2 \
rxvt-unicode-256color lxappearance numix-icon-theme-circle feh zathura whoopsie \
paprefs python3-googleapi python3-protobuf dconf-editor sosreport

sudo -H pip3 install autotiling

if [ -f /usr/bin/terminal ]; then
	echo "link allready created"
else
	sudo ln -s /usr/bin/rxvt-unicode /usr/bin/terminal
fi

### Make windows
if [ -d "Windows-10-Dark" ]; then
	cd Windows-10-Dark && git pull && cd .. && sudo cp -r Windows-10-Dark /usr/share/themes && sudo rm -rf /usr/share/themes/Windows-10-Dark/.git
else
	git clone https://github.com/B00merang-Project/Windows-10-Dark.git
	cd Windows-10-Dark && git pull && cd .. && sudo cp -r Windows-10-Dark /usr/share/themes && sudo rm -rf /usr/share/themes/Windows-10-Dark/.git
fi

### Get Font
if [ -f ubuntufont.ttf ]; then
	sudo mkdir -p /usr/share/fonts/Nerd
	sudo cp "ubuntufont.ttf" /usr/share/fonts/Nerd/'Ubuntu Mono Nerd Font Complete Mono.ttf'
else
	wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf -O ubuntufont.ttf
	sudo mkdir -p /usr/share/fonts/Nerd
        sudo cp "ubuntufont.ttf" /usr/share/fonts/Nerd/'Ubuntu Mono Nerd Font Complete Mono.ttf'
fi

### Install Vundle and vim conf
if [ -d ~/.vim/bundle/Vundle.vim ]; then
	cd ~/.vim/bundle/Vundle.vim/ && git pull

else
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

fi

#####
cd ~/Debpackages
sudo dpkg -i *.deb
sudo apt install -f && sudo apt autoremove -y


echo "DONE!!!!!!!!!!!!!!!!"

sleep 3

sudo apt install steam
