function createBackup() {
    // AJAX-запрос к серверу для создания бэкапа
    $.ajax({
        type: "POST",
        url: "http://localhost:3001/createBackup", 
        success: function (response) {
            console.log("Успешный ответ сервера:", response);
            alert("Резервная копия успешно создана!");
        },
        error: function (xhr, status, error) {
            console.error("Ошибка при создании резервной копии:", error);
            console.log("Ответ сервера:", xhr.responseText);
            alert("Произошла ошибка при создании резервной копии.");
        }
    });
}
function restoreBackup() {
    // AJAX-запрос к серверу для восстановления бэкапа
    $.ajax({
      type: "POST",
      url: "http://localhost:3001/restoreBackup",
      success: function (response) {
        console.log("Успешный ответ сервера:", response);
        alert("Резервная копия успешно восстановлена!");
      },
      error: function (xhr, status, error) {
        console.error("Ошибка при восстановлении резервной копии:", error);
        console.log("Ответ сервера:", xhr.responseText);
        alert("Произошла ошибка при восстановлении резервной копии.");
      }
    });
  }
  