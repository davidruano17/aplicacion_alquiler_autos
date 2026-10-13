import { Router } from 'express';
import { verificarToken } from '../middlewares/auth.middleware.js';
import {
  validarCamposCliente,
  validarCredenciales
} from '../middlewares/validar.middleware.js';
import {
  registrarCliente,
  loginCliente,
  perfilCliente
} from '../controllers/clienteController.js';

const router = Router();

router.post('/registro', validarCamposCliente, registrarCliente);
router.post('/login', validarCredenciales, loginCliente);
router.get('/perfil', verificarToken, perfilCliente);

export default router;
