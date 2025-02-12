document.getElementById("consultarBtn").addEventListener("click", async function(event) {
    const idAlumno = document.getElementById("id_alumno").value;
    const fecha = document.getElementById("fecha").value;

    if (!idAlumno || !fecha) {
        document.getElementById("error").innerText = "Por favor, rellena todos los campos.";
        document.getElementById("error").style.display = "block";
        document.getElementById("resultContainer").style.display = "none";
        return;
    }

    const requestBody = {
        fecha: fecha,
        id_alumno: parseInt(idAlumno)
    };

    try {
        const response = await fetch('http://127.0.0.1:8000/assistencia/alumno', {
            method: 'POST', 
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify(requestBody)
        });

        const data = await response.json();

        if (response.ok) {
            document.getElementById("resultContainer").style.display = "block";
            document.getElementById("error").style.display = "none";

            const tbody = document.getElementById("asistenciaData");
            tbody.innerHTML = '';

            data.forEach(item => {
                const row = document.createElement("tr");
                row.innerHTML = `
                    <td>${item.data}</td>
                    <td>${item.hora_inici}</td>
                    <td>${item.hora_final}</td>
                    <td>${item.estat}</td>
                    <td>${item.nom_aula}</td>
                    <td>${item.assignatura}</td>
                `;
                tbody.appendChild(row);
            });
        } else {
            throw new Error('No se encontraron resultados para este alumno en esa fecha.');
        }
    } catch (error) {
        document.getElementById("error").innerText = error.message;
        document.getElementById("error").style.display = "block";
        document.getElementById("resultContainer").style.display = "none";
    }
});
