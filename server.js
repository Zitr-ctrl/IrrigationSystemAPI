const express = require('express');
const mysql = require('mysql2/promise');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Configuración conexión MySQL
const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: '12345',
  database: 'irrigationsystem',
  port: 3308
};

// Probar conexión inicial a la base de datos al arrancar el servidor
async function testDatabaseConnection() {
  try {
    const connection = await mysql.createConnection(dbConfig);
    console.log('✅ Conexión exitosa a la base de datos MySQL');
    await connection.end();
  } catch (error) {
    console.error('❌ Error al conectar con la base de datos:', error);
    process.exit(1); // Detiene el servidor si no hay conexión
  }
}

// Ruta para insertar lectura de sensor
app.post('/api/insertar_lectura', async (req, res) => {
  const { sensor_id, valor, unidad } = req.body;

  if (!sensor_id || !valor || !unidad) {
    return res.status(400).json({ error: 'Faltan datos en la solicitud' });
  }

  try {
    const connection = await mysql.createConnection(dbConfig);

    const query = 'INSERT INTO lectura_sensor (sensor_id, valor, unidad) VALUES (?, ?, ?)';
    const [result] = await connection.execute(query, [sensor_id, valor, unidad]);

    await connection.end();

    res.json({ message: 'Lectura insertada correctamente', insertId: result.insertId });
  } catch (error) {
    console.error('Error al insertar lectura:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Iniciar servidor y verificar conexión
app.listen(port, async () => {
  await testDatabaseConnection();
  console.log(`🚀 API corriendo en http://localhost:${port}`);
});
