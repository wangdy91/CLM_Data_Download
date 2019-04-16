#!/bin/bash
### This script is to copy file from remote server automaticly on 2019/04/09
### First of all steps, you should creat folder by running "mkdir Precip"  "mkdir Solar"  "mkdir TPHWL"
while [ "1" ]   # This is a endless loop, which can ensure the copy runs all the time unitil it is successful
do
    echo "copy list from remote server ... "
    scp wangdy@66.42.77.218:/home/wangdy/download_list ./r830_cp_list_new
    echo "checking update ..."
    diff r830_cp_list_old r830_cp_list_new | grep ">" | awk '{print $2}' > list_upd
    LINE_NU=`cat list_upd | wc -l`

    if [ "$LINE_NU" == "0" ];then
        echo "Nothing update, check again after waiting for 10s ..."
        sleep 10
        continue
    else
        for LINE_R in `seq 1 ${LINE_NU}`
        do
            LINE_CONTENT=`sed -n ${LINE_R}p list_upd`
            CP_OBJ_DIR=`sed -n ${LINE_R}p list_upd | cut -d'/' -f3` 
            while [ "1" ]
            do
            scp -r wangdy@66.42.77.218:/home/wangdy/${LINE_CONTENT} ./${CP_OBJ_DIR}/ 
            cp_signal=$?
            if [ "$cp_signal" == "0" ];then
                ssh wangdy@66.42.77.218 "rm -f /home/wangdy/${LINE_CONTENT}"
                echo "${LINE_CONTENT} copy successful"
                break
            fi
            done
        done
        mv -f r830_cp_list_new r830_cp_list_old
    fi
done
### End of this script