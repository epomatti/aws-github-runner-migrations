# AWS GitHub Self-Hosted Runners Migrations

Deploying GitHub self-hosted runners to apply migrations to AWS RDS for MySQL.

Architecture overview:

<img src=".assets/aws-gh-runner.png" />

## Setup

Create the `.auto.tfvars` from the template:

```sh
cp samples/sample.tfvars .auto.tfvars
```

Set the EC2 user data file according to your requirements:

```terraform
# Available files: ubuntu-nodejs.sh, ubuntu-docker.sh
gh_runner_user_data = "ubuntu-nodejs.sh"
```

If you wish to create the application cluster as well, change the variable to `true`:

```terraform
create_application_cluster = true
```

Create the infrastructure:

```sh
terraform init
terraform apply
```

## Volume mount

> [!TIP]
> Device names from EC2 can be different from the actual device. Check the [documentation][7]

In this project, the EBS volume device name will be `/dev/sdf`, and the block device should be `/dev/nvme1n1`. More about this in the [naming documentation][7].

Login as `root` to list the drives:

```sh
fdisk -l
```

List the available disks with `lsblk`:

```sh
lsblk
```

To determine if the volume is formatted or not, use the `-f` option. If the `FSTYPE` column for the volume (e.g., `/dev/nvme1n1`) is empty, the volume is not formatted. If it shows a file system type (e.g., `ext4`, `xfs`), the volume is already formatted.

```sh
lsblk -f
```

To check it directly, use command below. If the output says `data`, the volume is not formatted. If the output shows a file system type (e.g., `ext4` or `xfs`), the volume is formatted.

```sh
file -s /dev/nvme1n1
```

Check the mount:

```sh
df -h
```

```sh
mount -a
```

Follow the [documentation][6] to format and mount the partition.


## GitHub Runner

Connect to the GitHub Runner host.

```sh
aws ssm start-session --target i-00000000000000000
```

If creating a new environment, verify that the `userdata` executed correctly and reboot to apply kernel upgrades:

> Should `reboot` automatically

```sh
cloud-init status
```

Switch to root:

```sh
sudo su -
```

Enter the `/opt` directory, this is where we'll install the runner agent:

```sh
cd /opt
```

Enable the runner scripts to run as root:

```sh
export RUNNER_ALLOW_RUNASROOT="1"
```

Access the repository Actions section and create a new runner.

Make sure you select the appropriate architecture, which should be `Linux` and `ARM64`.

Once done, stop the agent and install the runner agent [as a service][5]:

```sh
./svc.sh install
./svc.sh start
./svc.sh status
```

## GitHub Action

This repository contains examples of pipelines in the `.github/workflows` directory.

Check out the guidelines for [Prisma migrations deployment][2], or for your preferred migration tool.


## Local development

Start bu running a MySQL instance:

```sh
docker run -d \
    -e MYSQL_DATABASE=mysqldb \
    -e MYSQL_ROOT_PASSWORD=cxvxc2389vcxzv234r \
    -p 3306:3306 \
    --name mysql-prisma-local \
    mysql:8.0
```

Special privileges are required by Prisma to apply [shadow databases][1].

Enter the application directory:

```sh
cd app
```

Apply the migrations:

> Whenever you update your Prisma schema, you will have to update your database schema using either `prisma migrate dev` or `prisma db push`. This will keep your database 
schema in sync with your Prisma schema. The commands will also regenerate Prisma Client.

```sh
# This calls generate under the hood
npx prisma migrate dev --name init
```

Run the application locally:

```sh
npm run dev
```

Check if the schema and database connections are working:

```sh
curl localhost:3000/prisma
```

### Docker image

To verify that the Docker image, 

```sh
docker compose up
```

Add the `DATABASE_URL` environment variable:

```SH
export DATABASE_URL='mysql://root:cxvxc2389vcxzv234r@localhost:3306/mysqldb'
```

Deploy the migration:

```sh
npx prisma migrate deploy
```

[1]: https://www.prisma.io/docs/concepts/components/prisma-migrate/shadow-database
[2]: https://www.prisma.io/docs/guides/deployment/deploy-database-changes-with-prisma-migrate
[5]: https://docs.github.com/en/enterprise-cloud@latest/actions/hosting-your-own-runners/managing-self-hosted-runners/configuring-the-self-hosted-runner-application-as-a-service
[6]: https://docs.aws.amazon.com/ebs/latest/userguide/ebs-using-volumes.html
[7]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
