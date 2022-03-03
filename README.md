# Backups and Restore

Let's say you have a single GitLab container (see [gitlab compose file](terraform/files/docker-compose.yml.gitlab) working on your server. Let's also say that you'd like take daily backups, so that you're not dead if a disaster struck.

You further want to automate the deployment of the container, so that if a disaster hit, you'd have your instance, with your data of course, up an running in about 15 minutes (GitLab is quite heavy, it takes a while for it to come alive). 

## Backups

1. Install Duplicati - [duplicati compose file](terraform/files/docker-compose.yml.duplicati).
2. Fill and copy `backup.cron` to `/etc/cron.daily` so that the backups will run once a day.

## Restore

1. Install Terraform and Ansible.
2. Go to the terraform folder.
3. Fill in the blanks in `main.tf`, `playbook.yml`, and `files/gitlab.conf`.
4. `terraform init` & `terraform apply`.

The scripts will take care of the rest.

## TO-DO

- Better documentation.
- Create a security group inside the terraform script instead of supplying an id.
- Maybe integrate Hashicorp Vault.

