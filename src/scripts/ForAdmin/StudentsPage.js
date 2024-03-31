function formatDate(dateString) {
    const options = { year: 'numeric', month: 'numeric', day: 'numeric' };
    return new Date(dateString).toLocaleDateString(undefined, options);
}

// Функция для загрузки данных абитуриентов в табличном виде
async function loadStudentsData(programId, classId, educationFormId) {
    try {
        const response = await fetch(`http://localhost:3001/AllApplications?programId=${programId}&classId=${classId}&educationFormId=${educationFormId}`);
        const studentsData = await response.json();
        console.log(studentsData); // Добавляем вывод данных в консоль
        return studentsData;
    } catch (error) {
        console.error('Ошибка при загрузке данных абитуриентов:', error);
        return [];
    }
}

// Функция для сортировки данных абитуриентов по фамилии в порядке убывания
function sortByNameDescending(studentsData) {
    return studentsData.slice().sort((a, b) => b.Surname.localeCompare(a.Surname));
}

// Функция для сортировки данных абитуриентов по фамилии в порядке возрастания
function sortByNameAscending(studentsData) {
    return studentsData.slice().sort((a, b) => a.Surname.localeCompare(b.Surname));
}

// Функция для сортировки и отображения данных абитуриентов
function sortAndRender(order) {
    // Выбираем соответствующий порядок сортировки
    const sortedStudents = order === 'asc' ? sortByNameAscending(studentsData) : sortByNameDescending(studentsData);

    // Обновляем отображение данных
    renderStudentsList(sortedStudents, programDetails);
}
// Функция для отображения данных абитуриентов в табличном виде с учетом фильтра
function renderStudentsList(studentsData, programDetails, surnameFilter, statusFilter) {
    const studentsListContainer = document.getElementById('studentsList');
    studentsListContainer.innerHTML = '';

    // Обновляем значения в блоке с id "programDetails"
    const programDetailsBlock = document.getElementById('programDetails');
    programDetailsBlock.innerHTML = `${programDetails.Specialty_Code}: ${programDetails.Specialty_Name} | Форма обучения: ${programDetails.Form_Name} | ${programDetails.Class_Name} класса`;

    // Фильтруем данные по фамилии и статусу, если фильтры определены
    const filteredStudents = studentsData.filter(student => {
        const surnameMatch = surnameFilter ? student.Surname.toLowerCase().includes(surnameFilter.toLowerCase()) : true;
        const statusMatch = statusFilter ? student.Status_Name === statusFilter : true;
        return surnameMatch && statusMatch;
    });
   
    if (filteredStudents.length === 0) {
        const noResultsMessage = document.createElement('tr');
        noResultsMessage.innerHTML = `
            <td colspan="5" class="text-center">Нет поданных заявок</td>
        `;
        studentsListContainer.appendChild(noResultsMessage);
    } else {
        // Создаем строки таблицы для отображения данных абитуриентов
        filteredStudents.forEach(student => {
            const studentRow = document.createElement('tr');
            const dropdownId = `statusDropdown_${student.ID_Abiturient}`;  // Уникальный идентификатор

            studentRow.innerHTML = `
                <td>${student.Surname} ${student.First_Name} ${student.Middle_Name}</td>
                <td>${formatDate(student.Submission_Date)}</td>
                <td>${student.Average_Student_Grade}</td>
                <td>
                    <span>${student.Status_Name}</span>
                    <select class="form-control mr-2" id="${dropdownId}">
                        <option value="1" ${student.Status_Name === 'Поступил' ? 'selected' : ''}>Поступил</option>
                        <option value="2" ${student.Status_Name === 'Не проходит' ? 'selected' : ''}>Не проходит</option>
                        <option value="3" ${student.Status_Name === 'Проходит' ? 'selected' : ''}>Проходит</option>
                        <option value="4" ${student.Status_Name === 'На рассмотрении' ? 'selected' : ''}>На рассмотрении</option>
                        <option value="5" ${student.Status_Name === 'Отказ' ? 'selected' : ''}>Отказ</option>
                    </select>
                </td>
                <td>
                <button class="btn btn-primary" onclick="changeStatus('${student.ID_Abiturient}', '${dropdownId}')">Изменить</button>
                </td>
            `;
            studentsListContainer.appendChild(studentRow);
        });

    }
}

