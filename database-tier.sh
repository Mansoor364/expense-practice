#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/expense"
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

dnf install mysql-server -y       &>>$LOG_FILE
VALIDATE $? "mysql-server installation"

systemctl enable mysqld           &>>$LOG_FILE
VALIDATE $? "Enabling mysql-server"

systemctl start mysqld           &>>$LOG_FILE
VALIDATE $? "starting mysql-server"

mysql -h 54.235.5.110 -uroot -pExpenseApp@1     &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo -e "$Y mysql root password is not setted up.. $N $R set it $N" | tee -a $LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1  &>>$LOG_FILE
    VALIDATE $? "mysql root password setting up"
else
    echo -e "$Y mysql root password is already set.. $N $G SKIPP IT $N"  | tee -a $LOG_FILE
fi
