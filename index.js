const express = require('express');
var nodemailer = require('nodemailer');
const bodyParser = require('body-parser');
const fs = require('fs');

const XLSX = require('xlsx');
const multer = require('multer');
const upload = multer({ dest: 'uploads/' }); // Папка для сохранения загруженных файлов
const cors = require('cors');
const { createPool } = require('mysql');
const { exec } = require('child_process'); 

const app = express();
const port = 3001;
app.use(cors()); // Разрешаем кросс-доменные запросы
app.use(bodyParser.json());

// Подключений к базе данных
const pool = createPool({
  host: "localhost",
  user: "root",
  password: "M2$xbu7g",
  database: "AdmissionCommittee",
});

app.use(express.json());
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  next();
});

app.post('/createBackup', (req, res) => {
  const backupFileName = 'backup.sql';
  const backupQuery = '"D:\\Program Files\\MySQL\\MySQL Server 8.0\\bin\\mysqldump.exe" -u root -pM2$xbu7g AdmissionCommittee > ' + backupFileName;

  exec(backupQuery, (error, stdout, stderr) => {
      if (error) {
          console.error(`Ошибка создания бэкапа: ${stderr}`);
          res.status(500).send({ error: 'Произошла ошибка при создании резервной копии.' });
      } else {
          console.log(`Бэкап успешно создан: ${backupFileName}`);
          res.status(200).json({ message: 'Бэкап успешно создан' });
        }
  });
});

// POST-маршрут для отправки электронного письма
app.post('/sendEmail', async (req, res) => {
  const { email, message } = req.body;

  // Настройки транспорта Nodemailer
  const transporter = nodemailer.createTransport({
      host: 'smtp.mail.ru',
      port: 465,
      secure: true,
      auth: {
          user: 'vfznd@mail.ru',
          pass: 'a4FcenM9TGGpPazzpFH1',
      },
  });

  // Параметры электронного письма
  const mailOptions = {
      from: '"Электронная приемная комиссия РЭУ" <vfznd@mail.ru>',
      to: email,
      subject: 'Изменен статус заявки',
      text: message,
  };

  try {
      // Отправка электронного письма
      const info = await transporter.sendMail(mailOptions);
      console.log(`Уведомление отправлено на почту ${email}: ${info.response}`);
      res.json({ success: true, message: 'Email успешно отправлен' });
  } catch (error) {
      console.error('Ошибка при отправке уведомления на почту:', error);
      res.status(500).json({ success: false, message: 'Произошла ошибка при отправке Email' });
  }
});
// Программы таблица
app.get('/Programs', async (req, res) => {
  try {
    const sql = `
      SELECT
        Programs.ID_Program,
        Education_Form.ID_Education_Form,
        Education_Form.Form_Name AS Education_Form_Name,
        Class.ID_Class,
        Class.Class_Name,
        Specialization.ID_Specialization,
        Specialization.Specialty_Code,
        Specialization.Specialty_Name,
        Specialization.Qualification_Name,
        Specialization.Description,
        Specialization.Training_Duration,
        Specialization.Direction_ID
      FROM
        Programs
      JOIN
        Education_Form ON Programs.Education_Form_ID = Education_Form.ID_Education_Form
      JOIN
        Class ON Programs.Class_ID = Class.ID_Class
      JOIN
        Specialization ON Programs.Specialization_ID = Specialization.ID_Specialization
    `;

    pool.query(sql, (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }
      res.status(200).json(results); // Отправляем данные в формате JSON
    });
  } catch (error) {
    console.error('Ошибка при получении программы:', error);
    res.status(500).send('Ошибка сервера');
  }
});

