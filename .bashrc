\
# Manjaro
# Arch Wiki
# ~/.bashrc
#

umask 027
xset -b
xset r rate 400 60
mesg n

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

export TERM=xterm-256color

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

alias send_i3_debug_log='DISPLAY=:0 i3-dump-log | bzip2 -c | curl --data-binary @- https://logs.i3wm.org'
alias check_software='sudo paccheck --md5sum --quiet'
alias reinstall_all='sudo pacman -Qqn | sudo pacman -S --overwrite=* -'
alias cleancache='sudo pacman -Scc'
alias removeunused='sudo pacman -Qtdq | sudo pacman -Rns -'
alias genpassword='pwgen -csny 20 1 | xclip -sel clip'

alias install_archivers='sudo pacman -S xarchiver arj cpio lha lrzip lzip lzop p7zip unarj unrar unzip xdg-utils zip zstd tar lz4 gzip bzip2 binutils'

alias install_gparted='yay -S gparted dosfstools jfsutils f2fs-tools exfatprogs reiserfsprogs udftools xfsprogs gpart mtools'

alias install_software='yay -S polkit-gnome cbonsai bash-completion base base-devel i3-gaps haveged firefox imagemagick google-chrome-stable sdl2 shaderc base-devel glxinfo sddm meld xorg-xrandr xsel dmidecode libavtp hunspell hunspell-en_US tlp tlp-rdw ethtool smartmontools emacs hushboard-git caffeine-ng watchexec sec dunst fortune-mod cowsay lolcat rkhunter usbguard nmap pwgen acpica unhide etherape inetutils ispell i3status pcmanfm gvfs xorg-xwininfo xorg-server-xephyr xorg-xhost xorg-xrdb xorg-xkill lynis fwupd udisks2 redshift lxappearance ansible fotoxx zathura zathura-djvu zathura-pdf-mupdf zathura-ps zathura-cb undistract-me-git python-psutil xfce4-power-manager sbxkb autotiling psi-notify unclutter nitrogen polkit-gnome python-pyasn htop strace audit apparmor firejail pavucontrol pa-applet-git modprobed-db wireless-regdb mpv udev-notify cmake'

alias runetherape='sudo chmod 700 /home/max/Downloads/Logs && sudo etherape -i any > /home/max/Downloads/Logs/Net/networklog-$(date +%H%M%m%d%Y).log && sudo chmod 400 -R /home/max/Downloads/Logs/Sys/* && sudo chmod 500 /home/max/Downloads/Logs'

alias getdmesg='sudo chmod 700 /home/max/Downloads/Logs && sudo dmesg -e > /home/max/Downloads/Logs/Sys/dmesglog-$(date +%H%M%m%d%Y).log && sudo chown max:max -R /home/max/Downloads/Logs && sudo chmod 400 -R /home/max/Downloads/Logs/Sys/* && sudo chmod 500 /home/max/Downloads/Logs'

alias runrkhunter='sudo chmod 700 /home/max/Downloads/Logs && sudo rkhunter --skip-keypress --check --enable additional_rkts,apps,attributes,avail_modules,deleted_files,filesystem,group_accounts,group_changes,hashes,hidden_ports,hidden_procs,immutable,ipc_shared_mem,known_rkts,loaded_modules,local_host,login_backdoors,malware,network,os_specific,packet_cap_apps,passwd_changes,ports,possible_rkt_files,possible_rkt_strings,promisc,properties,rootkits,running_procs,scripts,shared_libs,shared_libs_path,sniffer_logs,startup_files,startup_malware,strings,susp_dirs,suspscan,system_commands,system_configs,system_configs_ssh,system_configs_syslog,trojans --logfile /home/max/Downloads/Logs/Sec/rkhunter-$(date +%H%M%m%d%Y).log && sudo chown max:max -R /home/max/Downloads/Logs/Sec && sudo chmod 400 -R /home/max/Downloads/Logs/Sec/* && sudo chmod 500 /home/max/Downloads/Logs'

alias runacpidump='sudo chmod 700 /home/max/Downloads/Logs && sudo acpidump > /home/max/Downloads/Logs/Acpi/$(date +%H%M%m%d%Y).dump && sudo chmod 400 -R /home/max/Downloads/Logs/Acpi/* && sudo chmod 500 /home/max/Downloads/Logs'

alias gitlogsupload='sudo chmod 700 /home/max/Downloads/Logs && sudo dmesg -e > /home/max/Downloads/Logs/Sys/dmesglog-$(date +%H%M%m%d%Y).log && sudo chown max:max -R /home/max/Downloads/Logs && cd /home/max/Downloads/Logs/ && pwd && git add . && git commit -am $(date +%H%M%m%d%Y) && git push && sudo chmod 500 /home/max/Downloads/Logs'

alias runaideupdate='sudo chmod 700 /home/max/Downloads/Logs && sudo aide --update >  /home/max/Downloads/Logs/Aide/aide-update-$(date +%H%M%m%d%Y).log && sudo chown max:max -R /home/max/Downloads/Logs && sudo chmod 400 -R /home/max/Downloads/Logs/Aide/* && sudo chmod 500 /home/max/Downloads/Logs'

## echo powersave > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
## display power manager - xset dpms force on
## Copy and paste your key here with cat ~/.ssh/id_rsa.pub | xclip -sel clip .
## df --local -P | awk {'if (NR!=1) print $6'} | sudo xargs -I '{}' find '{}' -xdev -nouser

# Name
echo -e "GRTD GNU/Linux 🐧\n

Enemies in your devices always kill you - and all non local users against you.
Run acpidump periodically.

Scientology = is like in collaboration with russia against ukraine and ...

Не вплив а маніпуляція не зміна а знищення не життя а вбиство
"

# memes
fortune | cowsay -f tux | lolcat

[[ -f /usr/share/undistract-me/undistract-me.sh ]] && source /usr/share/undistract-me/undistract-me.sh

echo "RUN sudo sysctl -p /etc/sysctl.conf"

alias todo='echo "watchexec -- notify-send ALEEERT FUCKING TRIPLE PIRACY ATTACK"'

ls -all /boot/

echo 'TODO

 ** NGINX CAPTCHA

MY INFRA

 ** MKSSCRYER BUILD NGINX CROWSEC LUA NGINX MODULE

 ** GROUP OF RESISTORS WHO SWITCH FROM ONE TO ANOTHER BY THE TIMER WITH PSEUDORANDOM OR RANDOM ALGORITM
    - 20 rele - !!
    - HF resistors - 100
    - 20 types of resistors - 5000
    - NE 555 - 100
    - Transistors keys - 500
    - Capasitors - 5000
    - diodes - 500
    - D micro preamps - 30
    - Arduino + noise generator - 10
    - 20 dynamic or/and MEMS microphones - read AUDIO and decode to 20 PWM channels
    - ferrite choks - 100
    - wire for coils

 ** RESISTORS FOR LR CHANNEL MIX AND NOISE GENERATOR IN PARALLEL TO AUDIO INPUT ( diodes with bad freaquency characteristics - don`t try this again ), someone have image about polarised filter for block loopback audio imput to output, something like this https://source.android.com/docs/core/audio/latency/loopback but not for imput

'

# sudo usermod -aG docker $USER Target = /usr/lib/docker Target = /usr/bin/docker
# sudo usermod -aG tfenv $USER Target = /opt/tfenv Target = /var/lib/tfenv
# Error! Bad return status for module build on kernel: 6.4.1-zen2-1-zen (x86_64)
# Consult /var/lib/dkms/lkrg/0.9.6/build/make.log for more information.
