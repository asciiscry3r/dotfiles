export XDG_CONFIG_HOME="${HOME}/.config"
export GTK2_RC_FILES="${HOME}/.gtkrc-2.0"
export BROWSER=/usr/bin/google-chrome-stable
export QT_QPA_PLATFORMTHEME=gtk2
export EDITOR=vim
export VISUAL=emacs
export TERM=xterm
export QT_SELECT=5

export PATH="/usr/lib/python3.11/site-packages:${PATH}"
export PYTHONPATH="/usr/lib/python3.11/site-packages:${PYTHONPATH}"

export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# GRUB_CMDLINE_LINUX_DEFAULT="rd.udev.log_priority=3 vt.global_cursor_default=0 resume=UUID=703e84f3-1201-4bfe-8c5d-f2a70a0de41a log_buf_len=1M print-fatal-signals=1 loglevel=3 audit=1 console=tty0 console=ttys0,115200n0 kvm-intel.nested=1 no_timer_check noreplace-smp rcupdate.rcu_expedited=1 tsc=reliable lsm=yama,safesetid,integrity,landlock,lockdown,apparmor,bpf l1tf=flush,nosmt mds=full,nosmt tsx_async_abort=full,nosmt mmio_stale_data=full,nosmt retbleed=auto,nosmt mitigations=auto,nosmt nosmt=force pcie_aspm=force init_on_alloc=1 init_on_free=1 page_alloc.shuffle=1 vsyscall=none mce=0 debugfs=on randomize_kstack_offset=on slab_nomerge pti=on slub_debug=ZF slub_debug=P page_poison=on fsck.mode=force fsck.repair=yes 915.modeset=1 i915.fastboot=1 i915.enable_fbc=1 i915.edp_vswing=2 nvidia_drm.modeset=1 iommu.strict=1 intremap=on intel_iommu=igfx_off efi=disable_early_pci_dma pci=use_crs"
# pci.nobios=1
