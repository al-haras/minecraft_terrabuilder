#!/bin/bash
apt-get update -y
apt-get install git -y
apt-get install openjdk-8-jre-headless -y
password="minecraft"
echo -e "$password\n$password\n" | passwd admin
su admin -c 'mkdir /home/admin/build'
cd /home/admin/build
su admin -c 'wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar'
su admin -c 'java -Xms1G -Xmx1G -jar BuildTools.jar --rev 1.14.3 nogui'
su admin -c 'mkdir /home/admin/server'
su admin -c 'mv /home/admin/build/spigot-1*.jar /home/admin/server/spigot.jar'
cd /home/admin/server
su admin -c 'java -Xms1G -Xms1G -jar spigot.jar'
echo "eula=true" > eula.txt
su admin -c 'sudo killall -9 java'
su admin -c 'java -Xms2G -Xmx2G -jar spigot.jar'
su admin -c 'sudo killall -9 java'
su admin -c 'sudo killall -9 java'
su admin -c 'java -Xms2G -Xmx2G -jar spigot.jar'
