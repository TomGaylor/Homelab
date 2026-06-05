mkdir -p ~/.jellyfin/config ~/.jellyfin/cache
# Create or link your media folders (example)
### mkdir -p ~/Media/Movies ~/Media/TV ~/Media/Music
mkdir -p /var/mnt

### Create the Quadlet File Directory location ###
mkdir -p ~/.config/containers/systemd
### touch ~/.config/containers/systemd/jellyfin.container

### Create the quadlet file and generate the contents ###
cd ~/Projects/Homelab
./gen-jellyfin-podman-cont-file.sh

