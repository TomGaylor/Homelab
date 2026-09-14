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
