import 'dotenv/config'
import express from 'express';
import { PrismaClient } from '@prisma/client'

(async () => {

  const prisma = new PrismaClient();

  // Credits: https://stackoverflow.com/a/14032965/3231778
  async function exitHandler(options: any, exitCode: any) {
    if (options.cleanup) console.log('clean');
    if (exitCode || exitCode === 0) console.log(exitCode);
    await prisma.$disconnect()
    if (options.exit) process.exit();
  }
  // do something when app is closing
  process.on('exit', exitHandler.bind(null, { cleanup: true }));
  // catches ctrl+c event
  process.on('SIGINT', exitHandler.bind(null, { exit: true }));
  // catches "kill pid" (for example: nodemon restart)
  process.on('SIGUSR1', exitHandler.bind(null, { exit: true }));
  process.on('SIGUSR2', exitHandler.bind(null, { exit: true }));
  // catches uncaught exceptions
  process.on('uncaughtException', exitHandler.bind(null, { exit: true }));

  try {
    process.on("uncaughtException", function (err) {
      console.error(err);
    });

    process.on("unhandledRejection", (reason, promise) => {
      console.error(reason);
    });

    require('dotenv').config();

    const PORT = process.env.PORT;
    const app = express();
    const port = PORT ? Number(PORT) : 3000;

    app.get('/', (req, res) => {
      res.send('OK')
    })

    app.get('/health', (req, res) => {
      res.send('OK')
    })

    app.get('/prisma', async (req, res) => {
      const allUsers = await prisma.user.findMany()
      console.log(allUsers)
      res.send('OK')
    })

    app.listen(port, () => {
      console.log(`Example app listening on port ${port}`)
    })
  } catch (e) {
    console.error(e);
    if (prisma) {
      await prisma.$disconnect()
    }
    process.exit(1)
  }
})();

