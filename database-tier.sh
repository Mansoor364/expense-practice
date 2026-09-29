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

dnf list installed git 
if [ $? -ne 0 ]
then
    echo "git is not installed, going to install it"
    dnf install git -y
    VALIDATE $? "installing git"
else
    echo "git is already installed nothing to do"
fi

dnf list installed mysql -y 
if [ $? -ne 0 ]
then
    echo "mysql is not installed.. going to install it.."
    dnf install mysql -y 
    VALIDATE $? "installing mysql"
else
    echo "mysql is already installed.. nothing to do"
fi
