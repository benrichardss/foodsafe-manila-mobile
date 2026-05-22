const mongoose = require('mongoose');
const PredictionRun = require('../models/predictionRunModel');
const OfficialCase = require('../models/officialCaseModel');
const Dataset = require('../models/Dataset');

function toDatasetScope(datasetId) {
  if (datasetId && mongoose.Types.ObjectId.isValid(datasetId)) {
    return new mongoose.Types.ObjectId(datasetId);
  }
  return 'all';
}

async function getPredictions (req, res) {
  try {
    let datasetId = req.query.datasetId;
    if (!datasetId) {
      const latest = await Dataset.findOne({ status: "validated" })
        .sort({ createdAt: -1 })
        .select("_id")
        .lean();
      datasetId = latest?._id ? String(latest._id) : null;
    }

    const datasetScope = toDatasetScope(datasetId);
    const run = await PredictionRun.findOne({
      model: "prophet",
      granularity: "monthly_district_cases",
      datasetScope,
      status: "success",
    })
      .sort({ generatedAt: -1, createdAt: -1 })
      .select(
        "_id granularity basisDatasetId basisYear basisMonth forecastTargetYear forecastTargetMonth forecastHorizonMonths generatedAt trigger status payload",
      )
      .lean();

    if (!run) {
      return res.json({
        success: true,
        hasPrediction: false,
        message: "No saved monthly district prediction run found.",
      });
    }

    const districtFilter =
      req.query.districtKey || req.query.district ? String(req.query.districtKey || req.query.district) : null;
    const payload = run.payload || {};
    const districts = Array.isArray(payload.districts) ? payload.districts : [];
    const filtered =
      districtFilter && districts.length
        ? districts.filter(
            (d) => d.districtKey === districtFilter || d.district === districtFilter,
          )
        : districts;

    return res.json({
      success: true,
      hasPrediction: true,
      predictionRunId: String(run._id),
      granularity: run.granularity,
      basisDatasetId: run.basisDatasetId ? String(run.basisDatasetId) : null,
      basisYear: run.basisYear,
      basisMonth: run.basisMonth,
      forecastTargetYear: run.forecastTargetYear,
      forecastTargetMonth: run.forecastTargetMonth,
      forecastHorizonMonths: run.forecastHorizonMonths,
      generatedAt: run.generatedAt,
      trigger: run.trigger,
      status: run.status,
      payload: { ...payload, districts: filtered },
    });
  } catch (err) {
    return res.status(500).json({ message: err?.message || "Server error" });
  }
};

module.exports = {
  getPredictions
};