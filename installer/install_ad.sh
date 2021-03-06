# Bash script to install AppDaemon 4.x & Monitor-App
# Recommended OS: Latest Raspbian downloaded from raspberrypi.org
cd ~
clear
echo -e "\e[0m"
echo -e "\e[96m______  ___            __________                    _______                 \e[90m"
echo -e "\e[96m___   |/  /_______________(_)_  /______________      ___    |_______________ \e[90m"
echo -e "\e[96m__  /|_/ /_  __ \_  __ \_  /_  __/  __ \_  ___/________  /| |__  __ \__  __ \ \e[90m"
echo -e "\e[96m_  /  / / / /_/ /  / / /  / / /_ / /_/ /  /   _/_____/  ___ |_  /_/ /_  /_/ / \e[90m"
echo -e "\e[96m/_/  /_/  \____//_/ /_//_/  \__/ \____//_/           /_/  |_|  .___/_  .___/  \e[90m"
echo -e "\e[96m                                                            /_/     /_/    \e[90m"
echo -e "\e[0m"
echo -e "\e[0m"
echo -e "\e[0m"
cd ~
echo -e "\e[96m  Preparing system for AppDaemon 4.x & Monitor-App...\e[90m"
echo -e "\e[0m"

# Prepare system
echo -e "\e[96m[STEP 1/10] Updating system...\e[90m"
if sudo apt-get update -y;
then
    echo -e "\e[32m Updating | Done\e[0m"
else
    echo -e "\e[31m Updating | Failed\e[0m"
    exit;
 fi
echo -e "\e[0m"

if sudo apt-get upgrade -y;
then
    echo -e "\e[32m[STEP 1/10] Update & Upgrading | Done\e[0m"
else
    echo -e "\e[31m[STEP 1/10] Update & Upgrading | Failed\e[0m"
    exit;
fi
echo -e "\e[0m"


# Installing packages
echo -e "\e[96m[STEP 2/10] Installing Python & Dependencies...\e[90m"
if sudo apt install python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev git -y;
then
    echo -e "\e[32m Installing Python & Dependencies | Done\e[0m"
else
    echo -e "\e[31m Installing Python & Dependencies | Failed\e[0m"
    exit;
fi
echo -e "\e[0m"

if git clone https://github.com/Odianosen25/Monitor-App.git;
then
    echo -e "\e[32m[STEP 2/10] Cloning Monitor-App | Done\e[0m"
else
    echo -e "\e[31m[STEP 2/10] Cloning Monitor-App | Failed\e[0m"
    exit;
fi
echo -e "\e[0m"

#Create User appdaemon
echo -e "\e[96m[STEP 3/10] Creating users...\e[90m"
if sudo useradd -rm appdaemon;
then
    echo -e "\e[32m Creating user | Done\e[0m"
else
    echo -e "\e[31m Creating user | Failed\e[0m"
    exit;
fi
echo -e "\e[0m"

if sudo mkdir /srv/appdaemon;
then
    echo -e "\e[32m Creating AppDaemon folder | Done\e[0m"
else
    echo -e "\e[31m Creating AppDaemon folder | Failed\e[0m"
    exit;
fi
echo -e "\e[0m"


if sudo chown appdaemon:appdaemon /srv/appdaemon;
then
    echo -e "\e[32m[STEP 3/10] Creating users | Done\e[0m"
else
    echo -e "\e[31m[STEP 3/10] Creating users | Failed\e[0m"
    exit;
fi


# Copy service to run AppDaemon as Service
echo -e "\e[96m[STEP 4/10] Copying service to run AppDaemon as Service...\e[90m"
if sudo cp ~/Monitor-App/installerscript/appdaemon@appdaemon.service /etc/systemd/system/appdaemon@appdaemon.service;
then
    echo -e "\e[32m[STEP 4/10] Copy service | Done\e[0m"
else
    echo -e "\e[31m[STEP 4/10] Copy service | Failed\e[0m"
    exit;
fi

# Prepare installerscript files for part 2
if sudo cp -r ~/Monitor-App/installerscript /home/appdaemon/;
then
    echo -e "\e[32mPreparation of scriptfiles for part 2 | Done\e[0m"
else
    echo -e "\e[31mPreparation of scriptfiles for part 2 | Failed\e[0m"
    exit;
fi

sudo cp ~/Monitor-App/apps/home_presence_app/home_presence_app.py /home/appdaemon/installerscript/home_presence_app.py

# Prepare installation part 2 file
if sudo cp ~/Monitor-App/installerscript/install_ad_part2.sh ~/install_ad_part2.sh;
then
    echo -e "\e[32mPreparation of installation part 2 | Done\e[0m"
else
    echo -e "\e[31mPreparation of installation part 2 | Failed\e[0m"
    exit;
fi

if sudo chmod +x ~/install_ad_part2.sh;
then
    echo -e "\e[32mDone\e[0m"
else
    echo -e "\e[31mFailed\e[0m"
    exit;
fi

echo " "
echo " "
echo " "
echo -e "\e[32mTo continue installation, type: \e[96mbash install_ad_part2.sh\e[0m"
echo " "
echo " "
echo " "

sudo -u appdaemon -H -s

if sudo systemctl enable appdaemon@appdaemon.service --now;
then
    echo -e "\e[32mAutostart Service | Done\e[0m"
else
    echo -e "\e[31mAutostart Service | Failed\e[0m"
    exit;
fi

sudo rm -r /home/appdaemon/installerscript

echo -e "\e[0m"
echo -e "\e[0m"
echo -e "\e[0m"
echo -e "\e[0m"
echo -e "\e[32mThe final step now are to fill in information about your own\e[0m"
echo -e "\e[32menvironment, like IP address, username and password ++ for your\e[0m"
echo -e "\e[32mMQTT broker in appdaemon.conf...\e[0m"
echo -e "\e[32mYou will find the file here:\e[0m"
echo -e "\e[96msudo nano /home/appdaemon/.appdaemon/conf/appdaemon.conf\e[0m"
echo -e "\e[32mFinish the edit with ctrl+o & ctrl+x\e[0m"
echo -e "\e[0m"
echo -e "\e[32mThen you need to edit and complete missing information in\e[0m"
echo -e "\e[32mapps.yaml that you will find here:\e[0m"
echo -e "\e[96msudo nano /home/appdaemon/.appdaemon/conf/apps.yaml\e[0m"
echo -e "\e[32mFinish the edit with ctrl+o & ctrl+x\e[0m"
echo -e "\e[0m"
echo -e "\e[32mWhen all above is done, \e[96msudo reboot now\e[32m your device.\e[0m"
echo -e "\e[32mIf all went well, you should see new entities in HA\e[0m"
echo -e "\e[0m"