app.get('/AboutPrograms', async (req, res) => {
  try {
    const programId = req.query.id; //  значение параметра id из запроса
    const sql = `
      SELECT
        Programs.ID_Program,
        Programs.Photo_URL,
        Education_Form.ID_Education_Form,
        Education_Form.Form_Name,
        Class.ID_Class,
        Class.Class_Name,
        Specialization.ID_Specialization,
        Specialization.Specialty_Code,
        Specialization.Specialty_Name,
        Specialization.Qualification_Name,
        Specialization.Description,
        Specialization.Training_Duration,
        Specialization.Direction_ID
      FROM
        Programs
      JOIN
        Education_Form ON Programs.Education_Form_ID = Education_Form.ID_Education_Form
      JOIN
        Class ON Programs.Class_ID = Class.ID_Class
      JOIN
        Specialization ON Programs.Specialization_ID = Specialization.ID_Specialization
      WHERE
        Programs.ID_Program = ?; -- Фильтруем по ID_Program
    `;

    pool.query(sql, [programId], (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }

      if (results.length === 0) {
        // Если не найдено соответствий, возвращаем 404 Not Found
        res.status(404).send('Программа не найдена');
        return;
      }

      res.status(200).json(results[0]); // Отправляем данные в формате JSON (берем первый элемент, так как ожидаем только одну запись)
    });
  } catch (error) {
    console.error('Ошибка при получении программы:', error);
    res.status(500).send('Ошибка сервера');
  }
});

app.get('/totalUsers', async (req, res) => {
  try {
    const sql = 'SELECT COUNT(*) AS totalUsers FROM Administrator;    ';
    pool.query(sql, (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }
      res.status(200).json(results); // Отправляем данные в формате JSON
    });
  } catch (error) {
    console.error('Ошибка при получении  специальности:', error);
    res.status(500).send('Ошибка сервера');
  }
});
app.get('/totalAbiturient', (req, res) => {
    try {
      const sql = 'SELECT COUNT(*) AS totalAbiturients FROM Abiturient;      ';
      pool.query(sql, (error, results) => {
        if (error) {
          console.error('Ошибка запроса: ' + error.message);
          res.status(500).send('Ошибка сервера');
          return;
        }
        res.status(200).json(results); // Отправляем данные в формате JSON
      });
    } catch (error) {
      console.error('Ошибка при получении  специальности:', error);
      res.status(500).send('Ошибка сервера');
    }
});

app.get('/AllApplications', async (req, res) => {
  try {
      const programId = req.query.programId;
      const classId = req.query.classId;
      const educationFormId = req.query.educationFormId;
      console.log('Received request with parameters:', programId, classId, educationFormId);

      const sql = `
        SELECT
          Applications.Application_ID,
          Applications.Submission_Date,
          Applications.Average_Student_Grade,
          Abiturient.ID_Abiturient,
          Abiturient.Surname,
          Abiturient.First_Name,
          Abiturient.Middle_Name,
          Abiturient.Date_of_Birth,
          Abiturient.Login,
          Status.Status_Name,
          Programs.ID_Program,
          Programs.Education_Form_ID,
          Education_Form.Form_Name, 
          Programs.Class_ID,
          Class.Class_Name,  
          Specialization.ID_Specialization,
          Specialization.Specialty_Code,
          Specialization.Specialty_Name
        FROM
          Applications
        JOIN
          Abiturient ON Applications.Abiturient_ID = Abiturient.ID_Abiturient
        JOIN
          Status ON Applications.Status_ID = Status.ID_Status
        JOIN
          Programs ON Applications.Programs_ID = Programs.ID_Program
        JOIN
          Specialization ON Programs.Specialization_ID = Specialization.ID_Specialization
        JOIN
          Class ON Programs.Class_ID = Class.ID_Class
        JOIN
          Education_Form ON Programs.Education_Form_ID = Education_Form.ID_Education_Form
        WHERE
          Programs.ID_Program = ? AND
          Class.ID_Class = ? AND
          Education_Form.ID_Education_Form = ?
        LIMIT 0, 1000;
      `;

      pool.query(sql, [programId, classId, educationFormId], (error, results) => {
          if (error) {
              console.error('Ошибка запроса: ' + error.message);
              res.status(500).send('Ошибка сервера');
              return;
          }
          res.status(200).json(results); // Отправляем данные в формате JSON
      });
  } catch (error) {
      console.error('Ошибка при получении данных о заявках:', error);
      res.status(500).send('Ошибка сервера');
  }
});

app.put('/ChangeStatus/:applicationId', (req, res) => {
  const applicationId = req.params.applicationId;
  const newStatusId = req.body.newStatusId;

  const sql = `
      UPDATE Applications
      SET Status_ID = ?
      WHERE Application_ID = ?;
  `;

  pool.query(sql, [newStatusId, applicationId], (error, results) => {
      if (error) {
          console.error('Ошибка при обновлении статуса:', error);
          res.status(500).json({ error: 'Внутренняя ошибка сервера' });
          return;
      }
      res.json({ success: true });
  });
});


