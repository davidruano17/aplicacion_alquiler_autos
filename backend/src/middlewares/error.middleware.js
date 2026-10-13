export function manejadorErrores(err, req, res, next) {
  // El detalle completo se queda en los logs del servidor
  console.error(err.stack);
  const status = err.status || 500;
  const mensaje = err.message || 'Error interno del servidor';
  res.status(status).json({ mensaje });
}
