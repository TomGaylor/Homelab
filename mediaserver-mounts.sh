### Setup hidden credentials ###

sudo mkdir home/Tom/.smb

: << 'EOF' -------------------------------------------------------
echo "username=Tom" | sudo tee /home/Tom/.smb/credentials
echo "password=T----t" | sudo tee -a /home/Tom/.smb/credentials
------------------------------------------------------------------
EOF

echo "username=${USERNAME}" | sudo tee /home/Tom/.smb/credentials
echo "password=${PASSWORD}" | sudo tee -a /home/Tom/.smb/credentials

sudo chmod 600 ~/.smb/credentials


    
######################################################################################################
### build var-mnt-remtivovideo.automount ###
echo "[Unit]" | sudo tee /etc/systemd/system/var-mnt-remtivovideo.automount
echo "Description=Automount Windows Share" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.automount
echo "" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.automount
echo "[Automount]" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.automount
echo "Where=/var/mnt/remtivovideo" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.automount
echo "TimeoutIdleSec=600   # unmount after 10 min idle (optional)" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.automount
echo "" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.automount
echo "[Install]" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.automount
echo "WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.automount

sudo chmod 777 /etc/systemd/system/var-mnt-remtivovideo.automount

######################################################################################################
### build var-mnt-remtivovideo.mount ###
echo "[Unit]" | sudo tee /etc/systemd/system/var-mnt-remtivovideo.mount
echo "Description=Mount Windows Share" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount
echo "After=network-online.target" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount
echo "Wants=network-online.target" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount
echo "" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount
echo "[Mount]" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount
echo "What=//192.168.68.59/TivoVideo" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount
echo "Where=/var/mnt/remtivovideo" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount
echo "Type=cifs" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount
echo "Options=credentials=/var/home/Tom/.smb/credentials,vers=3.0,uid=1000,gid=1000,nofail,rw,_netdev" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount
echo "" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount
echo "[Install]" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount
echo "WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/var-mnt-remtivovideo.mount

sudo chmod 777 /etc/systemd/system/var-mnt-remtivovideo.mount

######################################################################################################
### build var-mnt-remmusic.automount ###
echo "[Unit]" | sudo tee /etc/systemd/system/var-mnt-remmusic.automount
echo "Description=Automount Windows Share" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.automount
echo "" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.automount
echo "[Automount]" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.automount
echo "Where=/var/mnt/remmusic" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.automount
echo "TimeoutIdleSec=600   # unmount after 10 min idle (optional)" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.automount
echo "" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.automount
echo "[Install]" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.automount
echo "WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.automount

sudo chmod 777 /etc/systemd/system/var-mnt-remmusic.automount

######################################################################################################
### build var-mnt-remmusic.mount ###
echo "[Unit]" | sudo tee /etc/systemd/system/var-mnt-remmusic.mount
echo "Description=Mount Windows Share" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount
echo "After=network-online.target" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount
echo "Wants=network-online.target" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount
echo "" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount
echo "[Mount]" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount
echo "What=//192.168.68.59/music" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount
echo "Where=/var/mnt/remmusic" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount
echo "Type=cifs" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount
echo "Options=credentials=/var/home/Tom/.smb/credentials,vers=3.0,uid=1000,gid=1000,nofail,rw,_netdev" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount
echo "" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount
echo "[Install]" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount
echo "WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/var-mnt-remmusic.mount

sudo chmod 777 /etc/systemd/system/var-mnt-remmusic.mount

######################################################################################################

### Startup the new mounts ###
sudo systemctl daemon-reload
sudo systemctl enable --now var-mnt-remtivovideo.automount
sudo systemctl enable --now var-mnt-remmusic.automount
