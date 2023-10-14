# AWS GitHub Self-Hosted Runners Migrations

Deploying GitHub self-hosted runners to apply migrations to AWS RDS for MySQL.

Shadow database:

https://www.prisma.io/docs/concepts/components/prisma-migrate/shadow-database



> Whenever you update your Prisma schema, you will have to update your database schema using either `prisma migrate dev` or `prisma db push`. This will keep your database schema in sync with your Prisma schema. The commands will also regenerate Prisma Client.




```sh
# This calls generate under the hood
npx prisma migrate dev --name init
```

https://www.prisma.io/docs/getting-started/quickstart


```sh
docker run -d \
    -e MYSQL_DATABASE=mysqldb \
    -e MYSQL_ROOT_PASSWORD=cxvxc2389vcxzv234r \
    -p 3306:3306 \
    --name mysql-prisma-local \
    mysql:8.0
```


