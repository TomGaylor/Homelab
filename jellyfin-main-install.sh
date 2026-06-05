### Ensure NVIDIA Container Toolkit is Ready (one-time) ###
# Check if toolkit is present
rpm -q nvidia-container-toolkit || sudo rpm-ostree install nvidia-container-toolkit

# Generate CDI spec (important for Podman)
sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml

### Reboot if you installed anything new. ###


mkdir -p ~/.jellyfin/config ~/.jellyfin/cache

# Create or link your media folders (example)
# mkdir -p ~/Media/Movies ~/Media/TV ~/Media/Music
mkdir -p /var/mnt

### Create the Quadlet File Directory location ###
mkdir -p ~/.config/containers/systemd
### touch ~/.config/containers/systemd/jellyfin.container

### Media mount point creation ###
cd ~/Projects/Homelab
./mediaserver-mounts.sh

### Ensure one or more JellyFin media mount points are established ###
#   prior to generating the Quadlet .container file contents below.  #
######################################################################

### Create the quadlet file and generate the contents ###
cd ~/Projects/Homelab
./gen-jellyfin-podman-cont-file.sh


### Apply and Start JellyFin ###
systemctl --user daemon-reload
systemctl --user enable --now jellyfin.service



### Verify ###
systemctl --user status jellyfin.service
journalctl --user -u jellyfin -f
podman exec jellyfin nvidia-smi   # Should show your 3070

########## Enable Hardware Acceleration in Jellyfin #############
# Go to http://your-ip:8096 → Dashboard → Playback → Transcoding
# Set Hardware acceleration to NVIDIA NVENC
# Enable:
# Hardware encoding
# Tone mapping (recommended)
# Any other relevant options
# Save and test with a transcoding stream.
#################################################################

### Quick Commands ###
# Restart:
systemctl --user restart jellyfin
# Logs:
journalctl --user -u jellyfin -f
# Update Jellyfin:
podman auto-update && systemctl --user restart jellyfin
# Reload Jellyfin
systemctl --user daemon-reload
systemctl --user restart jellyfin.service