// Обработчик события изменения значения в поле поиска по фамилии
document.getElementById('surnameFilter').addEventListener('input', function () {
    const surnameFilter = this.value;
    renderStudentsList(window.studentsData, window.programDetails, surnameFilter);
});


// Вызываем функцию загрузки данных и отображения абитуриентов
const urlParams = new URLSearchParams(window.location.search);
const programId = urlParams.get('programId');
const classId = urlParams.get('classId');
const educationFormId = urlParams.get('educationFormId');

// Добавляем функцию для загрузки дополнительных данных о программе
async function loadProgramDetails(programId) {
    try {
        const response = await fetch(`http://localhost:3001/AboutPrograms?id=${programId}`);
        const programDetails = await response.json();
        console.log(programDetails); // Добавляем вывод данных в консоль
        return programDetails;
    } catch (error) {
        console.error('Ошибка при загрузке данных о программе:', error);
        return {};
    }
}
// Функция для сортировки данных абитуриентов по среднему баллу в порядке убывания
function sortByGradeDescending(studentsData) {
    if (studentsData) {
        return studentsData.slice().sort((a, b) => b.Average_Student_Grade - a.Average_Student_Grade);
    } else {
        return [];
    }
}

// Функция для сортировки данных абитуриентов по среднему баллу в порядке возрастания
function sortByGradeAscending(studentsData) {
    if (studentsData) {
        return studentsData.slice().sort((a, b) => a.Average_Student_Grade - b.Average_Student_Grade);
    } else {
        return [];
    }
}
function sortByGradeDescending() {
    // Выбираем соответствующий порядок сортировки
    const sortedStudents = sortByGradeDescendingOrder(window.studentsData);

    // Обновляем отображение данных
    renderStudentsList(sortedStudents, window.programDetails);
}

// Функция для сортировки данных абитуриентов по среднему баллу в порядке возрастания
function sortByGradeAscending() {
    // Выбираем соответствующий порядок сортировки
    const sortedStudents = sortByGradeAscendingOrder(window.studentsData);

    // Обновляем отображение данных
    renderStudentsList(sortedStudents, window.programDetails);
}

// Функция для сортировки данных абитуриентов по среднему баллу в порядке убывания
function sortByGradeDescendingOrder(studentsData) {
    if (studentsData) {
        return studentsData.slice().sort((a, b) => b.Average_Student_Grade - a.Average_Student_Grade);
    } else {
        return [];
    }
}

// Функция для сортировки данных абитуриентов по среднему баллу в порядке возрастания
function sortByGradeAscendingOrder(studentsData) {
    if (studentsData) {
        return studentsData.slice().sort((a, b) => a.Average_Student_Grade - b.Average_Student_Grade);
    } else {
        return [];
    }
}

// Загружаем данные о программе и студентах
console.log('programId:', programId);
console.log('classId:', classId);
console.log('educationFormId:', educationFormId);

// Загружаем данные о программе и студентах
Promise.all([loadProgramDetails(programId), loadStudentsData(programId, classId, educationFormId)])
    .then(([programDetails, studentsData]) => {
        // Сохраняем данные абитуриентов и детали программы для последующего использования
        window.studentsData = studentsData;
        window.programDetails = programDetails;

        // Инициализируем отображение данных
        renderStudentsList(studentsData, programDetails);
    })
    .catch(error => console.error('Ошибка:', error));
// Добавьте обработчик события для кнопки экспорта в Excel
document.getElementById('exportButtonExcel').addEventListener('click', exportToExcel);

// Функция для экспорта данных в Excel
function exportToExcel() {
    const data = prepareDataForExport(window.studentsData);
    const ws = XLSX.utils.json_to_sheet(data);

    // Добавьте заголовок к листу
    XLSX.utils.sheet_add_aoa(ws, [
        ['Фамилия', 'Имя', 'Отчество', 'Дата подачи заявки', 'Средний балл', 'Статус']
    ], { origin: 0 }); // origin: -1 помещает заголовок перед содержимым

    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Абитуриенты');

    // Сохраните файл
    XLSX.writeFile(wb, 'Список_заявок.xlsx');
}

