#!/bin/bash

set -e

trap 'handleError $LINENO "$BASH_COMMAND"' ERR
handleError(){
    echo -e "Error occurred at LineNo: $1 and\nCommand error occurred is: $2"
}

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

#Colors:
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

check_root(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R User does not have root previleges. Hence cannot process from here. $N"
        exit 1
    else
        echo "User has root access."
    fi
}

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2... $G SUCCESS. $N"
    else
        echo -e "$2... $R FAILURE. $N"
        exit 1
    fi
}
