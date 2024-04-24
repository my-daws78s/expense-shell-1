#!/bin/bash

source ./common.sh
check_root

echo "Enter the mysql password:"
read -s mysql_secure_password
echo "mysql password is: $mysql_secure_password"

echo -e "Starting Script at:: $B $TIMESTAMP $N"

dnf module disable nodejs -y &>>$LOGFILE
dnf module enable nodejs:20 -y &>>$LOGFILE
dnf remove nodejs -y &>>$LOGFILE

dnf list installed nodejs &>>$LOGFILE # why is set e/trap throwing error here?
if [ $? -eq 0 ]
then
    echo -e "nodejs is already installed.... $Y SKIPPING $N"
else 
    dnf install nodejs -y &>>$LOGFILE
fi

#Need to handle idempotent nature
id expense &>>$LOGFILE
if [ $? -eq 0 ]
then
    echo -e "User expense is alreay created..... $Y SKIPPING $N"
else 
    useradd expense &>>$LOGFILE
fi

#The below command using -p idempotency will be taken care
mkdir -p /app &>>$LOGFILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE

rm -fr /app/*
cd /app
unzip /tmp/backend.zip &>>$LOGFILE

npm install &>>$LOGFILE

cp /home/ec2-user/expense-shell-1/backend.service /etc/systemd/system/backend.service &>>$LOGFILE 

systemctl daemon-reload &>>$LOGFILE

systemctl start backend &>>$LOGFILE

systemctl enable backend &>>$LOGFILE

dnf install mysql -y &>>$LOGFILE

#mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -p${mysql_secure_password} < /app/schema/backend.sql &>>$LOGFILE
mysql -h db.mydevops-learning.cloud -uroot -p${mysql_secure_password} < /app/schema/backend.sql &>>$LOGFILE

systemctl restart backend &>>$LOGFILE

echo -e "Finishing Script at:: $B $TIMESTAMP $N"