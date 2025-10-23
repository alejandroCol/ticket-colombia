const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Servir archivos estáticos desde build/web
app.use(express.static(path.join(__dirname, 'build/web')));

// Manejar todas las rutas y devolver index.html (para Flutter routing)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build/web', 'index.html'));
});

app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 Frontend running on port ${port}`);
  console.log(`📱 Access at http://localhost:${port}`);
});

