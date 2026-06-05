### Setup hidden credentials ###

sudo mkdir home/Tom/.smb

echo "username=Tom" | sudo tee /home/Tom/.smb/credentials
echo "password=T----t" | sudo tee -a /home/Tom/.smb/credentials

sudo chmod 600 ~/.smb/credentials
