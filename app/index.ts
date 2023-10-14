import 'dotenv/config'
import express from 'express';

(async () => {
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

    app.listen(port, () => {
      console.log(`Example app listening on port ${port}`)
    })
  } catch (e) {
    console.error(e);
  }
})();

