// Функция для преобразования значения с запятой в точку
function convertCommaToDot(value) {
    return value.replace(',', '.'); // Заменяем запятую на точку
}// Обработчик клика на кнопку "Подать заявку"
// Обработчик клика на кнопку "Подать заявку"
document.querySelector('.btn-primary').addEventListener('click', async () => {
    // Получаем данные
    let averageGradeInput = document.getElementById('averageGrade');
    const averageGrade = convertCommaToDot(averageGradeInput.value); // Преобразуем значение с запятой в точку
    const userId = localStorage.getItem('userId'); // Предполагается, что у вас есть userId в localStorage
    const specialty = document.getElementById('specialty').value;

    // Проверяем средний балл
    if (!validateAverageGrade(averageGrade)) {
        return; // Прерываем отправку формы
    }

    // Подтверждаем отправку заявки
    if (!confirmSubmission()) {
        return; // Прерываем отправку формы
    }

    // Проверяем наличие данных в таблице Personal_Data
    try {
        const personalDataResponse = await fetch('http://localhost:3001/checkPersonalData', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                userId
            })
        });

        if (!personalDataResponse.ok) {
            throw new Error('Failed to check personal data');
        }

        const personalData = await personalDataResponse.json();

        if (!personalData.hasData) {
            alert('Сначала заполните документы в личном кабинете!');
            return;
        }

        // Проверяем наличие дубликатов заявок
        const checkDuplicateResponse = await fetch(`http://localhost:3001/checkApplicationDuplicate/${userId}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (!checkDuplicateResponse.ok) {
            throw new Error('Failed to check duplicate applications');
        }

        const duplicateData = await checkDuplicateResponse.json();

        if (duplicateData.hasData) {
            alert('Вы уже подали заявку! Смотрите статус поступления в личном кабинете.');
            return; 
        }

        // Если данные в таблице Personal_Data есть и дубликатов нет, отправляем заявку
        const response = await fetch('http://localhost:3001/submitApplication/' + userId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                averageGrade,
                specialty
            })
        });

        if (!response.ok) {
            throw new Error('Failed to submit application');
        }

        const data = await response.json();
        console.log(data.message); // Ответ от сервера
        alert('Заявка успешно отправлена. Посмотрите статус заявки в личном'); // Уведомление о успешной отправке
    } catch (error) {
        console.error('Error submitting application:', error.message); // Выводим более информативное сообщение об ошибке
        alert('Произошла ошибка при отправке заявки');
    }
});


// Функция для проверки среднего балла
function validateAverageGrade(averageGrade) {
    averageGrade = convertCommaToDot(averageGrade); // Преобразуем значение с запятой в точку для проверки
    if (!/^([3-5](\.|\,)?\d{0,5}|5(\.|\,)?0{1,5})$/.test(averageGrade)) {
        alert('Ошибка ввода среднего балла обучения. Введите число от 3 до 5 с не более чем четырьмя знаками после запятой.');
        return false; // Прерываем отправку формы
    }
    return true;
}


// Функция для подтверждения отправки заявки
function confirmSubmission() {
    const specialtySelect = document.getElementById('specialty');
    const specialtyText = specialtySelect.options[specialtySelect.selectedIndex].text;
    const averageGrade = document.getElementById('averageGrade').value;

    const confirmation = confirm(`Вы уверены, что хотите подать заявку на специальность "${specialtyText}" с баллом ${averageGrade}?`);

    return confirmation;
}

// Загружаем программы при загрузке страницы
document.addEventListener('DOMContentLoaded', loadPrograms);

window.addEventListener('load', () => {
    loadPrograms();
});

async function loadPrograms() {
    try {
        const serviceResponse = await fetch('http://localhost:3001/ListOfPrograms');
        if (!serviceResponse.ok) {
            throw new Error('Failed to fetch service data');
        }
        const serviceData = await serviceResponse.json();
        const serviceSelect = $('#specialty'); // jQuery для выбора элемента

        serviceData.forEach(service => {
            const option = new Option(`${service.Specialty_Code} ${service.Specialty_Name} - ${service.Form_Name} - ${service.Class_Name}`, service.ID_Program, false, false);
            serviceSelect.append(option);
        });

        // Применяем Select2 к элементу select
        serviceSelect.select2();

        // Обработчик события изменения выбранной услуги
        serviceSelect.on('change', function () {
            // Ваш код обработки изменения выбранной услуги здесь
            console.log('Выбранная специальность:', $(this).val());
        });

    } catch (error) {
        console.error('Error fetching service data:', error);
    }
}
// Получение данных о заявках с сервера
async function fetchApplications(userId) {
    try {
        const response = await fetch(`http://localhost:3001/getApplications/${userId}`);
        if (!response.ok) {
            throw new Error('Failed to fetch applications');
        }
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error fetching applications:', error);
        return [];
    }
}
// Функция для создания карточки по заявке с кнопкой удаления
function createApplicationCard(application) {
    const card = document.createElement('div');
    card.classList.add('card');
    
    const cardBody = document.createElement('div');
    cardBody.classList.add('card-body');
    
    const title = document.createElement('h5');
    title.classList.add('card-title');
    title.textContent = `Заявка №${application.Application_ID}`;
    
    // Форматирование даты
    const submissionDate = new Date(application.Submission_Date);
    const formattedDate = `${submissionDate.getFullYear()}-${(submissionDate.getMonth() + 1).toString().padStart(2, '0')}-${submissionDate.getDate().toString().padStart(2, '0')}`;
    
    const details = document.createElement('p');
    details.classList.add('card-text');
    details.innerHTML = `
        Дата подачи: ${formattedDate}<br>
        Специальность:  ${application.Specialty_Code} ${application.Specialty_Name}<br>
        Форма обучения: ${application.Form_Name}. ${application.Class_Name} класса<br>
    `;

    // Создание кнопки удаления
    const deleteButton = document.createElement('button');
    deleteButton.textContent = 'Удалить';
    deleteButton.classList.add('btn', 'btn-danger', 'mt-2');
    deleteButton.addEventListener('click', async () => {
        // Запрашиваем подтверждение перед удалением
        const confirmDelete = confirm(`Вы уверены, что хотите удалить заявку №${application.Application_ID}?`);

        if (confirmDelete) {
            try {
                const response = await fetch(`http://localhost:3001/deleteApplication/${application.Application_ID}`, {
                    method: 'DELETE'
                });

                if (!response.ok) {
                    throw new Error('Failed to delete application');
                }

                // Удаление карточки из интерфейса
                card.remove();
                alert('Заявка успешно удалена');
            } catch (error) {
                console.error('Error deleting application:', error);
                alert('Произошла ошибка при удалении заявки');
            }
        }
    });

    cardBody.appendChild(title);
    cardBody.appendChild(details);
    cardBody.appendChild(deleteButton); // Добавление кнопки удаления
    card.appendChild(cardBody);
    
    return card;
}


// Функция для отображения карточек на странице
async function displayApplications(userId) {
    const applications = await fetchApplications(userId);
    const container = document.getElementById('applicationContainer');
    
    applications.forEach(application => {
        const card = createApplicationCard(application);
        container.appendChild(card);
    });
}

// Получение userId из localStorage
const userId = localStorage.getItem('userId');
console.log('UserID:', userId);

// Вызов функции для отображения карточек по заявкам
displayApplications(userId);
