// Функция форматирования строки даты
function formatDateString(dateString) {
    const date = new Date(dateString);
    if (isNaN(date)) {
        return null; 
    }
    const formattedDate = date.toISOString().split('T')[0];
    return formattedDate;
}

// Функция получения даты последнего месяца
function getLastMonthDate() {
    const currentDate = new Date();
    const startDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
    return startDate;
}

function getLastWeekDates() {
    const endDate = new Date();
    const startDate = new Date(endDate.getFullYear(), endDate.getMonth(), endDate.getDate() - 7);
    return { startDate, endDate };
}

async function generateStatistics() {
    try {
        const response = await fetch('http://localhost:3001/applications');
        const data = await response.json();

        const today = new Date().toISOString().split('T')[0];

        const weeklyData = getDataForPeriod(data, getLastWeekDates(), 'rgba(255, 99, 132, 0.6)', 'rgba(255, 99, 132, 1)');
        const monthlyData = getDataForPeriod(data, { startDate: getLastMonthDate(), endDate: new Date() }, 'rgba(54, 162, 235, 0.6)', 'rgba(54, 162, 235, 1)');
        const yearlyData = getDataForPeriod(data, { startDate: new Date().getFullYear() - 1, endDate: new Date() }, 'rgba(255, 205, 86, 0.6)', 'rgba(255, 205, 86, 1)');

        const labels = Object.keys(weeklyData);
        const datasets = [
            {
                label: 'Количество заявок за неделю',
                data: Object.values(weeklyData),
                backgroundColor: 'rgba(255, 99, 132, 0.6)',
                borderColor: 'rgba(255, 99, 132, 1)',
                borderWidth: 1,
                categoryPercentage: 0.5,
                barPercentage: 0.5
            },
            {
                label: 'Количество заявок за месяц',
                data: Object.values(monthlyData),
                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1,
                categoryPercentage: 0.5,
                barPercentage: 0.5
            },
            {
                label: 'Количество заявок за год',
                data: Object.values(yearlyData),
                backgroundColor: 'rgba(255, 205, 86, 0.6)',
                borderColor: 'rgba(255, 205, 86, 1)',
                borderWidth: 1,
                categoryPercentage: 0.5,
                barPercentage: 0.5
            }
        ];

        generateChart({ labels, datasets });
    } catch (error) {
        console.error('Ошибка при получении данных о заявках:', error);
    }
}

function getDataForPeriod(data, period, backgroundColor, borderColor) {
    const filteredData = data.filter(record => {
        const date = new Date(record.Submission_Date);
        const recordDate = `${date.getFullYear()}-${('0' + (date.getMonth() + 1)).slice(-2)}-${('0' + date.getDate()).slice(-2)}`;

        return (date >= period.startDate) && (date <= period.endDate) && (recordDate <= new Date().toISOString().split('T')[0]);
    });

    const applicationsData = {};

    filteredData.forEach(record => {
        const date = formatDateString(record.Submission_Date);

        if (!applicationsData[date]) {
            applicationsData[date] = 0;
        }

        applicationsData[date]++;
    });

    return applicationsData;
}

function generateChart(data) {
    const ctx = document.getElementById('applicationsChart').getContext('2d');
    let existingChart = window.applicationsChart;

    if (existingChart instanceof Chart) {
        existingChart.destroy();
    }

    window.applicationsChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: data.labels,
            datasets: data.datasets
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            },
            plugins: {
                title: {
                    display: true,
                    text: 'Статистика по количеству заявок'
                }
            }
        }
    });
}
fetch('http://localhost:3001/totalUsers')
    .then(response => response.json())
    .then(data => {
        const totalUsers = data && data[0] && data[0].totalUsers !== undefined ? data[0].totalUsers : 0;

        // Запрос на получение количества абитуриентов
        fetch('http://localhost:3001/totalAbiturient')
            .then(response => response.json())
            .then(data => {
                const totalAbiturients = data && data[0] && data[0].totalAbiturients !== undefined ? data[0].totalAbiturients : 0;

                // Суммируем значения и обновляем блок статистики
                const totalUsersAndAbiturients = totalUsers + totalAbiturients;
                document.getElementById('totalUsers').innerText = `Количество зарегистрированных пользователей: ${totalUsersAndAbiturients}`;
            })
            .catch(error => console.error('Error fetching totalAbiturient:', error));
    })
    .catch(error => console.error('Error fetching totalUsers:', error));

    fetch('http://localhost:3001/totalUsers')
    .then(response => response.json())
    .then(data => {
        if (data && data[0] && data[0].totalUsers !== undefined) {
            document.getElementById('totalEmployee').innerText = `Количество сотрудников: ${data[0].totalUsers}`;
        } else {
            console.error('Error: Invalid data received for totalEmployee');
        }
    })
    .catch(error => console.error('Error fetching totalEmployee:', error));

fetch('http://localhost:3001/totalAbiturient')
.then(response => response.json())
.then(data => {
    if (data && data[0] && data[0].totalAbiturients !== undefined) {
        document.getElementById('totalAbiturients').innerText = `Количество абитуриентов: ${data[0].totalAbiturients}`;
    } else {
        console.error('Error: Invalid data received for totalAbiturients');
    }
})
.catch(error => console.error('Error fetching totalAbiturient:', error));

// Инициализация по умолчанию (при загрузке страницы)
generateStatistics();
