#!/bin/bash

source ./common.sh
check_root

echo "Enter the mysql password:"
read -s mysql_secure_password
echo "mysql password is: $mysql_secure_password"

echo -e "$B Script Start time: $TIMESTAMP $N"

###############################
dnf install mysql-server -y &>>$LOGFILE
systemctl enable mysqlds &>>$LOGFILE
systemctl start mysqldf &>>$LOGFILE

mysqll -h db.mydevops-learning.cloud -uroot -p${mysql_secure_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_secure_password} &>>$LOGFILE
else 
    echo -e "mysql password is already setup. $Y SKIPPING $N"
fi
###############################

echo -e "$B Script End time:   $TIMESTAMP $N"