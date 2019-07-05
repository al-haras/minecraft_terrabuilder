#!/bin/bash

# Wait for apt lock
while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
  echo "Waiting for apt lock..."
  sleep 1
done

apt-get update -y && \
  apt-get install -y openjdk-8-jre-headless screen

wget -O server.jar https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar

# Agree to EULA
echo "eula=true" > eula.txt

# Start the minecraft server
java -Xmx1024M -Xms1024M -jar server.jar nogui
