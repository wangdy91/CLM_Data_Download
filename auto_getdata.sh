#!/bin/bash
### This is a script used to download inpudata automatically on 2019/04/09
### Script downloading includes Precip(Prec);Solar(Solr);TPHWL(TPQWL)
re_signal=1
PERCENT_SPACE=`df -hT -BG | grep /dev/vda1 | awk '{print $5}' | cut -d'G' -f1`  # check harddisk remain space 
ACC_SPACE=2                                                                 # set the threshold 
VAR_DOWNLOAD=("Precip"  "Solar" "TPHWL" "Prec" "Solr" "TPQWL")  # the front section of array is longname, the latter section of array is shortname 
for nvar in `seq 0 2`
do
    for iyer in `seq -w 1988 1989`                            # The start and end year of inputdata that you want to download  
    do 
        for imon in `seq -w 1 12`                             # The start and end month of inputdata
        do
            while [ "1" ]
            do
                PERCENT_SPACE=`df -hT -BG | grep /dev/vda1 | awk '{print $5}' | cut -d'G' -f1`
                if [ "${PERCENT_SPACE}" -ge "${ACC_SPACE}" ];then   # Check if the precent disk space is enough ?
                    break
                fi
                echo "The remaining space is insufficient, that might be less 2G and it will sleep for a while. Please be patient ... "
                sleep 1800                        # sleep 1000 seconds if the remain space isn't enough, when it is less 2G.                                     
            done

            while [ "1" ]    # This is a endless loop, which can ensure the download runs all the time unitil it is successful 
            do
                wget --no-check-certificate -c -P ./lmwg/atm_forcing.datm7.GSWP3.0.5d.v1.c170516/${VAR_DOWNLOAD[nvar]}/ https://svn-ccsm-inputdata.cgd.ucar.edu/trunk/inputdata/atm/datm7/atm_forcing.datm7.GSWP3.0.5d.v1.c170516/${VAR_DOWNLOAD[nvar]}/clmforc.GSWP3.c2011.0.5x0.5.${VAR_DOWNLOAD[nvar+3]}.${iyer}-${imon}.nc
                re_signal=$?                    # When the download file is completed without breaking ,the return value is 0, the other conditons is not the 0.
                if [ "${re_signal}" == "0" ];then
                echo "lmwg/atm_forcing.datm7.GSWP3.0.5d.v1.c170516/${VAR_DOWNLOAD[nvar]}/clmforc.GSWP3.c2011.0.5x0.5.${VAR_DOWNLOAD[nvar+3]}.${iyer}-${imon}.nc" >> download_list
                break   # This is the a loop exit, if the download file is comleted, the procedure into if, and it can jump that loop through break.
                fi
            done
            
        done
    done
done
### end of this script
