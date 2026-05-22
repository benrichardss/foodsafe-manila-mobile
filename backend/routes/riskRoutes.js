const express = require('express');
const riskController = require('../controllers/riskController');

const router = express.Router();

router.get('/heatmap', riskController.getHeatmap);
router.get('/nearby', riskController.getNearbyRisk);

module.exports = router;
