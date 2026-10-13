import { Auto } from '../models/index.js';

// Arriba del archivo, debajo del import
const CAMPOS_EDITABLES = ['marca', 'modelo', 'imagen', 'valorAlquiler', 'anio'];

// POST /api/autos (protegida)
export async function crearAuto(req, res, next) {
  try {
    const { marca, modelo, imagen, valorAlquiler, anio } = req.body;
    const auto = await Auto.create({ marca, modelo, imagen, valorAlquiler, anio });
    res.status(201).json(auto);
  } catch (error) {
    next(error);
  }
}

// GET /api/autos
export async function listarAutos(req, res, next) {
  try {
    const autos = await Auto.findAll();
    res.status(200).json(autos);
  } catch (error) {
    next(error);
  }
}

// GET /api/autos/disponibles
export async function listarDisponibles(req, res, next) {
  try {
    const autos = await Auto.findAll({ where: { disponibilidad: 1 } });
    res.status(200).json(autos);
  } catch (error) {
    next(error);
  }
}

// GET /api/autos/:id
export async function obtenerAuto(req, res, next) {
  try {
    const auto = await Auto.findByPk(req.params.id);
    if (!auto) {
      return res.status(404).json({ mensaje: 'Auto no encontrado' });
    }
    res.status(200).json(auto);
  } catch (error) {
    next(error);
  }
}

// PUT /api/autos/:id (protegida)
export async function actualizarAuto(req, res, next) {
  try {
    const auto = await Auto.findByPk(req.params.id);
    if (!auto) {
      return res.status(404).json({ mensaje: 'Auto no encontrado' });
    }
    await auto.update(req.body, { fields: CAMPOS_EDITABLES });
    res.status(200).json(auto);
  } catch (error) {
    next(error);
  }
}

// DELETE /api/autos/:id (protegida)
export async function eliminarAuto(req, res, next) {
  try {
    const auto = await Auto.findByPk(req.params.id);
    if (!auto) {
      return res.status(404).json({ mensaje: 'Auto no encontrado' });
    }
    // Baja logica: preserva el historial en la tabla alquiler
    await auto.update({ disponibilidad: 0 });
    res.status(200).json({ mensaje: 'Auto dado de baja', auto });
  } catch (error) {
    next(error);
  }
}
