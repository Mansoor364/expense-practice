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

dnf list installed git 
if [ $? -ne 0 ]
then
    echo "git is not installed, going to install it"
    dnf install git -y
    if [ $? -ne 0 ]
    then
        echo "git is not installed.. check it "
        exit 1
    else
        echo "git is installed successfully"
    fi
else
    echo "git is already installed nothing to do"
fi

dnf list installed mysql -y 
if [ $? -ne 0 ]
then
    echo "mysql is not installed.. going to install it.."
    dnf install mysql -y 
    if [ $? -ne 0 ]
    then
        echo "mysql installation is failed check it.."
        exit 1
    else
        echo "mysql is installed successfully"
    fi
else
    echo "mysql is already installed.. nothing to do"
fi
