const express = require('express');
const { Pool } = require('pg');

const app = express();
app.use(express.json());

// Connect to PostgreSQL
const pool = new Pool({
  host: 'postgres18',           // Container name
  port: 5432,
  user: 'postgres',
  password: '1234',
  database: 'testdb'
});

// API endpoint: Get all users
app.get('/api/users', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM users');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// API endpoint: Add a new user
app.post('/api/users', async (req, res) => {
  try {
    const { fullname, username, email } = req.body;
    const result = await pool.query(
      'INSERT INTO users (fullname, username, email) VALUES ($1, $2, $3) RETURNING *',
      [fullname, username, email]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Start server
app.listen(3000, () => {
  console.log('Backend running on port 3000');
});
