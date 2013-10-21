HOST=$1; shift
REMOTE=$1
LOG=/tmp/sync_jenkins
TMP=/tmp/jenkins_sync

if [ ! -d $TMP ];then
  mkdir $TMP
else
  echo "Found $TMP"
fi

JOBS="packstack-rdo-havana-rhel-nova-production packstack-rdo-havana-neutron-rhel-production packstack-rdo-havana-neutron-f19-production packstack-rdo-havana-neutron-centos-production packstack-rdo-havana-multinode-neutron-rhel-production smokestack-rdo-havana-aio-neutron-rhel smokestack-rdo-havana-aio-rhel packstack-rdo-havana-rhel-nova-production packstack-rdo-havana-neutron-rhel-production packstack-rdo-havana-neutron-f19-production packstack-rdo-havana-neutron-centos-production packstack-rdo-havana-multinode-neutron-rhel-production smokestack-rdo-havana-aio-neutron-rhel smokestack-rdo-havana-aio-rhel"
#JOBS="packstack-rdo-havana-rhel-nova-production"

echo "**** START RDO JENKINS SYNC ****"  >>  $LOG
for job in `echo $JOBS`; do
  rsync -auvz -L -e "ssh -i /home/whayutin/.ssh/JENKINS/id_rsa" root@$HOST:/var/lib/jenkins/jobs/$job $TMP/ &>> $LOG
done
echo "**** END LOCAL SYNC ****"  >> $LOG
echo "**** BEGIN REMOTE SYNC ****"  >> $LOG
for job in `echo $JOBS`; do
  rsync -auvz -L -e "ssh -i /home/whayutin/.ssh/JENKINS/id_rsa" $TMP/$job 524ee18d4382ec1886000084@$REMOTE:~/app-root/data/jobs/ &>> $LOG
done
echo "**** END REMOTE SYNC ****"  >> $LOG

#restart
curl -X POST --show-error https://admin:0c3b58082e6426a6583b64203bfe47c2@prod-rdojenkins.rhcloud.com/restart &>> $LOG

