# AWS GitHub Self-Hosted Runners Migrations

Deploying GitHub self-hosted runners to apply migrations to AWS RDS for MySQL.

Shadow database:

https://www.prisma.io/docs/concepts/components/prisma-migrate/shadow-database



> Whenever you update your Prisma schema, you will have to update your database schema using either `prisma migrate dev` or `prisma db push`. This will keep your database schema in sync with your Prisma schema. The commands will also regenerate Prisma Client.


https://www.prisma.io/docs/guides/deployment/deploy-database-changes-with-prisma-migrate


https://docs.github.com/en/actions/hosting-your-own-runners
https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners

```sh
# This calls generate under the hood
npx prisma migrate dev --name init
```

https://www.prisma.io/docs/getting-started/quickstart


export RUNNER_ALLOW_RUNASROOT="1"

https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/configuring-the-self-hosted-runner-application-as-a-service

https://github.com/nodesource/distributions

```sh
docker run -d \
    -e MYSQL_DATABASE=mysqldb \
    -e MYSQL_ROOT_PASSWORD=cxvxc2389vcxzv234r \
    -p 3306:3306 \
    --name mysql-prisma-local \
    mysql:8.0
```

```sh
aws ssm start-session \
    --target instance-id
```
