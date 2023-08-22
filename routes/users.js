import express from 'express';
import { verify } from './auth.js';
import * as db from '../services/db.js';

const router = express.Router();

/* ---------------------------------------- */
/* DELETE /api/users/:id                    */
/* ---------------------------------------- */

router.delete('/:userId', verify, async (req, res, next) => {
  if (Number(req.user.id) === Number(req.params.userId) || req.user.isAdmin) {

    try {
      const sql = `DELETE FROM users WHERE id = ${req.user.id}`;
      await db.query(sql);
      res.status(200).json('User has been deleted');
    }
    catch (err) {
      console.error(err);
      next(err);
    }
  }
  else {
    res.status(403).json('You are not allowed to delete this user');
  }
});

/* ---------------------------------------- */
/* GET /api/users                           */
/* ---------------------------------------- */

router.get('/', async (_req, res, next) => {
  try {
    const sql = 'SELECT username, created_at FROM users';
    const rows = await db.query(sql);
    const data = rows === [] ? [] : rows;

    const users = data.map(user => {
      return {
        username: user.username,
        createdAt: user.created_at,
      }
    }); 

    res.status(200).json(users);
  }
  catch (err) {
    console.log(`Error while getting users ${err.message}`);
    next(err);
  }
});

/* exports */
export default router;
export {
  router,
};
