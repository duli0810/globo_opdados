#!/usr/bin/env bash


#while read line
#do
#echo -e "\ncurl -sIL $line | egrep -i 'HTTP|Location'"
#curl -sIL $line | egrep -i 'HTTP|Location'
#done < chgcurlfile.txt

for line in $(cat "chgcurlfile.txt" | sed '/^$/D; s/ //g')
do
    echo -e "-------------------------------"
    echo -e "curl -sIL $line | egrep -i '(http|location|served-from)'"
    curl -sIL $line | egrep -i '(http|location|served-from)'
done
echo -e "-------------------------------"