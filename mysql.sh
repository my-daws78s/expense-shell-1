#!/bin/bash

source ./common.sh
check_root

echo "Enter the mysql password:"
read -s mysql_secure_password
echo "mysql password is: $mysql_secure_password"

echo -e "$B Script Start time: $TIMESTAMP $N"

###############################
#dnf remove mysql-server -y &>>$LOGFILE

dnf list installed mysql-server &>>$LOGFILE #Here it throws error when package is not listed...
if [ $? -eq 0 ]
then
    echo -e "MYSQL is already installed.... $Y SKIPPING $N"
else 
    dnf install mysql-server -y &>>$LOGFILE
    #VALIDATE $? "Installation of mysql"
fi

systemctl enable mysqld &>>$LOGFILE
#VALIDATE $? "Enabling mysqld"

systemctl start mysqld &>>$LOGFILE
#VALIDATE $? "Starting of mysql"

#Linux scripting is not idempotent by nature, user needs to take care:
#Nature of program irrespective of how many times u run, it shud not change result.
# mysql_secure_installation --set-root-pass $mysql_secure_password &>>$LOGFILE
# VALIDATE $? "Setting up DB password"

#mysql -h localhost -uroot -p${mysql_secure_password} -e 'show databases;' &>>$LOGFILE
mysql -h db.mydevops-learning.cloud -uroot -p${mysql_secure_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_secure_password} &>>$LOGFILE
    #VALIDATE $? "Setting up DB password: "
else 
    echo -e "mysql password is already setup. $Y SKIPPING $N"
fi
###############################

echo -e "$B Script End time:   $TIMESTAMP $N"

#Output: The command without set -e and having trap will print all error messages at every line of failure,
# but when set -e is given it quits after the first error in the script.