require('dotenv').config();

const express = require('express');
const app = express();
const jwt = require('jsonwebtoken');
const mysql = require('mysql');
const XLSX = require('xlsx');
const multer = require('multer');
const upload = multer({ dest: 'uploads/' }); // Папка для сохранения загруженных файлов

app.set('appName', 'AdmissionCommittee'); // Имя приложения в Express

app.use(express.json());

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*'); // Разрешаю запросы от всех источников (*)
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  next();
});

const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "M2$xbu7g",
  database: "AdmissionCommittee",
});

connection.connect((err) => {
  if (err) {
    console.error('Ошибка подключения к базе данных:', err);
    throw err;
  }
  console.log('Успешное подключение к базе данных');
});

app.post('/token', (req, res) => {
  const refreshToken = req.body.token;
  if (refreshToken == null) return res.sendStatus(401);
  
  connection.query('SELECT * FROM User_tokens WHERE refresh_token = ?', refreshToken, (err, results) => {
    if (err) {
      console.error('Ошибка при поиске refresh токена:', err);
      return res.sendStatus(500);
    }
    if (results.length === 0) return res.sendStatus(403);
    
    jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET, (err, user) => {
      if (err) return res.sendStatus(403);
      const accessToken = generateAccessToken({ name: user.name });
      res.json({ accessToken: accessToken });
    });
  });
});

app.post('/login', (req, res) => {
  const { email, password } = req.body;
   
  // Проверка в таблице Abiturient
  connection.query('SELECT * FROM Abiturient WHERE Login = ? AND Password = ?', [email, password], (errAbiturient, resultsAbiturient) => {
    if (errAbiturient) {
      console.error('Ошибка при поиске абитуриента:', errAbiturient);
      return res.status(500).json({ message: 'Ошибка сервера' });
    }
    
    // Если абитуриент найден
    if (resultsAbiturient.length > 0) {
      const abiturient = {
        id: resultsAbiturient[0].ID_Abiturient, 
        email: email,
        password: password,
        postID: resultsAbiturient[0].Post_ID,
        surname: resultsAbiturient[0].Surname,
        firstName: resultsAbiturient[0].First_Name,
        middleName: resultsAbiturient[0].Middle_Name,
        dateOfBirth: resultsAbiturient[0].Date_of_Birth
      };

      const accessToken = generateAccessToken(abiturient);
      const refreshToken = jwt.sign(abiturient, process.env.REFRESH_TOKEN_SECRET);

      connection.query('UPDATE User_tokens SET refresh_token = ? WHERE Abiturient_ID = ?', [refreshToken, abiturient.id], (errUpdateTokenAbiturient) => {
        if (errUpdateTokenAbiturient) {
          console.error('Ошибка при обновлении refresh токена абитуриента:', errUpdateTokenAbiturient);
          return res.status(500).json({ message: 'Ошибка сервера' });
        }
        res.json({
          id: abiturient.id,
          accessToken: accessToken,
          refreshToken: refreshToken,
          postID: abiturient.postID,
          lastName: abiturient.surname, // 
          firstName: abiturient.firstName,
          middleName: abiturient.middleName,
          birthdate: abiturient.dateOfBirth,
        });
      });
    } else {
      // Если абитуриент не найден, проверяем в таблице Administrator
      connection.query('SELECT * FROM Administrator WHERE Login = ? AND Password = ?', [email, password], (errAdmin, resultsAdmin) => {
        if (errAdmin) {
          console.error('Ошибка при поиске администратора:', errAdmin);
          return res.status(500).json({ message: 'Ошибка сервера' });
        }
        
        // Если администратор найден
        if (resultsAdmin.length > 0) {
          const admin = {
            id: resultsAdmin[0].ID_Administrator,
            email: email,
            password: password,
            postID: resultsAdmin[0].Post_ID
          };

          const accessTokenAdmin = generateAccessToken(admin);
          const refreshTokenAdmin = jwt.sign(admin, process.env.REFRESH_TOKEN_SECRET);

          connection.query('UPDATE User_tokens SET refresh_token = ? WHERE Admin_ID = ?', [refreshTokenAdmin, admin.id], (errUpdateTokenAdmin) => {
            if (errUpdateTokenAdmin) {
              console.error('Ошибка при обновлении refresh токена администратора:', errUpdateTokenAdmin);
              return res.status(500).json({ message: 'Ошибка сервера' });
            }
            res.json({ id: admin.id, accessToken: accessTokenAdmin, refreshToken: refreshTokenAdmin, postID: admin.postID });
          });
        } else {
          // Если ни абитуриент, ни администратор не найдены
          return res.status(401).json({ message: 'Неверный логин или пароль' });
        }
      });
    }
  });
});

