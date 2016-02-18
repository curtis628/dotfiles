#!/bin/bash

: "${CATALINA_BASE:?Need to set CATALINA_BASE to be non-empty}"

local_conf=$CATALINA_BASE/conf 
echo Cleaning up old files: ssl.keystore, vcac.keystore, private.key, solution-users.properties
rm -f $local_conf/ssl.keystore $local_conf/vcac.keystore $local_conf/private.key $local_conf/solution-users.properties

ip=$1
fqdn=$2
remote_vra=$3

if [ -z $ip ]
then
#    read -p "Your IP address: " ip
    read -p "Your machine name (FQDN): " fqdn
    read -p "Remote VRA FQDN: " remote_vra
    echo
fi

echo ---------- Using following values ----------
#echo "        ip: $ip"
echo "      fqdn: $fqdn"
echo "remote_vra: $remote_vra"
echo --------------------------------------------

echo "To find decrypted remote DB password, SSH into VA, find encrypted password in /etc/vcac/server.xml, and then run: vcac-config prop-util -d --p [password]"
read -p "Remote DB Password: " db_password

sed -e s:REMOTE_VRA:$remote_vra:g -e s:REMOTE_DB_PASSWORD:$db_password:g $local_conf/persistence.properties.orig > $local_conf/persistence.properties
sed -e s:REMOTE_VRA:$remote_vra:g -e s:REMOTE_DB_PASSWORD:$db_password:g $local_conf/server.xml.orig > $local_conf/server.xml
sed -e s:LOCAL_CONF:$local_conf:g -e s:YOUR_MACHINE_NAME:$fqdn:g -e s:REMOTE_VRA:$remote_vra:g $local_conf/security.properties.orig > $local_conf/security.properties

echo
echo "Creating ssl.keystore..."
keytool -genkey -keystore $local_conf/ssl.keystore -dname CN=$fqdn -alias tomcat -storepass password -keyalg RSA -validity 700

echo
echo "Next, you'll need to run setup-dev-box..."
echo "i.e.: java -jar ~/workspace/vcac/tools/setup-dev-box/target/setup-dev-box.jar register-service --configDir $local_conf"
