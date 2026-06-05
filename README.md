# Homelab Project - JellyFin Server Install
***


## Step 1 - Clone the Homelab repo into ~/Projects/Homelab

Create the Projects dir and Clone the Homelab repo
```
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/TomGaylor/Homelab.git
```
***

## Step 2 - Run the main install script

Make the relevant install scripts executable
```
chmod +x ~/Projects/Homelab/jellyfin-main-install.sh
chmod +x ~/Projects/Homelab/mediaserver-mounts.sh
```
Launch the main install script
```
cd ~/Projects/Homelab
./jellyfin-main-install.sh
```
***

