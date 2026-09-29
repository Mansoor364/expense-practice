#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/expense"
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPTNAME-$TIME_STAMP.log"

mkdir -p $LOGS_FOLDER

ROOT_CHECK(){
USERID=$(id -u)  
if [ $USERID -ne 0 ]
then
    echo -e "$R please run the script with root user privileges$N"  | tee -a $LOG_FILE
    exit 1
fi
}
ROOT_CHECK

echo -e "Script started executing at: $Y $(date) $N"  | tee -a $LOG_FILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R FAILED..$N"         | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is $G SUCCESSFULL..$N"    | tee -a $LOG_FILE
    fi
}

dnf install mysql-server -y           &>>$LOG_FILE
VALIDATE $? "Installing mysql-server"

systemctl enable mysqld               &>>$LOG_FILE
VALIDATE $? "Enabling mysql-server"

systemctl start mysqld                &>>$LOG_FILE
VALIDATE $? "Starting mysql-server"

mysql -h  -uroot -pExpenseApp@1 -e 'show databases;'  &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo -e "$Y mysql root password is not set-up... $N setting it" | tee -a $LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "mysql root password set-up"
else
    echo -e "$G mysql root password $N is already setted.."   | tee -a $LOG_FILE
fi



