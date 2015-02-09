kamikazi-deploy
===============

This is a Xen livecd based on Lubuntu.

It's currently based on Lubuntu 14.10.

![Desktop](http://files.sllabs.com/files/long-term/screenshots/kamikazi/kamikazi-builder-14.10-2015-02-04-00-35-08.png)

Buildscripts are in resources/buildscripts

Bootscripts are in tools/*.sh

Configuration is in resources/config/

Full ISO download available at:

64-bit (Approximately 800MB)

http://files.sllabs.com/files/storage/xen/kamikazi/boot/isos/kamikazi64.iso
http://files.sllabs.com/files/storage/xen/kamikazi/boot/isos/sha1sums

32-bit
http://files.sllabs.com/files/storage/xen/kamikazi/boot/isos/kamikazi32.iso
(Unfinished, but bootable. 64BIT XEN, 32BIT USERSPACE)

Why kamikazi-deploy?
===============

This is about as close as I can come to 'open source ESXi with a sane Local/Remote GUI'.

X2GO Server is installed. Clients: http://wiki.x2go.org/doku.php

Xen 4.4 is included and bootable from the isolinux startup menu by default.

Openvswitch is included. See /etc/network/interfaces.examples/* for configuration details.

Ceph packages are included but currently unconfigured.

Ubuntu-builder is included. It can be used to unpack the ISO and apply new packages or updates.

![ubuntu-builder](http://files.sllabs.com/files/long-term/screenshots/kamikazi/kamikazi-builder-14.10-2015-02-04-22-18-39.png)



Hardware Configuration
===============

For best results, you should use a 2GB or larger USB stick, formatted FAT32 or NTFS, with the grub2 bootloader installed.

If the included buildscripts/xengrub.cfg is placed in boot/grub/grub.cfg and the iso is saved as boot/isos/kamikazi64.iso then everything should 'just work'.

Any btrfs volumes with a plaintext label should be found and the default primary subvolume will be mounted in /mnt/btrfs/<label> for your conveniance. Be careful with your btrfs filesystem label naming conventions!

You may also burn the .ISO file to any writable optical media larger than the ISO's size (Mini-DVDR, DVD+R, wasting a BD-R...) but configuration restoration will be impaired without a writable storage device available.

Later versions may lift the local writable storage requirement by placing configuration into a database of some form.


Changes made from lubuntu 14.10 source media:
===============

Replaced default GUI browser with midori.

Removed Firefox and all desktop applications and media playback libraries from Lubuntu 14.10 64bit.

Added many server management tools such as ipmitool, htop, byobu, wajig, dc3dd, sdparm, iftop...

Added build-essential and python-dev so python libraries requiring C compilation (uwsgi, scrypt) work.

Added Xen 4.4, added mboot.c32 to ISO, configured isolinux to multiboot Xen and default TORAM=Yes

Added pv-grub from a Xen 4.5.0RC build, placed in /usr/lib/xen-4.4/boot next to existing hvmloader.

Added Openvswitch 2.1.3, created example /etc/network/interfaces.d/ files demonstrating various bridges.

Added Ceph 0.80.7, left unconfigured but will restore configuration from /isodevice/boot/config/ if found.

Added casper script to restore limited host configuration from /isodevice/boot/config/* if found.

Configuration restored is: hostname, dbus machine-id, ssh hostkeys, openvswitch .db, ceph.conf

Added Rethinkdb 1.15.1, altered the initscript a bit to enable access to the undocumented 'proxy' functionality.

Added Serf 0.6.3, created upstart job to start agent with a default role of 'actor'. This default will change to 'dummy' soon.

Added X2GO-server and X2GO client for remotely accessing the Lubuntu GUI over long-distance-SSH.

Added supervisord, configured several post-boot scripts for role specialization via Serf

Added update mechanism that will attempt to use this GIT repository to overlay new updates on old isos. (beware!)

Added nginx-extra, lua, and uwsgi to support a future web-interface API. 

Provided a simple sample site providing read-only access to /isodevice to allow other kamikazi instances to obtain the ISO from a currently running instance.

Added ubuntu-builder, patched to handle above xen isolinux, can be used to update/remaster the ISO file directly from GUI.

TODO:
===============

Look into writing a generator for /etc/interfaces.d/xenbr0 and br0 to automatically assign biosdevnamed hardware ethernet devices to the LAN vswitch or the WAN vswitch. Current policy will likely be 'em1 and P?P?' to xenbr0, and em2 to br0 if the 'firewall' role is selected. Thoughts?

Need more work done on ceph, namely some form of autoconfig advertising via Serf tags.

Need more work done on Serf, the current script that uses nmap to scan the local lan segment for other serf members could use some love. (And encryption support would be nice, too...)

Need more work done on locking down nginx... Right now we assume VM host machines will behind a firewall instance.

Need more work done on security... Right now we are focused on using scrypt to protect secret data at rest (GPG/SSH private keyrings, perhaps?) and enabling as much transport security for as many of our required services as possible.

Provide a OpenWRT domU image as 'SimpleRouter'. Default configuration provides xenbr0 with NAT, DHCP and other services.

Provide a Vyatta domU image as 'AdvancedRouter'. Supports advanced network routing such as BGP or OSPF.

Provide a Openvswitch Controller domU image. Supports centralized management and allows complete Xen live migrations including network state from host to host if storage is backed by Ceph.

Provide a metering and billing solution, utilizing openvswitch stats, python, uwsgi, flask/bottle, stripe, and paypal.

FAQ:
===============

Q: What's up with the name?
A: By default, we run with TORAM=Yes added to the Linux kernel command line, instructing the Casper LiveCD scripts to copy the squashfs containing the OS into a tmpfs ramdisk before mounting it. Thus, everything is in memory, but still super-compressed with LZMA2. If you don't do anything to save your runtime configuration to a persistant storage medium, everything in memory will be lost on shutdown/reboot, mimicing the human act of self-sacrifice at the end of a (possibly long and arduous) task.

Unless you specifically instruct kamikazi to write to a disk, it shouldn't touch them. (outside of mounting labeled btrfs partitions)

Future Intentions:
===============

The end goal here is to provide a high quality virtual machine host supporting local and remote management, for zero cost.

Our metering/billing solution will include a 'tithe' module that will forward some percentage of revenue earned by VPS providers using our complete solution. If you don't use it to take money from others, it costs you nothing. If you make a million dollars, it'd be mighty nice to see fifty thousand of that... Maybe I might be able to replace my mid-90s Honda Civic with a Prius C? That sounds reasonable... right?

In return for your tithe, I want YOU to be able to run kamikazi in your home, in your garage, at work, at the datacenter, and never have to worry about the developer wandering off and leaving you in the lurch. I will support you all, if you will all support me.

