import { Router } from 'express';
import { verificarToken } from '../middlewares/auth.middleware.js';
import {
  validarCamposAlquiler,
  validarIdNumerico
} from '../middlewares/validar.middleware.js';
import {
  realizarAlquiler,
  historial,
  devolverVehiculo
} from '../controllers/alquilerController.js';

const router = Router();

router.post('/', verificarToken, validarCamposAlquiler, realizarAlquiler);
router.get('/historial', verificarToken, historial);
router.put('/devolver/:id', verificarToken, validarIdNumerico, devolverVehiculo);

export default router;
