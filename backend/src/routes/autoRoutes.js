import { Router } from 'express';
import { verificarToken } from '../middlewares/auth.middleware.js';
import {
  validarCamposAuto,
  validarIdNumerico
} from '../middlewares/validar.middleware.js';
import {
  crearAuto,
  listarAutos,
  listarDisponibles,
  obtenerAuto,
  actualizarAuto,
  eliminarAuto
} from '../controllers/autoController.js';

const router = Router();

// Las rutas fijas van SIEMPRE antes que las que llevan parametro
router.get('/disponibles', listarDisponibles);
router.post('/', verificarToken, validarCamposAuto, crearAuto);
router.get('/', listarAutos);
router.get('/:id', validarIdNumerico, obtenerAuto);
router.put('/:id', verificarToken, validarIdNumerico, actualizarAuto);
router.delete('/:id', verificarToken, validarIdNumerico, eliminarAuto);

export default router;
