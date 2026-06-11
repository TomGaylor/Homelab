
#1. Download iso from https://bazzite.gg
#    a. Select Desktop PC, Intel legacy GPU (Skylake - Icelake), KDE desktop env.
#        Otherwise, select for Nvidia RTX Series for example if my 3090 video card is installed
#        Note: My desktop PC integrated video card Intel UHD wasbased on Coffee Lake Gen9.5 (2017-19)
#     b. Trigger the Bazzite download button
#2. Create the new VM
#     a. Workstation 25H2 or later compatible
#     b. Linux 6.x kernel 64-bit guest os designtation
#     c. 2x2 Procs and cores and 8096MB of memory
#     d. NAT networking 
#     e. LSI scsi controllers
#     f. SCSI Disk type
#     g. Create a 40GB single disk - no preallocation necessary
#     h. Change from BIOS to UEFI startup (Settings -> Options -> Advanced)

#2. Mount the bazzite-stable-live-amd64.iso install and boot the VM 
#3. Install and configure Bazzite
#      a. English/US for Language and keyboard
#      b.  
