#!/bin/bash

vurllist="u.txt"
vdownapp="youtube-dl"
vproxy="socks5://192.168.1.38:7070/"
vdownall=${vdownapp}" --proxy "${vproxy}
vlocaldir="/root"
vdescdir="/mnt/mator/Mounted_NAS_18.223_DownLoad/PH/"

cd $vlocaldir
$vdownall -U

vlieshu=$(cat $vurllist|wc -l)
for ((i=1; i<=$vlieshu; i++))
do
	for ((ii=1; ii<=3; ii++))
	do
		sed -n "$i"p $vurllist | xargs $vdownall

		vstrend=$(sed -n "$i"p $vurllist)
		vstrend=$(echo ${vstrend:47})

		ls *"$vstrend".mp4>/dev/null

		if [ $? -ne 0 ]; then
			echo Dwonload fail ,Retyr Mission !
			ping localhost -c 10 > /dev/null
		else
			echo "["${i}"/"${vlieshu}"] OK."
			ls *"$vstrend".mp4 | xargs -I {} echo {}" Video Dwonload Done."
			ls *"$vstrend".mp4 | xargs -I {} mv -f "${vlocaldir}/{}" $vdescdir
			echo "Video Moved to "$vdescdir
			break
		fi
	done
done
