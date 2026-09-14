    ## Confirm available disk space in linux OS

df -h # list partitions and sizes and used

   # look for /dev/sda3 or the filesystem that contains /ertc, /var, /var/home
     ### alternatively look for /dev/nvme0n1p3 for the above locations
   # /dev/sda2 is the OS boot partition
   # /dev/sda1 is the boot efi part

   ##### Shutdown the linux OS at a bash prompt

shutdown now

   # In the VMware workstation mgmt console select the VM and choose the option to "Edit the Virtual Machine settings"

   # Select the Hard Disk Device in the left hand pane

   # Select Expand in the right hand panel to expand the disk capacity

   # Type in the nex Max disk size amount in GBs and click "Expand"

   # click OK to the notification message about increasing the partition in the OS

   # Click OK to leave the VM settings interface

   # Power on the linux VM

   # Open the disk mgmt app ("Disks") in the OS and select the appropriate disk and partition

   # Select the additional partitions button and click "resize..."

   # move the slider or type the new size number as desired and click "resize"


   # Find the disk and partition number - Typical layout is something like /dev/nvme0n1p3 or /dev/sda3

lsblk   # 

   # Grow the partition (replace with your disk and partition number) nvme0n1p3 259:3 

sudo growpart /dev/nvme0n1 3

   # If this doesn't work because growpart is not installed, try the following options 
   # (more information below on issues with disk partition location challenges)

sudo btrfs filesystem resize max /sysroot

   # Check partition info to address the correct one

lsblk
sudo parted -l

   # type the following

sudo parted /dev/nvme0n1 resizepart 3 100%    # or for desktop: sudo parted /dev/sda resizepart 3 100% 

## The following doesn't seem to work well, recommend using the GUI utility to expand the disk partition ##
###########################################################################################################

   # Login and open a bash shell prompt and type the following command for the appropriate volume

sudo btrfs filesystem resize max /var/home   # or /dev/nvme01n1p3

###########################################################################################################

#########More info from Grok on issues and the procedure to expand disk partitions #########

## https://grok.com/share/bGVnYWN5_8d5ee3c8-0f8f-4563-b810-fac2fe4fe3d7                   ##


# Expand Disk Size on Bazzite

Bazzite uses **Btrfs** for the root filesystem. There is no `ujust` command that expands the disk. You must grow the **partition** first, then grow the **filesystem**.

`growpart` is **not** installed on Bazzite by default. Do not layer it just for this. Use `parted` instead.

> **Warning:** Back up first. A bad partition resize can make the system unbootable.

## 1. Identify the disk and partition

```bash
lsblk
sudo parted -l
```

Typical layout:

- Disk: `/dev/nvme0n1` or `/dev/sda`
- Btrfs root: last partition, often `p3` / partition `3`
- Mounts: `/sysroot`, `/var`, `/var/home`

Confirm unused space is **immediately after** the Btrfs partition. If Windows or another partition is in the way, skip to [Live USB / GParted](#4-if-parted-refuses-or-space-is-not-adjacent).

## 2. Grow the partition with `parted`

Replace the disk and partition number with yours:

```bash
sudo parted /dev/nvme0n1 resizepart 3 100%
```

If `parted` asks to fix GPT, answer `Fix`.

Notify the kernel:

```bash
sudo partprobe /dev/nvme0n1
```

## 3. Grow the Btrfs filesystem

```bash
sudo btrfs filesystem resize max /sysroot
```

Optional scan first:

```bash
sudo btrfs device scan
sudo btrfs filesystem resize max /sysroot
```

Verify:

```bash
df -h /
sudo btrfs filesystem show
sudo btrfs filesystem df /sysroot
```

## 4. If `parted` refuses or space is not adjacent

Boot a live USB (GParted Live, Fedora Workstation, Linux Mint, or the Bazzite ISO).

1. Open **GParted**.
2. Move any partitions blocking the end of the disk.
3. Expand the Btrfs partition into the free space.
4. Apply operations. Do not interrupt.
5. Reboot into Bazzite and run:

```bash
sudo btrfs filesystem resize max /sysroot
```

You generally **cannot** safely resize the in-use Bazzite root partition while the system is running if partitions must be moved.

## Notes

- Gnome Disks inside a running Bazzite install often fails with:

  `unable to resize '/sysroot': Read-only file system`

  That can resize the partition table view without growing usable Btrfs space.

- `btrfs filesystem resize` only grows the filesystem **inside the existing partition**. If the partition itself is still the old size (clone to a larger drive, expanded VM disk, leftover unallocated space), resize the partition first.

- `growpart` example (only if the tool is already present):

  ```bash
  sudo growpart /dev/nvme0n1 3
  sudo btrfs filesystem resize max /sysroot
  ```

  On stock Bazzite this usually returns `command not found`.
