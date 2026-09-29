#!/bin/bash

ROOT(){
USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo "please run the script with root user privileges"
    exit 1
fi
}
ROOT

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 is FAILED.."
        exit 1
    else
        echo "$2 is SUCCESS.."
    fi
}

for package in $@
do
    dnf list installed $package
    if [ $? -ne 0 ]
    then
        echo "$package is not installed, going to install it"
        dnf install $package -y
        VALIDATE $? "$package installation"
    else
        echo "$package is already installed nothing to do"
    fi
done

