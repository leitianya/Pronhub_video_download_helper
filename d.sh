#!/bin/bash

if pgrep youtube-dl;then
	exit
fi

vurllist="u.txt"
vdownapp="youtube-dl"
vproxy="socks5://192.168.1.38:7070/"
#vdownall=${vdownapp}" --proxy "${vproxy}
vdownall=${vdownapp}
vgitdir=/root/Pronhub_video_download_helper
vlocaldir="/usr/local/down"
vhttpdir="http://ec2-52-15-111-187.us-east-2.compute.amazonaws.com:3000/"
cur_dateTime=`date +%F | sed 's/-//g'``date +%T | sed 's/://g'`
logfile=$vlocaldir/$cur_dateTime.log
#vftpput="ncftpput -u mator -p ****** mator.f3322.net /ftp"
#vdescdir="/mnt/mator/Mounted_NAS_18.223_DownLoad/PH/"

if test $( pgrep -f $vdownapp | wc -l ) -ne 0;then
        echo "youtobe-dl is running... exit."
        exit
fi

touch $logfile
date >> $logfile 2>&1
echo "Script Start!" >> $logfile 2>&1

df -m / >> $logfile 2>&1

cd $vgitdir
git pull >> $logfile 2>&1

rm -rf $vlocaldir/u.txt
cp -f $vgitdir/u.txt $vlocaldir/u.txt

rm -rf $vlocaldir/list.txt
touch $vlocaldir/list.txt

cd $vlocaldir
$vdownall -U >> $logfile 2>&1

vlieshu=$(cat $vurllist|wc -l)
for ((i=1; i<=$vlieshu; i++))
do
	for ((ii=1; ii<=3; ii++))
	do
		sed -n "$i"p $vurllist | xargs $vdownall >> $logfile 2>&1
		vstrend=$(sed -n "$i"p $vurllist)
		vstrend=$(echo ${vstrend:47})
		ls *"$vstrend".mp4>/dev/null
		if [ $? -ne 0 ]; then
			echo "Dwonload fail ,Retyr Mission !" >> $logfile 2>&1
			ping localhost -c 10 > /dev/null
		else
			echo "["${i}"/"${vlieshu}"] OK.">> $logfile 2>&1
			ls *"$vstrend".mp4 | xargs -I {} echo {}" Video Dwonload Done."
			ls *"$vstrend".mp4 | xargs -I {} mv {} "$vstrend".mp4
			echo $vhttpdir$vstrend".mp4">>list.txt
			#ls *"$vstrend".mp4 | xargs -I {} $vftpput "${vlocaldir}/{}"
			#echo "Video Moved to "$vdescdir
			break
		fi
	done
done

rm -rf $vgitdir/list.txt
cp -f $vlocaldir/list.txt $vgitdir

rm -rf $vgitdir/u.txt
touch $vgitdir/u.txt

cd $vgitdir
git add list.txt
git add u.txt
git commit -m "new" >> $logfile 2>&1
git push  origin master >> $logfile 2>&1

df -m / >> $logfile 2>&1

date >> $logfile 2>&1
echo "Script Stop!" >> $logfile 2>&1

rm -rf $vlocaldir/list.txt
rm -rf $vlocaldir/u.txt
rm -rf $vlocaldir/d.sh
