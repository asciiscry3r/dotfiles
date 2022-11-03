# Manjaro
# Arch Wiki
# ~/.bashrc
#

umask 027

export QT_QPA_PLATFORMTHEME=gtk2
export EDITOR=vim
# export LD_PRELOAD="/usr/lib/libhardened_malloc.so"
export TERM=xterm

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

# unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

# xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.xz)        xz -d -v $1  ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# configure X
xset -b
xset r rate 400 60
xhost -
# xhost +local:root > /dev/null 2>&1

# https://wiki.archlinux.org/title/emacs#Multiplexing_emacs_and_emacsclient
function emacs {
    if [[ $# -eq 0 ]]; then
        /usr/bin/emacs # "emacs" is function, will cause recursion
        return
    fi
    args=($*)
    for ((i=0; i <= ${#args}; i++)); do
        local a=${args[i]}
        # NOTE: -c for creating new frame
        if [[ ${a:0:1} == '-' && ${a} != '-c' && ${a} != '--' ]]; then
            /usr/bin/emacs ${args[*]}
            return
        fi
    done
    setsid emacsclient -n -a /usr/bin/emacs ${args[*]}
}

intel_collect_info () {
    echo "System architecture: ("uname -m")
Kernel version: ("uname -r"). Again, please consider using latest drm-tip from http://cgit.freedesktop.org/drm-tip

Linux distribution
Machine or mother board model (use dmidecode if needed)
Display connector: (such as HDMI, DP, eDP, ...)
A full dmesg with debug information and/or a GPU crash dump:


To obtain a dmesg with debug information, add drm.debug=0xe log_buf_len=4M to your kernel command line, then reboot and reproduce the issue again. Make sure to attach the full dmesg all the way from boot. (Please use "Attach a file" to attach the logs to the issue, avoid linking to logs on external sites.)


In the case of a GPU hang, dmesg will contain a "GPU crash dump saved to /sys/class/drm/card0/error" message. The contents of that file are crucial to debugging the issue. Note that the contents of that file are generated by the kernel when it is read, so it will appear to have zero bytes. Reading the file contents with cat will produce the expected result. For example, use
$ cat /sys/class/drm/card0/error | bz2 > error.bz2


Note that a new bug is preferred over adding your GPU crash dump to an already open bug. Most often the cause for the GPU hangs are different, and it is easy for the developers to mark bugs as duplicate."
    sudo cat /sys/class/drm/card0/error | bzip2 > /home/max/Downloads/Intel_reporting/error-$(date +%H%M%m%d%Y).bz2
    sudo cat /sys/class/drm/card0/error > /home/max/Downloads/Intel_reporting/error-$(date +%H%M%m%d%Y).intel.log
    sudo dmesg -e > /home/max/Downloads/Intel_reporting/dmesglog-$(date +%H%M%m%d%Y).log
    xrandr --verbose > /home/max/Downloads/Intel_reporting/xrandr-$(date +%H%M%m%d%Y).intel.log
}


alias check_software='sudo paccheck --md5sum --quiet'
alias reinstall_all='sudo pacman -Qqn | sudo pacman -S --overwrite=* -'
alias reinstall_install_aur='yay -S --removemake --overwrite=* ace qt5-styleplugins acpitool alien_package_converter amttool-tng autotiling caffeine-ng cbonsai cpufetch debhelper debtap fotoxx google-chrome gtk-theme-windows10-dark hardened_malloc hushboard-git i3lock-color icoextract imagewriter imgurbash2 intltool-debian libcurl-openssl-1.0 libestr libxerces-c-3.1 matplotlib-cpp-git mei-amt-check-git modprobed-db numix-circle-icon-theme-git numix-icon-theme-git opencryptoki pa-applet-git picom-tryone-git po-debconf psi-notify pstreams python-pulsectl python-pyasn qt5-styleplugins redeclipse rpi-imager-bin sblim-sfcc sddm-lain-wired-theme sec siji-ttf teiler-git telegram-desktop-bin tpm-tools trousers ttf-unifont tfenv undistract-me-git ventoy-bin wireshark-gtk2 xbindkeys_config-gtk2 xininfo-git xsuspender-git yay-bin'
alias reinstall_install_intel_kernel='yay -S  --overwrite=* linux-clear-bin linux-clear-headers-bin intel-ucode-clear'
# linux-clear linux-clear-headers nouveau-fw linux-firmware baudline-bin opensnitch-ebpf-module-git opensnitch-git nvidia-dkms nvidia-prime
alias cleancache='sudo pacman -Scc'
alias removeunused='sudo pacman -Qtdq | sudo pacman -Rns -'
alias genpassword='pwgen -csny 20 1 | xclip -sel clip'
alias install_archivers='sudo pacman -S xarchiver arj cpio lha lrzip lzip lzop p7zip unarj unrar unzip xdg-utils zip zstd tar lz4 gzip bzip2 binutils'
alias install_gparted='yay -S gparted dosfstools jfsutils f2fs-tools exfatprogs reiserfsprogs udftools xfsprogs gpart mtools'
alias install_software='yay -S i3-gaps firefox imagemagick mpv opencv sdl2 shaderc base-devel glxinfo prime intel-media-driver sddm libva-mesa-driver mesa-vdpau meld bolt xorg-xrandr xsel dmidecode libavtp pulseaudio-alsa hunspell hunspell-en_US tlp tlp-rdw ethtool smartmontools emacs hushboard-git caffeine-ng watchexec sec dunst rxvt-unicode fortune-mod cowsay lolcat rkhunter usbguard nmap pwgen acpica unhide etherape inetutils ispell i3status pcmanfm gvfs xorg-xwininfo xorg-server-xephyr xorg-xhost xorg-xrdb xorg-xkill lynis fwupd udisks2 redshift lxappearance ansible fotoxx zathura zathura-djvu zathura-pdf-mupdf zathura-ps zathura-cb undistract-me-git python-psutil xfce4-power-manager sbxkb autotiling psi-notify unclutter nitrogen polkit-gnome python-pyasn htop strace audit apparmor firejail firefox pulseaudio pavucontrol pa-applet-git modprobed-db wireless-regdb mpv udev-notify  nvidia-dkms nvidia-prime'
alias runetherape='sudo etherape -i any > /home/max/Downloads/Logs/Net/networklog-$(date +%H%M%m%d%Y).log --'
alias getdmesg='sudo dmesg -e > /home/max/Downloads/Logs/Sys/dmesglog-$(date +%H%M%m%d%Y).log && sudo chown max:max -R /home/max/Downloads/Logs'
alias runrkhunter='sudo rkhunter --skip-keypress --check --enable additional_rkts,apps,attributes,avail_modules,deleted_files,filesystem,group_accounts,group_changes,hashes,hidden_ports,hidden_procs,immutable,ipc_shared_mem,known_rkts,loaded_modules,local_host,login_backdoors,malware,network,os_specific,packet_cap_apps,passwd_changes,ports,possible_rkt_files,possible_rkt_strings,promisc,properties,rootkits,running_procs,scripts,shared_libs,shared_libs_path,sniffer_logs,startup_files,startup_malware,strings,susp_dirs,suspscan,system_commands,system_configs,system_configs_ssh,system_configs_syslog,tripwire,trojans --logfile /home/max/Logs/Sec/rkhunter-$(date +%H%M%m%d%Y).log && sudo chown max:max -R /home/max/Logs/Sec'
alias runacpidump='mkdir -p /home/max/Downloads/Acpi/$(date +%H%M%m%d%Y) && sudo acpidump > /home/max/Logs/Acpi/$(date +%H%M%m%d%Y)/$(date +%H%M%m%d%Y)'
alias gitacpiupload='cd /home/max/Downloads/Logs/Acpi/ && pwd && git add . && git commit -am $(date +%H%M%m%d%Y) && git push'
alias gitlogsupload='cd /home/max/Downloads/Logs/ && pwd && git add . && git commit -am $(date +%H%M%m%d%Y) && git push'
alias gitauditupload='sudo cp -r /var/log/audit/ /home/max/Downloads/Logs/Auditlogs/ && sudo chown max:max -R /home/max/Logs/Auditlogs && cd /home/max/Downloads/Logs/Auditlogs && pwd && git add . && git commit -am $(date +%H%M%m%d%Y) && git push'
alias reinstall_firmware='sudo fwupdmgr reinstall a45df35ac0e948ee180fe216a5f703f32dda163f'
alias primerun='DRI_PRIME=1'
#
# PrivateTmp=true
# ProtectControlGroups=true
# ProtectHome=true
# ProtectKernelTunables=true
# ProtectSystem=full
#
#
## echo powersave > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
## display power manager - xset dpms force on
## Copy and paste your key here with cat ~/.ssh/id_rsa.pub | xclip -sel clip .
## df --local -P | awk {'if (NR!=1) print $6'} | sudo xargs -I '{}' find '{}' -xdev -nouser
# Name
echo -e "GRTD GNU/Linux\n

Enemies in your devices always kill you.
Run acpidump periodically.

Scientology = is like in collaboration with russia against ukraine and ..."

# memes
fortune | cowsay -f tux | lolcat

source /etc/profile.d/undistract-me.sh
notify_when_long_running_commands_finish_install

alias todo='echo "watchexec -- notify-send ALEEERT FUCKING TRIPLE PIRACY ATTACK"'
