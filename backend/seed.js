import 'dotenv/config';
import { sequelize, Auto } from './src/models/index.js';

const autosIniciales = [
  { marca: 'Toyota', modelo: 'Corolla', anio: '2022', valorAlquiler: 99.99, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=600' },
  { marca: 'Nissan', modelo: 'Sentra', anio: '2021', valorAlquiler: 89.99, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?w=600' },
  { marca: 'Ford', modelo: 'Mustang', anio: '2023', valorAlquiler: 199.99, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1584345604476-8ec5e12e42dd?w=600' },
  { marca: 'Chevrolet', modelo: 'Camaro', anio: '2020', valorAlquiler: 150.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=600' },
  { marca: 'Chevrolet', modelo: 'Cruze', anio: '2018', valorAlquiler: 75.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=600' },
  { marca: 'Mazda', modelo: 'CX-30', anio: '2023', valorAlquiler: 120.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=600' },
  { marca: 'Renault', modelo: 'Duster', anio: '2022', valorAlquiler: 85.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=600' },
  { marca: 'Hyundai', modelo: 'Tucson', anio: '2023', valorAlquiler: 110.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=600' },
  { marca: 'Kia', modelo: 'Sportage', anio: '2022', valorAlquiler: 105.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?w=600' },
  { marca: 'Volkswagen', modelo: 'Golf', anio: '2021', valorAlquiler: 95.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=600' },
  { marca: 'Honda', modelo: 'Civic', anio: '2022', valorAlquiler: 90.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1590362891988-f77804703080?w=600' },
  { marca: 'BMW', modelo: 'Serie 3', anio: '2023', valorAlquiler: 210.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=600' },
  { marca: 'Mercedes-Benz', modelo: 'Clase C', anio: '2022', valorAlquiler: 230.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=600' },
  { marca: 'Audi', modelo: 'A4', anio: '2023', valorAlquiler: 220.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=600' },
  { marca: 'Jeep', modelo: 'Wrangler', anio: '2021', valorAlquiler: 180.00, disponibilidad: 1, imagen: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=600' }
];

async function seed() {
  try {
    await sequelize.authenticate();
    await sequelize.sync();

    const count = await Auto.count();
    if (count === 0) {
      await Auto.bulkCreate(autosIniciales);
      console.log(`Exito: Se insertaron ${autosIniciales.length} autos de prueba.`);
    } else {
      console.log(`La base de datos ya contiene ${count} autos.`);
    }
    process.exit(0);
  } catch (err) {
    console.error('Error en seed:', err);
    process.exit(1);
  }
}

seed();
