# AWS GitHub Self-Hosted Runners Migrations

Deploying GitHub self-hosted runners to apply migrations to AWS RDS for MySQL.

Architecture overview:

<img src=".assets/aws-gh-runner.png" />


## Setup

Create the `.auto.tfvars` from the template:

```sh
cp samples/sample.tfvars .auto.tfvars
```

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

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