app.get('/ListOfPrograms', async (req, res) => {
  try {
    const sql = `
    SELECT
    Programs.ID_Program,
    Programs.Education_Form_ID,
    Education_Form.Form_Name,
    Programs.Class_ID,
    Class.Class_Name,
    Specialization.ID_Specialization,
    Specialization.Specialty_Code,
    Specialization.Specialty_Name
    FROM
    Programs
    JOIN
    Specialization ON Programs.Specialization_ID = Specialization.ID_Specialization
    JOIN
    Class ON Programs.Class_ID = Class.ID_Class
    JOIN
    Education_Form ON Programs.Education_Form_ID = Education_Form.ID_Education_Form
    LIMIT 0, 1000;
    `;

    pool.query(sql, (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }

      res.status(200).json(results); // Отправляем данные в формате JSON
    });
  } catch (error) {
    console.error('Ошибка при получении данных о заявках:', error);
    res.status(500).send('Ошибка сервера');
  }
});

// для получения данных о заявках
app.get('/applications', async (req, res) => {
  try {
    const sql = `
      SELECT
        Application_ID,
        Submission_Date,
        Average_Student_Grade,
        Abiturient_ID,
        Status_ID,
        Programs_ID
      FROM
        Applications
    `;

    pool.query(sql, (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }

      res.status(200).json(results); // Отправляем данные в формате JSON
    });
  } catch (error) {
    console.error('Ошибка при получении данных о заявках:', error);
    res.status(500).send('Ошибка сервера');
  }
});

