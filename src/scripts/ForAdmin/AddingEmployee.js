// Функция для обработки события отправки формы
function registerAdministrator() {
    // Получаем значения полей формы
    const surname = document.getElementById('surname').value;
    const firstName = document.getElementById('firstName').value;
    const middleName = document.getElementById('middleName').value;
    const dateOfBirth = document.getElementById('dateOfBirth').value;
    const login = document.getElementById('login').value;
    const password = document.getElementById('password').value;
    const password2 = document.getElementById('password2').value;
    const post = document.getElementById('post').value;

    // Проверка на совпадение паролей
    if (password !== password2) {
        alert('Пароли не совпадают');
        return;
    }

    // Проверка длины фамилии и имени
    if (surname.length < 2 || firstName.length < 2) {
        alert('Фамилия и имя должны содержать минимум 2 символа');
        return;
    }

    // Проверка максимальной длины фамилии и имени
    if (surname.length > 50 || firstName.length > 50) {
        alert('Фамилия и имя должны содержать не более 50 символов');
        return;
    }

    // Проверка формата логина
    if (login.length < 5 || login.indexOf('@') === -1 || login.indexOf('.') === -1) {
        alert('Логин должен содержать минимум 5 символов и иметь формат "user@example.com"');
        return;
    }

    // Проверка ограничений на пароль
    if (password.length < 5 || password.length > 20 || !(/[A-Z]/.test(password)) || !(/[a-z]/.test(password)) || !(/[0-9]/.test(password)) || !(/[^A-Za-z0-9]/.test(password))) {
        alert('Пароль должен содержать от 5 до 20 символов, включать хотя бы одну заглавную букву, одну строчную букву, одну цифру и один спецсимвол');
        return;
    }

    // Проверка на текущую или будущую дату рождения
    const currentDate = new Date();
    const selectedDate = new Date(dateOfBirth);
    if (selectedDate >= currentDate) {
        alert('Дата рождения должна быть меньше текущей даты');
        return;
    }

    // Проверка на возраст 18+
    const ageLimitDate = new Date(currentDate);
    ageLimitDate.setFullYear(ageLimitDate.getFullYear() - 18);
    if (selectedDate > ageLimitDate) {
        alert('Администратор должен быть старше 18 лет');
        return;
    }

    // Отправляем данные на сервер
    fetch('http://localhost:3001/AddAdministrator', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            Surname: surname,
            First_Name: firstName,
            Middle_Name: middleName,
            Date_of_Birth: dateOfBirth,
            Login: login,
            Password: password,
            Post_ID: parseInt(post), 
        }),
    })
        .then(response => {
            if (response.ok) {
                return response.json();
            } else {
                throw new Error(`Ошибка HTTP: ${response.status}`);
            }
        })
        .then(data => {
            console.log(data);
            alert('Администратор успешно добавлен');
            // Очистка полей формы или другие необходимые действия после успешной регистрации
            document.getElementById('registrationForm').reset();
        })
        .catch(error => {
            console.error('Ошибка при отправке запроса:', error);
            alert('Произошла ошибка при регистрации администратора');
        });
}
document.getElementById('uploadButton').addEventListener('click', async () => {
    const fileInput = document.getElementById('excelFile');
    const file = fileInput.files[0];
  
    if (!file) {
      alert('Выберите файл для загрузки');
      return;
    }
  
    const formData = new FormData();
    formData.append('file', file);
  
    try {
      const response = await fetch('http://localhost:3001/import-administrator', {
        method: 'POST',
        body: formData
      });
  
      if (!response.ok) {
        throw new Error('Ошибка при импорте данных');
      }
  
      const result = await response.text();
      alert('Файл успешно загружен и обработан: ' + result);
      window.location.reload(); 
    } catch (error) {
      console.error('Ошибка при отправке запроса:', error);
      alert('Файл успешно загружен и обработан!');
    }
  });