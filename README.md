# Test environment for Nexus OSS with existing apt and yum hosted repos
### Steps to prepare the environment:
1. Install docker and docker-compose, for that follow these docs:
https://docs.docker.com/install/
https://docs.docker.com/install/
2. Restore the `*-backup.tar` files as docker volumes from this README file in the section below.
3. Run the environment using `docker-compose up -d`.
4. Check the running environment from browser `localhost:8081`. Use `user: admin` and `password: admin` as creds.
5. Use the scripts `debpush.sh` and `rpmpush.sh` to push test packages to the corresponding repo.
6. Use the scripts `attachToApthost.sh` and `attachToYumhost.sh` to attach to `apt` and `yum` containers in order to  configure new repos from within. 

## Backup docker volumes for nexus container
1. `docker run -itd -v nexus-data:/nexus-data --name nexus sonatype/nexus3`.
2. `docker run --rm --volumes-from nexus -v $PWD:/backup ubuntu tar cvf /backup/nexus-backup.tar /nexus-data`.
This outputs a `backup.tar` file in the working directory.
## Restore from backup
Assuming the `backup.tar` file exists and `nexus-data` is a docker volume:
`docker run --rm --volumes-from testnexus_nexus_1 -v $PWD:/backup ubuntu bash -c "tar xvf /backup/nexus-backup.tar"`.
This extracts `backup.tar` into `/nexus-data` thus, the backed up data is copied into the volume `/nexus-data` as it's mounted on `/nexus-data`.

-------------------------------------------

## Backup docker volumes for debian container
1. `docker run -itd -v debian-data:/etc/apt --name temp bash`
2. `docker run --rm --volumes-from temp -v $PWD:/backup ubuntu tar cvf /backup/debian-backup.tar /etc/apt`
This outputs a `backup.tar` file in the working directory.
## Restore from backup
Assuming the `backup.tar` file exists and `debian-data` is a docker volume:
`docker run --rm --volumes-from testnexus_apthost_1 -v $PWD:/backup ubuntu bash -c "cd /etc/apt && tar xvf /backup/debian-backup.tar --strip 1"`.
This extracts `backup.tar` into `/etc/apt` thus, the backed up data is copied into the volume `debain-data` as it's mounted on `/etc/apt`.

## Backup docker volumes for centos container
1. `docker run -itd -v centos-data:/etc/yum.repo.d --name temp centos bash`
2. `docker run --rm --volumes-from temp -v $PWD:/backup centos tar cvf /backup/centos-backup.tar /etc/yum.repos.d`
This outputs a `backup.tar` file in the working directory.
## Restore from backup
Assuming the `backup.tar` file exists and `centos-test` is a docker volume:
`docker run --rm --volumes-from testnexus_yumhost_1 -v $PWD:/backup centos bash -c "cd /etc/yum.repos.d && tar xvf /backup/centos-backup.tar --strip 1"`.
This extracts `backup.tar` into `/etc/yum.repos.d` thus, the backed up data is copied into the volume `centos-data` as it's mounted on `/etc/yum.repos.d`.

---------------------------------------------------------------------------------
