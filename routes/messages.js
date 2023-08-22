import express from 'express';
import * as db from '../services/db.js';
import { verify } from './auth.js';

const router = express.Router();

/* -------------------------------------------------- */
/* POST /   create new message                        */
/* -------------------------------------------------- */

router.post('/', verify, async (req, res) => {
  try {
    const sql = `INSERT INTO messages (user_id, conversation_id, text)
      VALUES (${req.body.userId}, 
              ${req.body.conversationId}, 
             "${req.body.text}")`;

    const result = await db.query(sql);
    const message = await db.getMessage(result.insertId);
    return res.status(200).json(message);
  }
  catch (err) {
    console.error(err);
    res.status(500).json(err);
  }
});

/* -------------------------------------------------- */
/* GET /   get messages in a conversation id          */
/* -------------------------------------------------- */

router.get('/:conversationId', async (req, res) => {
  try {
    const conversationId = req.params.conversationId;
    const sql = `SELECT * FROM messages 
      WHERE conversation_id = ${conversationId}`;

    const rows = await db.query(sql);
    res.status(200).json(rows);
  }
  catch (err) {
    console.error(err);
    res.status(500).json(err);
  }
});

/* exports */
export default router;
export {
  router,
};

