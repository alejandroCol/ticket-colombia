const express = require('express');
const path = require('path');
const fs = require('fs');
const app = express();
const port = process.env.PORT || 3000;

// Debug: Verificar que el directorio build/web existe
const buildPath = path.join(__dirname, 'build/web');
console.log('🔍 Checking build directory:', buildPath);
console.log('📁 Build directory exists:', fs.existsSync(buildPath));

if (!fs.existsSync(buildPath)) {
  console.error('❌ ERROR: build/web directory not found!');
  console.log('📂 Current directory contents:', fs.readdirSync(__dirname));
  process.exit(1);
}

// Servir archivos estáticos desde build/web
app.use(express.static(buildPath));

// Manejar todas las rutas y devolver index.html (para Flutter routing)
app.get('*', (req, res) => {
  res.sendFile(path.join(buildPath, 'index.html'));
});

const server = app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 Frontend running on port ${port}`);
  console.log(`📱 Server is ready!`);
  console.log(`🌐 Listening on 0.0.0.0:${port}`);
});

server.on('error', (error) => {
  console.error('❌ Server error:', error);
  process.exit(1);
});

