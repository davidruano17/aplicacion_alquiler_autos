import express from 'express';
import cors from 'cors';
import clienteRoutes from './routes/clienteRoutes.js';
import autoRoutes from './routes/autoRoutes.js';
import alquilerRoutes from './routes/alquilerRoutes.js';
import { manejadorErrores } from './middlewares/error.middleware.js';

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.status(200).json({
    mensaje: 'API de Alquiler de Autos funcionando correctamente'
  });
});

app.use('/api/clientes', clienteRoutes);
app.use('/api/autos', autoRoutes);
app.use('/api/alquiler', alquilerRoutes);

app.use((req, res) => {
  res.status(404).json({ mensaje: 'Ruta no encontrada' });
});

app.use(manejadorErrores);

export default app;
