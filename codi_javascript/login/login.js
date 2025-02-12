const users = [
    { username: 'admin', password: '1234', role: 'admin' },
    { username: 'professor', password: '1234', role: 'professor' },
    { username: 'alumne', password: '1234', role: 'alumne' }
];

document.getElementById('login-btn').addEventListener('click', function() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    const user = users.find(user => user.username === username && user.password === password);

    if (user) {
        if (user.role === 'professor') {
            window.location.href = '../professor/professor.html';  
        } else if (user.role === 'admin') {
            window.location.href = '../admin/admin.html';  
        } else if (user.role === 'alumne') {
            window.location.href = '../alumne/alumne.html';  
        }
    } else {
        alert('Usuari o contraseña incorrecta');
    }
});
