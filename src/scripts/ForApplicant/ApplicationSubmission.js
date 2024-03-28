document.addEventListener('DOMContentLoaded', () => {
    const submitButton = document.querySelector('.btn-primary');

    submitButton.addEventListener('click', async () => {
        try {
            const averageGradeInput = document.getElementById('averageGrade');
            const specialtySelect = document.getElementById('specialty');
            const educationBasisSelect = document.getElementById('educationBasis');
            const schoolClassSelect = document.getElementById('schoolClass');

            const averageGrade = averageGradeInput.value;
            const specialty = specialtySelect.value;
            const educationForm = educationBasisSelect.value;
            const schoolClass = schoolClassSelect.value;
            
            if (!/^([3-4](\.|\,)?\d{1,5}|5(\.|\,)?0{1,5})$/.test(averageGrade)) {
                alert('Ошибка ввода среднего балла обучения. Введите число от 3 до 5 с не более чем четырьмя знаками после запятой.');
                return; // Прерываем отправку формы
            }

            const confirmation = confirm(`Вы уверены, что хотите подать заявку на специальность "${specialtySelect.options[specialtySelect.selectedIndex].text}" (${educationBasisSelect.options[educationBasisSelect.selectedIndex].text}) с баллом ${averageGrade}?`);

            if (!confirmation) {
                return; // Прерываем отправку формы
            }

            const formData = {
                averageGrade,
                specialty,
                educationForm,
                schoolClass
            };

            const response = await fetch('http://localhost:3001/submitApplication', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            if (!response.ok) {
                throw new Error('Ошибка при отправке данных формы');
            }

            const responseData = await response.json();
            console.log(responseData); // Вывод ответа сервера в консоль

            alert('Заявка успешно подана!'); // Уведомление о успешной подаче заявки

            // Возможно, здесь вы захотите выполнить какие-то дополнительные действия после успешной отправки данных формы

        } catch (error) {
            console.error('Ошибка при отправке данных формы:', error);
            // Возможно, здесь вы захотите предпринять какие-то действия в случае ошибки
        }
    });
});

fetch('http://localhost:3001/getSpecialties')
.then(response => response.json())
.then(data => {
    const specialtySelect = document.getElementById('specialty');
    data.forEach(specialty => {
        const option = document.createElement('option');
        option.value = specialty.ID_Specialization;
        option.textContent = specialty.Specialty_Name;
        specialtySelect.appendChild(option);
    });
})
.catch(error => console.error('Ошибка при получении специальностей:', error));

// Запрос для получения форм обучения
fetch('http://localhost:3001/getEducationForms')
.then(response => response.json())
.then(data => {
    const educationBasisSelect = document.getElementById('educationBasis');
    data.forEach(educationForm => {
        const option = document.createElement('option');
        option.value = educationForm.ID_Education_Form;
        option.textContent = educationForm.Form_Name;
        educationBasisSelect.appendChild(option);
    });
})
.catch(error => console.error('Ошибка при получении форм обучения:', error));

// Запрос для получения классов
fetch('http://localhost:3001/getClasses')
.then(response => response.json())
.then(data => {
    const schoolClassSelect = document.getElementById('schoolClass');
    data.forEach(schoolClass => {
        const option = document.createElement('option');
        option.value = schoolClass.ID_Class;
        option.textContent = schoolClass.Class_Name;
        schoolClassSelect.appendChild(option);
    });
})
.catch(error => console.error('Ошибка при получении классов:', error));