// Функция для подготовки данных перед экспортом
function prepareDataForExport(studentsData) {
    // Отфильтруйте только необходимые поля
    const filteredData = studentsData.map(student => ({
        Surname: student.Surname,
        First_Name: student.First_Name,
        Middle_Name: student.Middle_Name,
        Submission_Date: formatDate(student.Submission_Date),
        Average_Student_Grade: student.Average_Student_Grade,
        Status_Name: student.Status_Name
    }));

    return filteredData;
}
document.getElementById('statusFilter').addEventListener('change', function () {
    const statusFilter = this.value;
    renderStudentsList(window.studentsData, window.programDetails, null, statusFilter);
});
function exportToSQL() {
    // Получаем таблицу и ее строки (студентов)
    const table = document.querySelector('.table');
    const rows = table.querySelectorAll('tbody tr');

    // Создаем пустой массив для хранения данных студентов
    const studentsData = [];

    // Проходимся по каждой строке таблицы и извлекаем данные студентов
    rows.forEach(row => {
        const cells = row.querySelectorAll('td');
        const student = {
            name: cells[0].textContent.trim(), // ФИО абитуриента
            date: cells[1].textContent.trim(), // Дата подачи заявки
            grade: parseFloat(cells[2].textContent.trim()), // Средний балл аттестата (преобразовываем в число)
            status: cells[3].querySelector('span').textContent.trim() // Статус
        };
        studentsData.push(student); // Добавляем данные студента в массив
    });

    // Создаем SQL запросы для вставки данных
    const sqlQueries = studentsData.map(student => {
        return `INSERT INTO Abiturient (Surname, First_Name, Middle_Name, Date_of_Birth, Grade, Status) VALUES ('${student.name.split(' ').join("', '")}', '${student.date}', ${student.grade}, '${student.status}');`;
    });

    // Создаем текстовый файл с SQL запросами
    const sqlFileContent = sqlQueries.join('\n');

    // Создаем ссылку для скачивания файла
    const blob = new Blob([sqlFileContent], { type: 'text/plain' });
    const url = window.URL.createObjectURL(blob);

    // Создаем ссылку для скачивания файла
    const link = document.createElement('a');
    link.href = url;
    link.download = 'Списки абитуриентов.sql';
    document.body.appendChild(link);

    // Кликаем по ссылке, чтобы скачать файл
    link.click();

    // Освобождаем ресурсы
    window.URL.revokeObjectURL(url);
}


// Функция для изменения статуса
async function changeStatus(abiturientId, dropdownId) {
    // Запрос подтверждения у пользователя
    const isConfirmed = window.confirm('Уведомить абитуриента о смене статуса его заявки?');

    if (!isConfirmed) {
        return;
    }

    const selectedStatusId = document.getElementById(dropdownId).value;

    try {
        const response = await fetch(`http://localhost:3001/ChangeStatus/${abiturientId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ newStatusId: selectedStatusId }),
        });

        const result = await response.json();
        if (result.success) {
            // Отправляем запрос на сервер для отправки уведомления по электронной почте
            const studentsData = await loadStudentsData(programId, classId, educationFormId);
            const student = studentsData.find(student => student.ID_Abiturient.toString() === abiturientId.toString());
            console.log('status.Status_Name:', result.Status_Name);
            
            if (student && student.Login) {
                console.log('Login абитуриента:', student.Login);
        
                await fetch('http://localhost:3001/sendEmail', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ email: student.Login, message: `Уважаемый абитуриент, статус Вашей заявки изменился на "${student.Status_Name}". Зайдите на сайт Приемной комиссии, чтобы ознакомиться подробнее.` }),
                });
        
                alert('Статус успешно обновлен!');
            } else {
                console.log('Login абитуриента отсутствует');
                alert('Статус успешно обновлен!');
            }
        
         
            // Обновляем данные после изменения статуса
            renderStudentsList(studentsData, window.programDetails);
        } else {
            alert('Не удалось обновить статус.');
        }
    } catch (error) {
        console.error('Ошибка при изменении статуса:', error);
        alert('Произошла ошибка при изменении статуса.');
    }
}
