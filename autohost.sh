#!/bin/bash

clear

#Color & FX

BLNK='\033[5m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YF='\033[33;5m'
NC='\033[0m'

#Introduction Text

echo "Welcome to the Apache Auto Virtual Host Configuration Tool"
sleep 2
clear

#Create New Directory Function

createdirectory() {
echo "Please Enter New Domain Name (ex: example.com)"
echo
read -p "New Domain Name: " domName

if [ ! -d /var/www/$domName ]; then
    echo
    sudo mkdir -p /var/www/$domName
    dom="/var/www/$domName"
    domAlias="www.$domName"
    sudo chmod -R 755 $dom
    echo
    echo -e "${GREEN}Success!${NC}"
    sleep 1
    clear;
    echo -e "Current Working Domain:${BLNK} $domName${NC}"
    sleep 2;
    echo
else
    clear
    echo -e "${YF}Error: Directory $dom already exists.${NC}"
    sleep 2
    clear
    echo
fi
}

#Select Existing Directory Function

pickdirectory() {
echo "Please Enter Existing Domain Name (format: example.com)"
echo
read -p "Existing Domain Name: " domName

if [ -d /var/www/$domName ]; then
    dom="/var/www/$domName"
    domAlias="www.$domName"clear;
    echo
    sudo chmod -R 755 $dom
    echo
    echo -e "${GREEN}Success!${NC}"
    sleep 1
    clear;
    
else
    clear
    echo -e "${YF}Error: Directory $dom does not exist.${NC}"
    sleep 2
    clear
    echo
fi
}

#Config File Generator Function

confGen () {
    echo "Port Number? (Default HTTP: 80)"
    echo
    read -p "Port Number: " portNum
    confContent="
    <VirtualHost *:$portNum> \n
\n
        \tServerAdmin webmaster@localhost\n
        \tServerName $domName\n
        \tServerAlias $domAlias\n
        \tDocumentRoot $dom\n
\n
\n
        \tErrorLog ${APACHE_LOG_DIR}/error.log\n
        \tCustomLog ${APACHE_LOG_DIR}/access.log combined\n
\n
    </VirtualHost>
"
    if [[($((portNum)) = $portNum) && (-d $dom) ]]; then
        echo
        echo -e "${BLNK}Generating Files...${NC}"
        echo -e $confContent > /tmp/$domName.conf
        sudo sh -c 'mv /tmp/'$domName'.conf /etc/apache2/sites-available/'$domName'.conf'
        clear;
        echo -e "${GREEN} Virtual Host Generation Successful. ${NC}"
        sleep 1
        clear
    elif [$((portNum)) != $portNum]; then
        clear;
        echo -e "${YF}Port Number Value Invalid. ${$NC}"
        sleep 1
        clear
    else
        clear;
        echo -e "${YF}Please create or load a domain before generating a conf File! ${NC}"
        sleep 3
        clear
    fi

}

#Generate Test HTML Function

htmlGen () {
    testHTML="
    <html>\n
    \t<head>\n
    \t\t<title>Welcome to $domName!</title>\n
    \t</head>\n
    \t<body>\n
    \t\t<h1>Success! The $domName virtual host is working!</h1>\n
    \t</body>\n
    </html>"

    if [ -d $dom ]; then
        echo
        echo -e "${BLNK}Generating Files...${NC}"
        echo -e $testHTML > /tmp/testHTML.html
        sudo sh -c 'mv /tmp/testHTML.html /var/www/'$domName'/index.html'
        sudo chmod -R 755 $dom
        clear;
        echo -e "${GREEN} Test HTML Generation Successful. ${NC}"
        sleep 1
        clear
    else
        clear;
        echo -e "${YF}Please create or load a domain before generating a HTML! ${NC}"
        sleep 3
        clear
    fi

}

#Import HTML Function

htmlImp() {
echo "Please enter the path to the html you wish to import (format: /path/to/dir/example.html): "
read -p "HTML Path: " htmlDir

    if test -f "$htmlDir"; then
        echo
        sudo cp $htmlDir /var/www/$domName/index.html
        sudo chmod -R $dom
        clear;
        echo -e "${GREEN} HTML Import Successful. ${NC}"
        sleep 1
        clear
    else
        clear
        echo -e "${YF}HTML File not Found! ${NC}"
        sleep 3
        clear
    fi
}

#Enable Virtual Host Function

enableVirtHost () {
    if test -f "/etc/apache2/sites-available/$domName.conf"; then
        sudo a2dissite $(ls /etc/apache2/sites-available/);
        clear;
        clear;
        sudo a2ensite $domName.conf;
        sudo service apache2 reload;
        clear;
        echo -e "${GREEN}Virtual Host Successfully Enabled${NC}"
        sleep 1
        clear
    else
        clear;
        echo -e "${YF}Please configure a .conf file for the Current Working Domain before attempting to Enable the Virtual Host.${NC}";
        sleep 3
        clear
    fi

}

#Main Menu

while true; do
    while true; do
        echo -e "Current Working Domain:${BLNK} $domName ${NC}"
        sleep 2
        echo
        echo "Main Menu:"
        echo
        echo "1) Auto Config"
        echo "2) New Domain"
        echo "3) Existing Domain"
        echo "4) Generate Test HTML"
        echo "5) Import HTML"
        echo "6) Configure .conf file for Current Working Domain"
        echo "7) Enable Virtual Host"
        echo "8) Quit"
        echo
        read -p "What would you like to do today? " option1
        case $option1 in
            1)
            clear
            createdirectory
            htmlGen
            confGen
            enableVirtHost
            ;;
            2)
            clear
            createdirectory
            ;;
            3)
            clear
            pickdirectory
            ;;
            4)
            clear
            htmlGen
            ;;
            5)
            clear
            htmlImp
            ;;
            6)
            clear
            confGen
            ;;
            7)
            clear
            enableVirtHost
            ;;
            8)
            clear
            echo "Goodbye."
            sleep 1
            clear
            exit $?
            ;;

        esac

    done

    done