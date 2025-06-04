const mysql = require('mysql2/promise');

const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: '12345',
  database: 'IrrigationSystem' // ← ¡CORRECTO! Con I mayúscula
};

async function testConnection() {
  try {
    const connection = await mysql.createConnection(dbConfig);
    console.log('✅ Conectado a la base de datos correctamente');
    await connection.end();
  } catch (error) {
    console.error('❌ Error al conectar a la base de datos:', error.message);
  }
}

testConnection();
