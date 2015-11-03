#!/bin/sh

fsunlock

echo "deb http://us.archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://us.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse" >> /etc/apt/sources.list

apt-get update &&
apt-get install man-db manpages git &&

git clone https://github.com/darkblinded/t510.git /writable/home/user/t510
