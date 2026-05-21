const express = require('express');
const {
  submitReport,
  getUserReports,
  getLastReport,
} = require('../controllers/reportController');

const router = express.Router();

router.post('/', submitReport);
router.get('/user/:userId', getUserReports);
router.get('/user/:userId/last', getLastReport);

module.exports = router;
