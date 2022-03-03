date;

printf "\n---BACKING UP GITLAB---\n";

printf "\nCreate the GitLab backup\n";
docker exec -t <gitlab_container_name> gitlab-backup create BACKUP=dump SKIP=tar GITLAB_BACKUP_MAX_CONCURRENCY=8;

printf "\ncd to /home/ubuntu\n";
cd /home/ubuntu;

printf "\nCreate source/gitlab.\n";
mkdir backups_example/source/gitlab;

printf "\nCopy volume binded GitLab 'backups' folder to the 'source' folder that is mounted to duplicati container.\n";
cp -r gitlab/data/backups/* backups_example/source/gitlab;

printf "\nSend GitLab data to S3 using duplicati.\n";
docker exec -t duplicati mono /app/duplicati/Duplicati.CommandLine.exe \
backup \
"s3s://backups/gitlab?s3-server-name=s3.amazonaws.com&s3-location-constraint=eu-west-1&s3-storage-class=&s3-client=aws&auth-username=$DUPLICATI_AWS_ACCESS_KEY_ID&auth-password=$DUPLICATI_AWS_SECRET_ACCESS_KEY" \
/source/gitlab/ \
--backup-name=gitlab \
--dbpath=/config/UYEFHZFZZC.sqlite \
--encryption-module=aes \
--compression-module=zip \
--dblock-size=150MB \
--passphrase="$DUPLICATI_PASSPHRASE" \
--retention-policy="1W:1D,4W:1W,12M:1M" \
--disable-module=console-password-input;

