import { Alquiler, Auto } from '../models/index.js';

// POST /api/alquiler (protegida)
export async function realizarAlquiler(req, res, next) {
  try {
    const { autoId, fechaInicio, fechaFin } = req.body;
    // clienteId sale del token verificado, NUNCA del body
    const clienteId = req.cliente.id;
    const auto = await Auto.findByPk(autoId);
    if (!auto) {
      return res.status(404).json({ mensaje: 'Auto no encontrado' });
    }
    if (auto.disponibilidad === 0) {
      return res.status(400).json({ mensaje: 'Este auto no esta disponible' });
    }
    const alquiler = await Alquiler.create({
      clienteId,
      autoId,
      fechaInicio,
      fechaFin
    });
    await auto.update({ disponibilidad: 0 }); // se marca como ocupado
    res.status(201).json(alquiler);
  } catch (error) {
    next(error);
  }
}

// GET /api/alquiler/historial (protegida)
export async function historial(req, res, next) {
  try {
    const alquileres = await Alquiler.findAll({
      where: { clienteId: req.cliente.id }, // cada cliente ve solo lo suyo
      include: [Auto] // un solo JOIN
    });
    res.status(200).json(alquileres);
  } catch (error) {
    next(error);
  }
}

// PUT /api/alquiler/devolver/:id (protegida)
export async function devolverVehiculo(req, res, next) {
  try {
    const alquiler = await Alquiler.findByPk(req.params.id);
    if (!alquiler) {
      return res.status(404).json({ mensaje: 'Alquiler no encontrado' });
    }
    if (alquiler.clienteId !== req.cliente.id) {
      return res.status(403).json({ mensaje: 'Este alquiler no te pertenece' });
    }
    if (alquiler.estado === 'finalizado') {
      return res.status(400).json({ mensaje: 'Este alquiler ya fue finalizado' });
    }
    // Las dos operaciones van juntas
    await alquiler.update({ estado: 'finalizado' });
    await Auto.update(
      { disponibilidad: 1 },
      { where: { id: alquiler.autoId } }
    );
    res.status(200).json({ mensaje: 'Vehiculo devuelto', alquiler });
  } catch (error) {
    next(error);
  }
}
