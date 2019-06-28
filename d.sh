#!/bin/bash

vurllist="u.txt"
vdownapp="youtube-dl"
vproxy="socks5://192.168.1.38:7070/"
#vdownall=${vdownapp}" --proxy "${vproxy}
vdownall=${vdownapp}
vgitdir=/root/Pronhub_video_download_helper
vlocaldir="/usr/local/down"
#vftpput="ncftpput -u mator -p artlover mator.f3322.net /ftp"
#vdescdir="/mnt/mator/Mounted_NAS_18.223_DownLoad/PH/"

cd $vgitdir
git pull
rm -rf $vlocaldir/u.txt
cp -f $vgitdir/u.txt $vlocaldir/u.txt

cd $vlocaldir
rm -rf list.txt
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
			ls *"$vstrend".mp4 | xargs -I {} mv {} "$vstrend".mp4
			echo "http://ec2-52-15-111-187.us-east-2.compute.amazonaws.com:3000/"$vstrend".mp4">>list.txt
			#ls *"$vstrend".mp4 | xargs -I {} $vftpput "${vlocaldir}/{}"
			#echo "Video Moved to "$vdescdir
			break
		fi
	done
done
rm -rf $vlocaldir/list.txt
cp -f $vlocaldir/list.txt $vgitdir
cd $vgitdir
git add list.txt
git commit -m "new"
git push  origin master
