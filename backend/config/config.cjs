require('dotenv').config();

const comun = {
  use_env_variable: 'DATABASE_URL',
  dialect: 'postgres',
  dialectOptions: {
    ssl: { require: true, rejectUnauthorized: false } // Neon exige SSL
  },
  logging: false
};

module.exports = {
  development: comun,
  test: comun,
  production: comun
};
