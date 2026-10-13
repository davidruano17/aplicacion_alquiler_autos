import { Model, DataTypes } from 'sequelize';

export default (sequelize) => {
  class Auto extends Model {
    static associate(models) {
      // Un auto puede tener muchos alquileres a lo largo del tiempo
      Auto.hasMany(models.Alquiler, { foreignKey: 'autoId' });
    }
  }

  Auto.init({
    marca: DataTypes.STRING,
    modelo: DataTypes.STRING,
    imagen: DataTypes.STRING,
    valorAlquiler: DataTypes.FLOAT,
    anio: DataTypes.STRING,
    disponibilidad: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 1
    }
  }, {
    sequelize,
    modelName: 'Auto',
    tableName: 'autos' // sin esto Sequelize buscaria la tabla "Autos"
  });

  return Auto;
};
