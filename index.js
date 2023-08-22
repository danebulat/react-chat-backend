import 'dotenv/config';
import express from 'express';
import cors    from 'cors';
import path    from 'path';
import config  from './config.js';
import { fileURLToPath }  from 'url';

import authRouter         from './routes/auth.js';
import conversationRouter from './routes/conversations.js';
import messageRouter      from './routes/messages.js';
import userRouter         from './routes/users.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname  = path.dirname(__filename);

const app = express();
const router = express.Router();

app.use(cors());
app.use(express.json());

/* ---------------------------------------- */
/* Public directory                         */
/* ---------------------------------------- */

router.use(express.static(
  path.resolve(path.join(__dirname, `/${config.builddir}`)))
);

/* ---------------------------------------- */
/* Pass router to subdir                    */
/* ---------------------------------------- */

app.use('/api', authRouter);
app.use('/api/users', userRouter);
app.use('/api/conversations', conversationRouter);
app.use('/api/messages', messageRouter);

//TODO: check router is not serving static files
app.use(config.subdir, router);

/* ---------------------------------------- */
/* Error handler middleware                 */
/* ---------------------------------------- */

app.use((err, _req, res, _next) => {
  const statusCode = err.statusCode || 500;
  console.error(err.message, err.stack);
  res.status(statusCode).json({ message: err.message });
});

/* -------------------------------------------------- */
/* Catch-all route to index.html                      */
/* -------------------------------------------------- */

router.get('/*', (_req, res) => {
  res.sendFile(path.resolve(__dirname + `/${config.builddir}/index.html`));
});

/* ---------------------------------------- */
/* Listen                                   */
/* ---------------------------------------- */

console.log('builddir: ' + path.join(__dirname, `/${config.builddir}`));
console.log(`subdir: ${config.subdir}`);

app.listen(config.port, () => {
  console.log(`Server listening on port ${config.port}`);
});
