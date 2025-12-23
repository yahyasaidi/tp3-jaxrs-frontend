<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TP3 - API REST JAX-RS</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        body {
            background: #0a0e27;
            background-image:
                    radial-gradient(at 0% 0%, rgba(138, 43, 226, 0.15) 0px, transparent 50%),
                    radial-gradient(at 100% 0%, rgba(30, 144, 255, 0.15) 0px, transparent 50%),
                    radial-gradient(at 100% 100%, rgba(255, 0, 128, 0.15) 0px, transparent 50%),
                    radial-gradient(at 0% 100%, rgba(0, 255, 200, 0.15) 0px, transparent 50%);
            min-height: 100vh;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background:
                    repeating-linear-gradient(90deg, rgba(255,255,255,0.01) 0px, transparent 1px, transparent 40px, rgba(255,255,255,0.01) 41px),
                    repeating-linear-gradient(0deg, rgba(255,255,255,0.01) 0px, transparent 1px, transparent 40px, rgba(255,255,255,0.01) 41px);
            pointer-events: none;
            z-index: 1;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(15, 20, 40, 0.7);
            border-radius: 24px;
            box-shadow:
                    0 0 0 1px rgba(255, 255, 255, 0.05),
                    0 30px 80px rgba(0, 0, 0, 0.5),
                    inset 0 1px 0 rgba(255, 255, 255, 0.1);
            overflow: hidden;
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            position: relative;
            z-index: 2;
        }

        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 2px;
            background: linear-gradient(90deg, transparent, #00d9ff, transparent);
            animation: scan 3s ease-in-out infinite;
        }

        @keyframes scan {
            0%, 100% { left: -100%; }
            50% { left: 100%; }
        }

        header {
            background: linear-gradient(135deg, rgba(138, 43, 226, 0.2) 0%, rgba(30, 144, 255, 0.2) 100%);
            color: white;
            padding: 40px 20px;
            text-align: center;
            position: relative;
            overflow: hidden;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(0, 217, 255, 0.1) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 800;
            position: relative;
            z-index: 1;
            background: linear-gradient(135deg, #00d9ff 0%, #a855f7 50%, #ff0080 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0 0 30px rgba(0, 217, 255, 0.3);
            letter-spacing: -1px;
        }

        header p {
            position: relative;
            z-index: 1;
            font-size: 1em;
            opacity: 0.7;
            text-transform: uppercase;
            letter-spacing: 3px;
            font-weight: 600;
        }

        .main-content {
            padding: 30px;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .card {
            background: rgba(20, 25, 50, 0.6);
            border-radius: 16px;
            padding: 25px;
            box-shadow:
                    0 8px 32px rgba(0, 0, 0, 0.3),
                    inset 0 1px 0 rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.08);
            flex: 1;
            min-width: 300px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.05), transparent);
            transition: left 0.5s;
        }

        .card:hover::before {
            left: 100%;
        }

        .card:hover {
            transform: translateY(-8px);
            border-color: rgba(0, 217, 255, 0.3);
            box-shadow:
                    0 20px 60px rgba(0, 217, 255, 0.2),
                    inset 0 1px 0 rgba(255, 255, 255, 0.1);
        }

        .card h2 {
            color: #00d9ff;
            margin-bottom: 20px;
            font-size: 1.2em;
            font-weight: 700;
            border-bottom: 2px solid rgba(0, 217, 255, 0.3);
            padding-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
        }

        .card h2::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 60px;
            height: 2px;
            background: linear-gradient(90deg, #00d9ff, #a855f7);
            box-shadow: 0 0 10px #00d9ff;
        }

        input {
            width: 100%;
            padding: 14px 18px;
            margin: 8px 0;
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: rgba(10, 15, 35, 0.5);
            color: #fff;
            backdrop-filter: blur(10px);
        }

        input::placeholder {
            color: rgba(255, 255, 255, 0.3);
        }

        input:focus {
            outline: none;
            border-color: #00d9ff;
            box-shadow:
                    0 0 0 3px rgba(0, 217, 255, 0.1),
                    0 0 20px rgba(0, 217, 255, 0.2);
            background: rgba(10, 15, 35, 0.8);
        }

        .btn {
            padding: 12px 24px;
            margin: 5px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn span {
            position: relative;
            z-index: 1;
        }

        .btn-primary {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }

        .btn-primary:hover {
            box-shadow: 0 6px 25px rgba(16, 185, 129, 0.5);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3);
        }

        .btn-secondary:hover {
            box-shadow: 0 6px 25px rgba(59, 130, 246, 0.5);
            transform: translateY(-2px);
        }

        .btn-info {
            background: linear-gradient(135deg, #00d9ff 0%, #00a8cc 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 217, 255, 0.3);
        }

        .btn-info:hover {
            box-shadow: 0 6px 25px rgba(0, 217, 255, 0.5);
            transform: translateY(-2px);
        }

        .btn-warning {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.3);
        }

        .btn-warning:hover {
            box-shadow: 0 6px 25px rgba(245, 158, 11, 0.5);
            transform: translateY(-2px);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
        }

        .btn-danger:hover {
            box-shadow: 0 6px 25px rgba(239, 68, 68, 0.5);
            transform: translateY(-2px);
        }

        .btn:active {
            transform: translateY(0) scale(0.95);
        }

        .persons-list {
            margin-top: 15px;
            max-height: 250px;
            overflow-y: auto;
        }

        .persons-list::-webkit-scrollbar {
            width: 6px;
        }

        .persons-list::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
        }

        .persons-list::-webkit-scrollbar-thumb {
            background: linear-gradient(180deg, #00d9ff 0%, #a855f7 100%);
            border-radius: 10px;
        }

        .person-item {
            background: rgba(10, 15, 35, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
            border-left: 3px solid #00d9ff;
            color: rgba(255, 255, 255, 0.9);
            position: relative;
            overflow: hidden;
        }

        .person-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(0, 217, 255, 0.1), transparent);
            transition: left 0.5s;
        }

        .person-item:hover::before {
            left: 100%;
        }

        .person-item:hover {
            border-color: #00d9ff;
            box-shadow:
                    0 8px 25px rgba(0, 217, 255, 0.2),
                    inset 0 0 20px rgba(0, 217, 255, 0.05);
            transform: translateX(8px);
            background: rgba(10, 15, 35, 0.8);
        }

        .console {
            background: rgba(5, 10, 20, 0.9);
            color: #00ff41;
            padding: 20px;
            border-radius: 12px;
            font-family: 'Fira Code', 'Courier New', monospace;
            max-height: 250px;
            overflow-y: auto;
            white-space: pre-wrap;
            font-size: 12px;
            box-shadow: inset 0 2px 10px rgba(0, 0, 0, 0.8);
            border: 1px solid rgba(0, 255, 65, 0.2);
            position: relative;
        }

        .console::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, #00ff41, transparent);
            animation: scanline 2s linear infinite;
        }

        @keyframes scanline {
            0% { top: 0; }
            100% { top: 100%; }
        }

        .console::-webkit-scrollbar {
            width: 6px;
        }

        .console::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.5);
            border-radius: 10px;
        }

        .console::-webkit-scrollbar-thumb {
            background: #00ff41;
            border-radius: 10px;
            box-shadow: 0 0 10px #00ff41;
        }

        footer {
            background: rgba(10, 15, 30, 0.8);
            color: rgba(255, 255, 255, 0.7);
            text-align: center;
            padding: 20px;
            margin-top: 20px;
            font-size: 0.9em;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
        }

        .status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 6px;
            font-size: 10px;
            margin: 2px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-success {
            background: rgba(16, 185, 129, 0.2);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.4);
            box-shadow: 0 0 10px rgba(16, 185, 129, 0.3);
        }

        .status-error {
            background: rgba(239, 68, 68, 0.2);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.4);
            box-shadow: 0 0 10px rgba(239, 68, 68, 0.3);
        }

        .form-group {
            margin-bottom: 15px;
        }

        @media (max-width: 768px) {
            .card {
                min-width: 100%;
            }

            header h1 {
                font-size: 1.8em;
            }

            body {
                padding: 10px;
            }

            .main-content {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <header>
        <h1>Gestion des Personnes - TP3</h1>
        <p>API REST JAX-RS </p>
    </header>

    <div class="main-content">
        <!-- Formulaire d'ajout -->
        <div class="card">
            <h2>Ajouter une personne</h2>
            <div class="form-group">
                <input type="text" id="nameInput" placeholder="Nom" required>
                <input type="number" id="ageInput" placeholder="Âge" required>
                <button onclick="addPerson()" class="btn btn-primary">Ajouter</button>
            </div>
        </div>

        <!-- Formulaire de recherche -->
        <div class="card">
            <h2>Rechercher</h2>
            <div class="form-group">
                <input type="text" id="searchId" placeholder="ID">
                <button onclick="getPersonById()" class="btn btn-info">Par ID</button>
            </div>
            <div class="form-group">
                <input type="text" id="searchName" placeholder="Nom">
                <button onclick="getPersonByName()" class="btn btn-info">Par Nom</button>
            </div>
        </div>

        <!-- Formulaire de mise à jour -->
        <div class="card">
            <h2>Mettre à jour</h2>
            <div class="form-group">
                <input type="number" id="updateId" placeholder="ID">
                <input type="text" id="updateName" placeholder="Nouveau nom">
                <input type="number" id="updateAge" placeholder="Nouvel âge">
                <button onclick="updatePerson()" class="btn btn-warning">Mettre à jour</button>
            </div>
        </div>

        <!-- Suppression -->
        <div class="card">
            <h2>Supprimer</h2>
            <div class="form-group">
                <input type="number" id="deleteId" placeholder="ID à supprimer">
                <button onclick="deletePerson()" class="btn btn-danger">Supprimer</button>
            </div>
        </div>

        <!-- Liste des personnes -->
        <div class="card" style="flex: 2;">
            <h2>Liste des personnes</h2>
            <button onclick="getAllPersons()" class="btn btn-secondary">Rafraîchir la liste</button>
            <div id="personsList" class="persons-list">
                Chargement...
            </div>
        </div>

        <!-- Console -->
        <div class="card" style="flex: 2;">
            <h2>Réponses API</h2>
            <div id="responseConsole" class="console">
                Démarrage...
            </div>
        </div>
    </div>

    <footer>
        <p id="baseUrl">Tomcat 8.0.53 | TP JAX-RS | URL: Chargement...</p>
    </footer>
</div>

<script>
    // URL de l'API pour Tomcat
    var API_URL = 'http://localhost:8080/testrest/rest/users';

    // Afficher l'URL
    document.getElementById('baseUrl').innerHTML =
        'Tomcat 8.0.53 | TP JAX-RS | URL: ' + API_URL;

    // Fonction pour logger
    function logResponse(method, endpoint, response, status) {
        var consoleDiv = document.getElementById('responseConsole');
        var timestamp = new Date().toLocaleTimeString();

        var statusClass = 'status-info';
        if (status >= 200 && status < 300) {
            statusClass = 'status-success';
        } else if (status >= 400) {
            statusClass = 'status-error';
        }

        var logEntry = '\n[' + timestamp + '] ' + method + ' ' + endpoint +
            '\nStatus: <span class="status ' + statusClass + '">' + status + '</span>' +
            '\nResponse: ' + JSON.stringify(response, null, 2) +
            '\n─────────────────────────────';

        consoleDiv.innerHTML = logEntry + consoleDiv.innerHTML;
    }

    // 1. Récupérer toutes les personnes
    function getAllPersons() {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', API_URL + '/affiche', true);

        xhr.onload = function() {
            if (xhr.status === 200) {
                var persons = JSON.parse(xhr.responseText);
                logResponse('GET', '/affiche', persons, xhr.status);

                var personsList = document.getElementById('personsList');
                if (persons && persons.length > 0) {
                    var html = '';
                    for (var i = 0; i < persons.length; i++) {
                        var p = persons[i];
                        html += '<div class="person-item">' +
                            'ID: ' + p.id + ' | Nom: ' + p.name + ' | Âge: ' + p.age +
                            '</div>';
                    }
                    personsList.innerHTML = html;
                } else {
                    personsList.innerHTML = 'Aucune personne enregistrée';
                }
            } else {
                logResponse('GET', '/affiche', {error: xhr.statusText}, xhr.status);
                alert('Erreur: ' + xhr.status);
            }
        };

        xhr.onerror = function() {
            logResponse('GET', '/affiche', {error: 'Network error'}, 0);
            alert('Erreur réseau');
        };

        xhr.send();
    }

    // 2. Ajouter une personne
    function addPerson() {
        var name = document.getElementById('nameInput').value.trim();
        var age = document.getElementById('ageInput').value;

        if (!name || !age) {
            alert('Veuillez remplir tous les champs');
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open('PUT', API_URL + '/add/' + age + '/' + encodeURIComponent(name), true);
        xhr.setRequestHeader('Accept', 'application/json');

        xhr.onload = function() {
            var result = JSON.parse(xhr.responseText);
            logResponse('PUT', '/add/' + age + '/' + name, result, xhr.status);

            if (result.state === 'ok') {
                document.getElementById('nameInput').value = '';
                document.getElementById('ageInput').value = '';
                getAllPersons();
                alert('Personne ajoutée avec succès!');
            } else {
                alert('Erreur: ' + result.message);
            }
        };

        xhr.onerror = function() {
            logResponse('PUT', '/add/' + age + '/' + name, {error: 'Network error'}, 0);
            alert('Erreur réseau');
        };

        xhr.send();
    }

    // 3. Rechercher par ID
    function getPersonById() {
        var id = document.getElementById('searchId').value.trim();

        if (!id) {
            alert('Veuillez entrer un ID');
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open('GET', API_URL + '/getid/' + id, true);

        xhr.onload = function() {
            var result = JSON.parse(xhr.responseText);
            logResponse('GET', '/getid/' + id, result, xhr.status);

            if (result.state === 'ok') {
                var person = result.data;
                alert('Personne trouvée:\nID: ' + person.id + '\nNom: ' + person.name + '\nÂge: ' + person.age);
            } else {
                alert('Personne non trouvée');
            }
        };

        xhr.onerror = function() {
            logResponse('GET', '/getid/' + id, {error: 'Network error'}, 0);
            alert('Erreur réseau');
        };

        xhr.send();
    }

    // 4. Rechercher par nom
    function getPersonByName() {
        var name = document.getElementById('searchName').value.trim();

        if (!name) {
            alert('Veuillez entrer un nom');
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open('GET', API_URL + '/getname/' + encodeURIComponent(name), true);

        xhr.onload = function() {
            var result = JSON.parse(xhr.responseText);
            logResponse('GET', '/getname/' + name, result, xhr.status);

            if (result.state === 'ok') {
                var person = result.data;
                alert('Personne trouvée:\nID: ' + person.id + '\nNom: ' + person.name + '\nÂge: ' + person.age);
            } else {
                alert('Personne non trouvée');
            }
        };

        xhr.onerror = function() {
            logResponse('GET', '/getname/' + name, {error: 'Network error'}, 0);
            alert('Erreur réseau');
        };

        xhr.send();
    }

    // 5. Mettre à jour
    function updatePerson() {
        var id = document.getElementById('updateId').value.trim();
        var name = document.getElementById('updateName').value.trim();
        var age = document.getElementById('updateAge').value;

        if (!id || !name || !age) {
            alert('Veuillez remplir tous les champs');
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open('PUT', API_URL + '/update/' + id + '/' + age + '/' + encodeURIComponent(name), true);
        xhr.setRequestHeader('Accept', 'application/json');

        xhr.onload = function() {
            var result = JSON.parse(xhr.responseText);
            logResponse('PUT', '/update/' + id + '/' + age + '/' + name, result, xhr.status);

            if (result.state === 'ok') {
                document.getElementById('updateId').value = '';
                document.getElementById('updateName').value = '';
                document.getElementById('updateAge').value = '';
                getAllPersons();
                alert('Personne mise à jour avec succès');
            } else {
                alert('Erreur: ' + result.message);
            }
        };

        xhr.onerror = function() {
            logResponse('PUT', '/update/' + id + '/' + age + '/' + name, {error: 'Network error'}, 0);
            alert('Erreur réseau');
        };

        xhr.send();
    }

    // 6. Supprimer
    function deletePerson() {
        var id = document.getElementById('deleteId').value.trim();

        if (!id) {
            alert('Veuillez entrer un ID');
            return;
        }

        if (!confirm('Supprimer la personne ID ' + id + ' ?')) {
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open('DELETE', API_URL + '/remove/' + id, true);
        xhr.setRequestHeader('Accept', 'application/json');

        xhr.onload = function() {
            var result = JSON.parse(xhr.responseText);
            logResponse('DELETE', '/remove/' + id, result, xhr.status);

            if (result.state === 'ok') {
                document.getElementById('deleteId').value = '';
                getAllPersons();
                alert('Personne supprimée avec succès');
            } else {
                alert('Erreur: ' + result.message);
            }
        };

        xhr.onerror = function() {
            logResponse('DELETE', '/remove/' + id, {error: 'Network error'}, 0);
            alert('Erreur réseau');
        };

        xhr.send();
    }

    // Charger au démarrage
    window.onload = function() {
        console.log('Tomcat 8.0.53 - Application démarrée');
        getAllPersons();
    };
</script>
</body>
</html>