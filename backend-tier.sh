#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/expense"
FILE_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$FILE_NAME-$TIME_STAMP.log"

mkdir -p $LOGS_FOLDER

USERID=$(id -u)
ROOT_CHECK(){
if [ $? -ne 0 ]
then
    echo -e "please run the script with $R root user access $N" | tee -a $LOG_FILE
    exit 1
fi
}

ROOT_CHECK

echo -e "script started executing at: $G $(date)  $N"   | tee -a $LOG_FILE
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R FAILED.. $N"        | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$1 is $G SUCCESS.. $N"       | tee -a $LOG_FILE
fi
}

dnf module disable nodejs -y    &>>$LOG_FILE
VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:20 -y   &>>$LOG_FILE
VALIDATE $? "Enabling nodejs"

dnf install nodejs -y           &>>$LOG_FILE
VALIDATE $? "Nodejs installation"

id expense                       &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo -e "expense user is not created..$G creating user expense$N"
    useradd expense              &>>$LOG_FILE
    VALIDATE $? "user expense creation"
else
    echo -e "expense user is already created.. $Y SKIP Creating again$N"
fi

mkdir -p /app
VALIDATE $? "Application folder /app creation"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>$LOG_FILE
VALIDATE $? "Backend code download"

cd /app
rm -rf /app/*           &>>$LOG_FILE
unzip /tmp/backend.zip   &>>$LOG_FILE
VALIDATE $? "Extracting backend zip file"

npm install              &>>$LOG_FILE
VALIDATE $? "Build tool installation"

cp /home/ec2-user/expense-practice/backend.service /etc/systemd/system/backend.service

dnf install mysql -y   &>>$LOG_FILE
VALIDATE $? "Installing mysql client"

mysql -h mysql.muntaj.fun -uroot -pExpenseApp@1 < /app/schema/backend.sql   &>>$LOG_FILE
VALIDATE $? "Mysql schema load"

systemctl daemon-reload    &>>$LOG_FILE
VALIDATE $? "Reloading daemon"

systemctl enable backend   &>>$LOG_FILE
VALIDATE $? "Backend enabalement"

systemctl restart backend    &>>$LOG_FILE
VALIDATE $? "Restarting backend"







