#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"

mkdir -p $LOGS_FOLDER

ROOT(){
USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo -e "please run the script with $R root user privileges $N"  | tee -a $LOG_FILE
    exit 1
fi
}
ROOT

USAGE(){
    echo -e "$R USAGE :: sudo sh database.sh package1 package2..$N"  | tee -a $LOG_FILE
    exit 1
}

if [ $# -eq 0 ]
then
    USAGE
fi

echo -e "$Y Script started $N executing at $(date)" | tee -a $LOG_FILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R FAILED.. $N"  | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is $G SUCCESS.. $N"  | tee -a $LOG_FILE
    fi
}

for package in $@
do
    dnf list installed $package   &>>$LOG_FILE
    if [ $? -ne 0 ]
    then
        echo -e "$R $package is not installed, $N $Y going to install it $N"  | tee -a $LOG_FILE
        dnf install $package -y        &>>$LOG_FILE
        VALIDATE $? "$package installation"
    else
        echo -e "$G $package is already installed $N $Y nothing to do $N"  | tee -a $LOG_FILE
    fi
done

