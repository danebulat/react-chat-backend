import express    from 'express';
import { verify } from './auth.js';
import * as db    from '../services/db.js';
import { escape } from 'mysql2';

const router = express.Router();

/* -------------------------------------------------- */
/* GET /   get all conversations                      */
/* -------------------------------------------------- */

router.get('/', async (req, res) => {
  try {
    const sql = 'SELECT * FROM conversations';
    const rows = await db.query(sql);
    res.status(200).json(rows);
  }
  catch (err) {
    console.log(err);
    res.status(500).json(err);
  }
});

/* -------------------------------------------------- */
/* POST /   create new conversation                   */
/* -------------------------------------------------- */

router.post('/', verify, async (req, res) => {

  //only admins allowed to create new conversations
  if (!req.user.isAdmin)
    return res.status(403).json({ msg: 'Not authorized' });

  try {
    const title = req.body.title;
    const sql = `INSERT INTO conversations (title) VALUES (${escape(title)})`;
    const result = await db.query(sql);
    const conversation = await db.getConversation(result.insertId);
    res.status(200).json(conversation);
  } 
  catch (err) {
    console.error(err);
    res.status(500).json(err);
  }
});

/* -------------------------------------------------- */
/* GET /:userId   get a user's conversations          */
/* -------------------------------------------------- */

router.get('/:userId', verify, async (req, res) => {
  console.log('/api/conversations/:userId');
  try {
    const userId = req.params.userId;
    const sql = `
      SELECT conversations.* FROM conversations 
      JOIN users_conversations ON conversations.id = users_conversations.conversation_id
      WHERE users_conversations.user_id = ${userId}`;

    const rows = await db.query(sql);
    res.status(200).json(rows);
  }
  catch (err) {
    console.log(err);
    res.status(500).json(err);
  }
});

/* exports */
export default router;
export {
  router,
};
