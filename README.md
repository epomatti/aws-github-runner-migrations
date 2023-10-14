# AWS GitHub Self-Hosted Runners Migrations

Deploying GitHub self-hosted runners to apply migrations to AWS RDS for MySQL.

Shadow database:

https://www.prisma.io/docs/concepts/components/prisma-migrate/shadow-database



```
prisma generate
```

```
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


