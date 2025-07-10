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
  database: 'irrigationsystem2',
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

// Nueva ruta: insertar registro completo con lecturas
app.post('/api/insertar_registro_completo', async (req, res) => {
  const { bomba, lecturas } = req.body;

  if (!bomba || !Array.isArray(lecturas) || lecturas.length === 0) {
    return res.status(400).json({ error: 'Datos incompletos' });
  }

  let connection;
  try {
    connection = await mysql.createConnection(dbConfig);
    await connection.beginTransaction();

    // ✅ Inserta solo el estado de la bomba
    const [registroResult] = await connection.execute(
      'INSERT INTO registro_riego (bomba_estado) VALUES (?)',
      [bomba]
    );

    const registroId = registroResult.insertId;

    // ✅ Inserta lecturas relacionadas al registro creado
    for (const lectura of lecturas) {
      const { sensor_id, valor, unidad } = lectura;
      await connection.execute(
        'INSERT INTO lectura_sensor (sensor_id, registro_id, valor, unidad) VALUES (?, ?, ?, ?)',
        [sensor_id, registroId, valor, unidad]
      );
    }

    await connection.commit();
    await connection.end();

    res.json({ message: 'Registro completo insertado correctamente', registroId });
  } catch (error) {
    if (connection) await connection.rollback();
    console.error('Error al insertar registro:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});


// Ruta que devuelve solo un array de números
app.get('/api/humedad_minima', async (req, res) => {
  let connection;
  try {
    // Crear conexión local
    connection = await mysql.createConnection(dbConfig);

    const [rows] = await connection.execute(
      'SELECT humedad_minima FROM maceta ORDER BY id ASC'
    );

    const valores = rows.map(r => parseFloat(r.humedad_minima));
    res.json(valores);

    await connection.end();
  } catch (error) {
    console.error('Error al obtener humedad mínima:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});


// Iniciar servidor y verificar conexión
app.listen(port, async () => {
  await testDatabaseConnection();
  console.log(`🚀 API corriendo en http://localhost:${port}`);
});
