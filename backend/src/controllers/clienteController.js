import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import { Cliente } from '../models/index.js';

// POST /api/clientes/registro
export async function registrarCliente(req, res, next) {
  try {
    const { nombre, correo, numLic, password } = req.body;
    // La contrasena sale hasheada sola gracias al hook beforeCreate
    const cliente = await Cliente.create({ nombre, correo, numLic, password });
    res.status(201).json({
      id: cliente.id,
      nombre: cliente.nombre,
      correo: cliente.correo
    });
  } catch (error) {
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(409).json({ mensaje: 'Ese correo ya esta registrado' });
    }
    next(error);
  }
}

// POST /api/clientes/login
export async function loginCliente(req, res, next) {
  try {
    const { correo, password } = req.body;
    const cliente = await Cliente.findOne({ where: { correo } });
    if (!cliente) {
      return res.status(404).json({ mensaje: 'Cliente no encontrado' });
    }
    // No se desencripta el hash: se vuelve a hashear y se comparan
    const passwordValida = await bcrypt.compare(password, cliente.password);
    if (!passwordValida) {
      return res.status(401).json({ mensaje: 'Contrasena incorrecta' });
    }
    const token = jwt.sign(
      { id: cliente.id, correo: cliente.correo },
      process.env.JWT_SECRET,
      { expiresIn: '2h' }
    );
    res.status(200).json({ mensaje: 'Login exitoso', token });
  } catch (error) {
    next(error);
  }
}

// GET /api/clientes/perfil (protegida)
export async function perfilCliente(req, res, next) {
  try {
    const cliente = await Cliente.findByPk(req.cliente.id, {
      attributes: ['id', 'nombre', 'correo', 'numLic'] // nunca password
    });
    if (!cliente) {
      return res.status(404).json({ mensaje: 'Cliente no encontrado' });
    }
    res.status(200).json(cliente);
  } catch (error) {
    next(error);
  }
}
