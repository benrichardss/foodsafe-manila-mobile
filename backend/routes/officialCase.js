const express = require('express');
const router = express.Router();
const officialCaseController = require('../controllers/officialCaseController');

router.get('/analytics', officialCaseController.getAnalytics);

module.exports = router;