function generateAccessToken(user) { 
  const { id, email, Post_ID } = user;
  return jwt.sign({ id, email, Post_ID }, process.env.ACCESS_TOKEN_SECRET, { 
    expiresIn: '1m',
    issuer: 'AdmissionCommitteeApp',
    subject: 'user_authentication'
  });
}

app.get('/user/:id', (req, res) => {
  const userId = req.params.id;

  const tableName = 'Abiturient'; // 

  const sql = `
    SELECT 
      Surname, 
      First_Name, 
      Middle_Name, 
      Date_of_Birth, 
      Login, 
      Password 
    FROM ${tableName} 
    WHERE ID_Abiturient = ?`; //  

  connection.query(sql, userId, (err, results) => {
    if (err) {
      console.error('Ошибка при запросе пользователя из базы данных:', err);
      return res.status(500).json({ error: 'Ошибка при запросе пользователя' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Пользователь не найден' });
    }

    const user = results[0];
    res.json(user);
  });
});

app.get('/administrator/:id', (req, res) => {
  const adminId = req.params.id;

  const tableName = 'Administrator'; 

  const sql = `
    SELECT 
      Surname, 
      First_Name, 
      Middle_Name, 
      Date_of_Birth, 
      Login, 
      Password 
    FROM ${tableName} 
    WHERE ID_Administrator = ?`; 

  connection.query(sql, adminId, (err, results) => {
    if (err) {
      console.error('Ошибка при запросе администратора из базы данных:', err);
      return res.status(500).json({ error: 'Ошибка при запросе администратора' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Администратор не найден' });
    }

    const administrator = results[0];
    res.json(administrator);
  });
});

function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  if (token == null) return res.sendStatus(401);
  jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
}


const bcrypt = require('bcrypt');
const saltRounds = 10;

app.post('/register', async (req, res) => {
  const { email, password, surname, firstName, middleName, dateOfBirth, postId } = req.body;

  try {
    const salt = await bcrypt.genSalt(saltRounds);
    const hashedPassword = await bcrypt.hash(password, salt);    

    let result;
    let tableName;
    let additionalFields = '';
    let fieldValues = [];

    if (parseInt(postId, 10) === 1 || parseInt(postId, 10) === 2) {
      tableName = 'Administrator';
      additionalFields = ', Surname, First_Name, Middle_Name, Date_of_Birth, Post_ID';
      fieldValues = [surname, firstName, middleName, dateOfBirth, postId];
    } else if (parseInt(postId, 10) === 3) {
      tableName = 'Abiturient';
      additionalFields = ', Surname, First_Name, Middle_Name, Date_of_Birth, Post_ID';
      fieldValues = [surname, firstName, middleName, dateOfBirth, postId];
    } else {
      return res.status(400).json({ error: 'Неверная роль' });
    }

    const placeholders = Array.from({ length: fieldValues.length + 2 }, () => '?').join(', ');

    result = await connection.query(
    `INSERT INTO ${tableName} (Login, Password${additionalFields}) VALUES (?, ?${', ?'.repeat(fieldValues.length - 1)}, ?)`,
    [email, hashedPassword, ...fieldValues]
  );

    console.log(`Пользователь успешно зарегистрирован в таблице ${tableName}`);
    res.status(201).json({ message: `Пользователь успешно зарегистрирован в таблице ${tableName}` });
  } catch (error) {
    console.error('Ошибка при регистрации пользователя:', error);
    res.status(500).json({ error: 'Ошибка при регистрации пользователя' });
  }
});

app.post('/import-administrator', upload.single('file'), async (req, res) => {
  const file = req.file;

  if (!file) {
    return res.status(400).send('Файл не был загружен');
  }

  const workbook = XLSX.readFile(file.path);
  const sheetName = workbook.SheetNames[0]; 
  const worksheet = workbook.Sheets[sheetName];
  const excelData = XLSX.utils.sheet_to_json(worksheet);

  const promises = excelData.map(data => {
    return new Promise(async (resolve, reject) => {
      const { Surname, First_Name, Middle_Name, Date_of_Birth, Login, Password, Post_ID} = data;

      try {
        // Хэширование пароля
        const salt = await bcrypt.genSalt(saltRounds);
        const hashedPassword = await bcrypt.hash(Password, salt);

        // Выполнение запроса к базе данных с хэшированным паролем
        const sql = 'INSERT INTO Administrator (Surname, First_Name, Middle_Name, Date_of_Birth, Login, Password, Post_ID) VALUES (?, ?, ?, ?, ?, ?, ?)';
        connection.query(sql, [Surname, First_Name, Middle_Name, Date_of_Birth, Login, hashedPassword, Post_ID], (error, results) => {
          if (error) {
            console.error('Ошибка запроса: ' + error.message);
            reject(error);
            return;
          }
          console.log('Запись успешно добавлена');
          resolve(results);
        });
      } catch (error) {
        console.error('Ошибка при хэшировании пароля:', error);
        reject(error);
      }
    });
  });

  Promise.all(promises)
    .then(() => {
      res.status(200).json({ message: 'Все записи успешно добавлены' });
    })
    .catch((error) => {
      res.status(500).json({ error: 'Произошла ошибка при добавлении записей' });
    });
});

app.put('/updatePasswordAbiturient/:userId', async (req, res) => {
  try {
    const abiturientId = req.params.userId;

    // Извлекаем данные из запроса
    const { password } = req.body;

    // Хэшируем новый пароль
    const salt = await bcrypt.genSalt(saltRounds);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Подготавливаем SQL-запрос для обновления записи в таблице Abiturient
    const query = `
      UPDATE Abiturient
      SET Password = ?
      WHERE ID_Abiturient = ?`;

    connection.query(query, [hashedPassword, abiturientId], (err, results) => {
      if (err) {
        console.error('Ошибка при обновлении данных абитуриента в базе данных:', err);
        return res.status(500).json({ error: 'Ошибка при обновлении данных абитуриента' });
      }

      res.json({ message: 'Данные абитуриента успешно обновлены' });
    });
  } catch (error) {
    console.error('Произошла ошибка:', error);
    res.status(500).json({ error: 'Произошла ошибка на сервере' });
  }
});

app.put('/updatePasswordAdministrator/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;

    // Извлекаем данные из запроса
    const { password } = req.body;

    // Хэшируем новый пароль
    const salt = await bcrypt.genSalt(saltRounds);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Подготавливаем SQL-запрос для обновления записи в таблице Administrator
    const query = `
      UPDATE Administrator
      SET Password = ?
      WHERE ID_Administrator = ?`;

    connection.query(query, [hashedPassword, userId], (err, results) => {
      if (err) {
        console.error('Ошибка при обновлении пароля администратора в базе данных:', err);
        return res.status(500).json({ error: 'Ошибка при обновлении пароля администратора' });
      }

      res.json({ message: 'Пароль администратора успешно обновлен' });
    });
  } catch (error) {
    console.error('Произошла ошибка:', error);
    res.status(500).json({ error: 'Произошла ошибка на сервере' });
  }
});

app.get('/current-user', authenticateToken, (req, res) => {
  res.json({ username: req.user.name });
});


app.listen(4000);