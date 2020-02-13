# Test environment for Nexus OSS with existing apt and yum hosted repos
### Steps to prepare the environment:
1. Install docker and docker-compose, for that follow these docs:
https://docs.docker.com/install/
https://docs.docker.com/install/
2. Restore the `*-backup.tar` files as docker volumes. Use the section below.
3. Run the environment using `docker-compose up -d`.
4. Check the running environment from browser `localhost:8081`. Use `user: admin` and `password: admin` as creds.
5. Use the scripts `debpush.sh` and `rpmpush.sh` to push test packages to the corresponding repo.
6. Use the scripts `attachToApthost.sh` and `attachToYumhost.sh` to attach to `apt` and `yum` containers in order to  configure new repos from within. 

## How do backup/restore work
**Goal:** generate a tar file on localhost's CWD by tarballing the data directory of Nexus. 
1. A sidecar container is used to execute the tar command, and output the tar file in the directory that is bounded with the localhost's CWD. 
2. A sidecar container is used to execute the untar command, and output the extracted files into the data directory in Nexus container.

## Backup docker volumes for nexus container
1. `docker run -itd -v nexus-data:/nexus-data --name nexus sonatype/nexus3`.
2. `docker run --rm --volumes-from nexus -v $PWD:/backup ubuntu tar cvf /backup/nexus-backup.tar /nexus-data`.

This outputs a `nexus-backup.tar` file in the working directory.
## Restore from backup
Assuming the `nexus-backup.tar` file exists and `nexus-data` is a docker volume:
* `docker run --rm --volumes-from testnexus_nexus_1 -v $PWD:/backup ubuntu bash -c "tar xvf /backup/nexus-backup.tar"`.

This extracts `nexus-backup.tar` into `/nexus-data` thus, the backed up data is copied into the volume `/nexus-data` as it's mounted on `/nexus-data`.

-------------------------------------------

## Backup docker volumes for debian container
1. `docker run -itd -v debian-data:/etc/apt --name temp debian bash`
2. `docker run --rm --volumes-from temp -v $PWD:/backup ubuntu tar cvf /backup/debian-backup.tar /etc/apt`

This outputs a `debian-backup.tar` file in the working directory.
## Restore from backup
Assuming the `debian-backup.tar` file exists and `debian-data` is a docker volume:
* `docker run --rm --volumes-from testnexus_apthost_1 -v $PWD:/backup ubuntu bash -c "cd /etc/apt && tar xvf /backup/debian-backup.tar --strip 1"`.

This extracts `debian-backup.tar` into `/etc/apt` thus, the backed up data is copied into the volume `debain-data` as it's mounted on `/etc/apt`.

-------------------------------------------

## Backup docker volumes for centos container
1. `docker run -itd -v centos-data:/etc/yum.repo.d --name temp centos bash`
2. `docker run --rm --volumes-from temp -v $PWD:/backup centos tar cvf /backup/centos-backup.tar /etc/yum.repos.d`

This outputs a `centos-backup.tar` file in the working directory.
## Restore from backup
Assuming the `centos-backup.tar` file exists and `centos-test` is a docker volume:
* `docker run --rm --volumes-from testnexus_yumhost_1 -v $PWD:/backup centos bash -c "cd /etc/yum.repos.d && tar xvf /backup/centos-backup.tar --strip 1"`.

This extracts `centos-backup.tar` into `/etc/yum.repos.d` thus, the backed up data is copied into the volume `centos-data` as it's mounted on `/etc/yum.repos.d`.

-------------------------------------------

#### Note 
* This document assumes you work directly from this repo after clonig it. If you moved the contents of this repo it to a different directory, change the container namings as well.
