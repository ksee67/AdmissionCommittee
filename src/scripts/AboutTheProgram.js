document.addEventListener("DOMContentLoaded", function () {
    const urlParams = new URLSearchParams(window.location.search);
    const programId = urlParams.get('id');

    fetch(`http://localhost:3001/AboutPrograms?id=${programId}`)
        .then(response => response.json())
        .then(data => {
            //  HTML данными из полученного ответа
            document.getElementById('Specialty_Name').textContent = data.Specialty_Name;
            document.getElementById('Specialty_Code').textContent = `Направление специальности: ${data.Specialty_Code}`;
            document.getElementById('Qualification_Name').textContent = `Квалификация: ${data.Qualification_Name}`;
            document.getElementById('Training_Duration').textContent = `Срок обучения: ${data.Training_Duration}`;
            document.getElementById('Class_Name').textContent = `На базе какого класса: ${data.Class_Name}`;
            document.getElementById('Education_Form_Name').textContent = `Форма обучения: ${data.Form_Name}`;
            document.getElementById('Description').textContent = `Описание специальности: ${data.Description}`;

            // картинка
            const programImage = document.getElementById('programImage');
            if (programImage) {
                programImage.src = data.Photo_URL;
            }
        })
        .catch(error => console.error('Ошибка:', error));
});