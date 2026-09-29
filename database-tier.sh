#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

ROOT(){
USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo -e "please run the script with $R root user privileges $N"
    exit 1
fi
}
ROOT

USAGE(){
    echo -e "$R USAGE :: sudo sh database.sh package1 package2..$N"
    exit 1
}

if [ $# -eq 0 ]
then
    USAGE
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R FAILED.. $N"
        exit 1
    else
        echo -e "$2 is $G SUCCESS.. $N"
    fi
}

for package in $@
do
    dnf list installed $package
    if [ $? -ne 0 ]
    then
        echo -e "$R $package is not installed, $N $Y going to install it $N"
        dnf install $package -y
        VALIDATE $? "$package installation"
    else
        echo -e "$G $package is already installed $N $Y nothing to do $N"
    fi
done