app.post('/import-administrator', upload.single('file'), (req, res) => {
  const file = req.file;

  if (!file) {
    return res.status(400).send('Файл не был загружен');
  }

  const workbook = XLSX.readFile(file.path);
  const sheetName = workbook.SheetNames[0]; 
  const worksheet = workbook.Sheets[sheetName];
  const excelData = XLSX.utils.sheet_to_json(worksheet);

  const promises = excelData.map(data => {
    return new Promise((resolve, reject) => {
      const { Surname, First_Name, Middle_Name, Date_of_Birth, Login, Password, Post_ID} = data;
      const sql = 'INSERT INTO Administrator (Surname, First_Name, Middle_Name, Date_of_Birth, Login, Password, Post_ID) VALUES (?, ?, ?, ?, ?, ?, ?)';
      pool.query(sql, [Surname, First_Name, Middle_Name, Date_of_Birth, Login, Password, Post_ID], (error, results) => {
        if (error) {
          console.error('Ошибка запроса: ' + error.message);
          reject(error);
          return;
        }
        console.log('Запись успешно добавлена');
        resolve(results);
      });
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

app.get('/applications/statistics', async (req, res) => {
  try {
    const start = new Date(req.query.start);
    const end = new Date(req.query.end);
    
    const sql = `
      SELECT
        DATE(Submission_Date) as date,
        COUNT(*) as count
      FROM
        Applications
      WHERE
        Submission_Date >= ? AND Submission_Date <= ?
      GROUP BY
        date
    `;

    const results = await pool.query(sql, [start, end]);

    // Преобразуем данные в массив объектов перед отправкой
    const data = Array.isArray(results) ? results.map(entry => ({ date: entry.date, count: entry.count })) : [];

    res.json(data);
  } catch (error) {
    console.error('Ошибка при получении данных для статистики:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});

// Пример маршрута для получения статистики заявок за месяц
app.get('/applications/statistics/month', async (req, res) => {
  try {
    const sql = `
      SELECT
        DATE_FORMAT(Submission_Date, '%Y-%m') as month,
        COUNT(*) as count
      FROM
        Applications
      GROUP BY
        month
      ORDER BY
        month;
    `;

    pool.query(sql, (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }

      const data = results.map(entry => entry.count);

      res.status(200).json(data); // Отправляем данные в формате JSON
    });
  } catch (error) {
    console.error('Ошибка при получении статистики заявок за месяц:', error);
    res.status(500).send('Ошибка сервера');
  }
});

// Пример маршрута для получения статистики заявок за неделю
app.get('/applications/statistics/week', async (req, res) => {
  try {
    const sql = `
      SELECT
        YEARWEEK(Submission_Date) as week,
        COUNT(*) as count
      FROM
        Applications
      GROUP BY
        week
      ORDER BY
        week;
    `;

    pool.query(sql, (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }

      const data = results.map(entry => entry.count);

      res.status(200).json(data); // Отправляем данные в формате JSON
    });
  } catch (error) {
    console.error('Ошибка при получении статистики заявок за неделю:', error);
    res.status(500).send('Ошибка сервера');
  }
});

// Пример маршрута для получения статистики заявок за год
app.get('/applications/statistics/year', async (req, res) => {
  try {
    const sql = `
      SELECT
        YEAR(Submission_Date) as year,
        COUNT(*) as count
      FROM
        Applications
      GROUP BY
        year
      ORDER BY
        year;
    `;

    pool.query(sql, (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }

      const data = results.map(entry => entry.count);

      res.status(200).json(data); // Отправляем данные в формате JSON
    });
  } catch (error) {
    console.error('Ошибка при получении статистики заявок за год:', error);
    res.status(500).send('Ошибка сервера');
  }
});
// маршрут для получения данных о абитуриентах
app.get('/abiturients', async (req, res) => {
  try {
    const sql = `
      SELECT
        ID_Abiturient,
        Surname,
        First_Name,
        Middle_Name,
        Date_of_Birth,
        Login,
        Post_ID,
        Parent_ID
      FROM
        Abiturient
    `;

    pool.query(sql, (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }

      res.status(200).json(results); // Отправляем данные в формате JSON
    });
  } catch (error) {
    console.error('Ошибка при получении данных о абитуриентах:', error);
    res.status(500).send('Ошибка сервера');
  }
});


app.get('/Administrators', async (req, res) => {
  try {
    const sql = 'SELECT Administrator.*, Post.Post_name AS Post_name FROM Administrator INNER JOIN Post ON Administrator.Post_ID = Post.ID_Post;';
    pool.query(sql, (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }
      res.status(200).json(results); // Отправляем данные в формате JSON
    });
  } catch (error) {
    console.error('Ошибка при получении  данных об администраторах:', error);
    res.status(500).send('Ошибка сервера');
  }
});

app.delete('/DeleteAdministrator/:id', async (req, res) => {
  try {
    const administratorId = req.params.id;
    const sql = 'DELETE FROM Administrator WHERE ID_Administrator = ?';
    
    pool.query(sql, [administratorId], (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }
      res.status(200).json({ success: true, message: 'Администратор успешно удален.' });
    });
  } catch (error) {
    console.error('Ошибка при удалении администратора:', error);
    res.status(500).send('Ошибка сервера');
  }
});

app.put('/ChangeRole/:administratorId', async (req, res) => {
  const { administratorId } = req.params;
  const { newRoleId } = req.body;

  try {
    const sql = 'UPDATE Administrator SET Post_ID = ? WHERE ID_Administrator = ?';
    pool.query(sql, [newRoleId, administratorId], (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).json({ success: false, message: 'Ошибка сервера' });
        return;
      }
      res.status(200).json({ success: true, message: 'Роль успешно изменена' });
    });
  } catch (error) {
    console.error('Ошибка при изменении роли администратора:', error);
    res.status(500).json({ success: false, message: 'Ошибка сервера' });
  }
});

app.post('/AddAdministrator', async (req, res) => {
  try {
    const {
      Surname,
      First_Name,
      Middle_Name,
      Date_of_Birth,
      Login,
      Password,
      Post_ID
    } = req.body;

    const sql = `
      INSERT INTO Administrator (Surname, First_Name, Middle_Name, Date_of_Birth, Login, Password, Post_ID)
      VALUES (?, ?, ?, ?, ?, ?, ?);
    `;

    pool.query(sql, [Surname, First_Name, Middle_Name, Date_of_Birth, Login, Password, Post_ID], (error, results) => {
      if (error) {
        console.error('Ошибка запроса: ' + error.message);
        res.status(500).send('Ошибка сервера');
        return;
      }
      res.status(200).json({ success: true, message: 'Администратор успешно добавлен' });
    });
  } catch (error) {
    console.error('Ошибка при добавлении администратора:', error);
    res.status(500).send('Ошибка сервера');
  }
});
app.listen(port, () => {
  console.log('Сервер запущен на порту 3001');
});
