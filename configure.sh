#!/usr/bin/env bash

###################
### For Ubuntu ####
###################

sudo apt update && sudo apt upgrade -y && sudo apt autoremove

sudo apot install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libxcb-xrm-dev \
libstartup-notification0-dev libxcb-randr0-dev \
libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev

sudo apt install -y libxext-dev libxcb1-dev libxcb-damage0-dev \
libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev \
libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev \
libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev \
libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev \
libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev \
uthash-dev libev-dev libx11-xcb-dev

sudo apt install -y build-essential cmake ninja-build meson \
rustc cargo make libpcre3 libpcre3-dbg libpcre3-dev autoconf automake \
libtool libpcap-dev libnet1-dev libyaml-0-2 libyaml-dev zlib1g zlib1g-dev \
libcap-ng-dev libcap-ng0 make libmagic-dev libjansson-dev libjansson4 pkg-config \
libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev libnfnetlink0 \
python3-pip python3-virtualenv wget

mkdir -p ~/.i3
mkdir -p ~/.config/dunst

cp Xresources ~/.Xresources && cp dunstrc ~/.config/dunst/ && cp config i3status.conf autostart ~/.i3
sudo cp sysctl.conf /etc/sysctl.conf

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
ninja -C build

cd ..

### Compile i3-gaps 

if [ -d "i3-gaps"  ]; then
	cd i3-gaps && git pull
else
	git clone https://www.github.com/Airblader/i3 i3-gaps
	cd i3-gaps
fi

mkdir -p build && cd build
meson --reconfigure
meson ..
ninja reconfigure
ninja

cd ../../

### Get some interesting repos
if [ -d "HiddenWall"]; then
	cd HiddenWall && git pull && cd ..
else
	git clone https://github.com/CoolerVoid/HiddenWall
fi

### Install Soft
sudo apt install rofi dmenu dunst usbguard py3status ranger htop nitrogen xfce4-power-manager tlp tlp-rdw clipit redshift unclutter blueman firejail pavucontrol pasystray scrot pcmanfm pass pwgen net-tools nmap bind9-utils

