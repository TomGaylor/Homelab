# Homelab
Various installation and configuration scripts for personal Homelab services

######### Step 1 ##############
# Clone the Homelab repo into
# ~/Projects/Homelab
###############################

# Create the Projects dir and Clone the Homelab repo #
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/TomGaylor/Homelab.git

######### Step 2 ##############
# Launch the main install script
# 
###############################

# AMake the install script executable and run it #
cd ~/Projects/Homelab
chmod +x ~/Projects/Homelab/jellyfin-main-install.sh
./jellyfin-main-install.sh

