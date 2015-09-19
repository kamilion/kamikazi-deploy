#!/bin/bash
echo "KAMIKAZI: Updating package lists..."
apt-get update
echo "KAMIKAZI: Installing git."
apt-get install -y --no-install-recommends git
echo "KAMIKAZI: Configuring git."
git config --global user.email "kamilion@gmail.com"
git config --global user.name "Graham Cantin"
git config --global push.default simple
mkdir -p /home/git
cd /home/git
echo "KAMIKAZI: Checking out kamikazi-deploy repository..."
git clone https://kamilion@github.com/kamilion/kamikazi-deploy.git
echo "KAMIKAZI: Attempting to rebuild ISO contents..."
cd /home/git/kamikazi-deploy/resources/buildscripts/wily/
apt-get full-upgrade -y
./00-build-clean-iso-from-source.sh
echo "KAMIKAZI: Autobuild complete."
exit 0
