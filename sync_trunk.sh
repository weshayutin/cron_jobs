HOST=$1
LOG=/tmp/rsync_$HOST
echo "**** START LOCAL SYNC ****"  >>  $LOG
rsync -auvz -L -e "ssh -i /home/whayutin/.ssh/FEDORA_PEOPLE/id_fedora" root@$HOST:/var/www/html/repos/openstack-trunk/snapshots/latest /home/whayutin/FEDORA_PEOPLE/ &>> $LOG
echo "**** END LOCAL SYNC ****"  >> $LOG

echo "**** START REMOTE SYNC ****"  >> $LOG
rsync -auvz -L -e "ssh -i /home/whayutin/.ssh/FEDORA_PEOPLE/id_fedora" whayutin@fedorapeople.org:~whayutin/public_html/ &>> $LOG
echo "**** END REMOTE SYNC ****"  >> $LOG
