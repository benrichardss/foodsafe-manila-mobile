const express = require('express');
const cors = require('cors');
const { connectDb } = require('./models/db');
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const reportRoutes = require('./routes/reports');
const officialCaseRoutes = require('./routes/officialCase');
const predictionRoutes = require('./routes/predictionRoutes');
const riskRoutes = require('./routes/riskRoutes');
const dashboardRoutes = require('./routes/dashboardRoutes');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/reports', reportRoutes);
app.use('/api/official-cases', officialCaseRoutes);
app.use('/api/predictions', predictionRoutes);
app.use('/api/risk', riskRoutes);
app.use('/api/dashboard', dashboardRoutes);

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok' });
});

const port = process.env.PORT || 3000;

connectDb()
  .then(() => {
    console.log('Connected to MongoDB');
    app.listen(port, '0.0.0.0', () => {
      console.log(`Server listening on port ${port}`);
    });
  })
  .catch((error) => {
    console.error('Failed to connect to MongoDB', error);
    process.exit(1);
  });
