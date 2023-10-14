# AWS GitHub Self-Hosted Runners Migrations

Deploying GitHub self-hosted runners to apply migrations to AWS RDS for MySQL.

Shadow database:





> Whenever you update your Prisma schema, you will have to update your database schema using either `prisma migrate dev` or `prisma db push`. This will keep your database schema in sync with your Prisma schema. The commands will also regenerate Prisma Client.


https://www.prisma.io/docs/guides/deployment/deploy-database-changes-with-prisma-migrate


https://docs.github.com/en/actions/hosting-your-own-runners
https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners



https://www.prisma.io/docs/getting-started/quickstart

```sh
export RUNNER_ALLOW_RUNASROOT="1"
```

Reboot the instances to apply Kernel upgrades:

```sh
aws ec2 reboot-instances --instance-ids i-00000000000000000
```

```sh
aws ssm start-session --target instance-id
```

https://stackoverflow.com/questions/66733563/github-actions-runner-listener-exited-with-error-code-null

https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/configuring-the-self-hosted-runner-application-as-a-service

https://github.com/nodesource/distributions


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
