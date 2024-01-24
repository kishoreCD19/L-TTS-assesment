const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const mysql = require('mysql');

const app = express();
const port = 3000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// MySQL database connection
const connection = mysql.createConnection({
    host: 'your_database_host',
    user: 'your_database_user',
    password: 'your_database_password',
    database: 'your_database_name',
});

connection.connect((err) => {
    if (err) {
        console.error('Error connecting to database:', err);
        return;
    }
    console.log('Connected to database');
});

// Endpoint to handle user registration
app.post('/register', (req, res) => {
    const { username, email, password, confirmPassword } = req.body;

    // Basic validation
    if (!username || !email || !password || password !== confirmPassword) {
        return res.status(400).send('Invalid registration data');
    }

    // Check if the username or email is already taken
    const checkDuplicateQuery = 'SELECT * FROM users WHERE username = ? OR email = ?';
    connection.query(checkDuplicateQuery, [username, email], (error, results) => {
        if (error) {
            console.error('Error checking duplicate:', error);
            return res.status(500).send('Internal Server Error');
        }

        if (results.length > 0) {
            return res.status(400).send('Username or email already taken');
        }

        // Store the user in the database
        const insertUserQuery = 'INSERT INTO users (username, email, password) VALUES (?, ?, ?)';
        connection.query(insertUserQuery, [username, email, password], (insertError) => {
            if (insertError) {
                console.error('Error inserting user:', insertError);
                return res.status(500).send('Internal Server Error');
            }

            res.status(200).send('Registration successful');
        });
    });
});

// Endpoint to handle user login
app.post('/login', (req, res) => {
    const { loginUsername, loginPassword } = req.body;

    // Check if the user exists in the database
    const checkLoginQuery = 'SELECT * FROM users WHERE username = ? AND password = ?';
    connection.query(checkLoginQuery, [loginUsername, loginPassword], (error, results) => {
        if (error) {
            console.error('Error checking login:', error);
            return res.status(500).send('Internal Server Error');
        }

        if (results.length > 0) {
            res.status(200).send('Login successful');
        } else {
            res.status(401).send('Invalid login credentials');
        }
    });
});

// Start the server
app.listen(port, () => {
    console.log(Server is running at http://localhost:${port});
})
