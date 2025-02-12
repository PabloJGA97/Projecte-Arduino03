const alumnosFicticios = [
    { nombre: 'Arman', id: 1 },
    { nombre: 'Arman', id: 2 },
    { nombre: 'Arman', id: 3 },
    { nombre: 'Arman', id: 4 },
    { nombre: 'Arman', id: 5 }
];

document.getElementById('consultarBtn').addEventListener('click', function() {
    const fecha = document.getElementById('fecha').value;
    const asignatura = document.getElementById('asignatura').value;
    const grupo = document.getElementById('grupo').value;

    if (fecha && asignatura && grupo) {
        mostrarTabla();
    } else {
        alert('Per favor, omple tots els camps.');
    }
});

document.getElementById('pasarListaBtn').addEventListener('click', function() {
    alert('Llista passada');

    const resultContainer = document.getElementById('resultContainer');
    resultContainer.style.display = 'none';
});

function mostrarTabla() {
    const resultContainer = document.getElementById('resultContainer');
    resultContainer.style.display = 'block';

    const asistenciaData = document.getElementById('asistenciaData');
    asistenciaData.innerHTML = ''; 

    alumnosFicticios.forEach(alumno => {
        const row = document.createElement('tr');
        
        const tdNombre = document.createElement('td');
        tdNombre.textContent = alumno.nombre;
        
        const tdPresent = document.createElement('td');
        const presentCheckbox = document.createElement('input');
        presentCheckbox.type = 'checkbox';
        tdPresent.appendChild(presentCheckbox);
        
        const tdAbsent = document.createElement('td');
        const absentCheckbox = document.createElement('input');
        absentCheckbox.type = 'checkbox';
        tdAbsent.appendChild(absentCheckbox);
        
        row.appendChild(tdNombre);
        row.appendChild(tdPresent);
        row.appendChild(tdAbsent);
        
        asistenciaData.appendChild(row);
    });
}
