const mongoose = require('mongoose');

const predictionRunSchema = new mongoose.Schema(
  {
    model: {
      type: String,
      enum: ['prophet'],
      default: 'prophet',
      required: true,
      index: true,
    },

    granularity: {
      type: String,
      enum: ['yearly_total_cases', 'monthly_district_cases'],
      required: true,
      index: true,
    },

    datasetScope: {
      type: mongoose.Schema.Types.Mixed,
      required: true,
      default: 'all',
      index: true,
      // Can be "all" or a Dataset ObjectId
    },

    trigger: {
      type: String,
      enum: ['official_upload', 'monthly_fallback', 'manual'],
      required: true,
      index: true,
    },

    startedAt: {
      type: Date,
      default: null,
      index: true,
    },

    finishedAt: {
      type: Date,
      default: null,
      index: true,
    },

    generatedAt: {
      type: Date,
      default: Date.now,
      index: true,
    },

    payload: {
      type: mongoose.Schema.Types.Mixed,
      default: null,
    },

    status: {
      type: String,
      enum: ['success', 'failed', 'running'],
      default: 'running',
      required: true,
      index: true,
    },

    errorMessage: {
      type: String,
      default: null,
    },

    basisDatasetId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Dataset',
      default: null,
      index: true,
    },

    basisYear: {
      type: Number,
      default: null,
      min: 2015,
      max: 2100,
      index: true,
    },

    basisMonth: {
      type: Number,
      default: null,
      min: 1,
      max: 12,
    },

    forecastStartYear: {
      type: Number,
      default: null,
      min: 2015,
      max: 2100,
      index: true,
    },

    forecastEndYear: {
      type: Number,
      default: null,
      min: 2015,
      max: 2100,
      index: true,
    },

    forecastTargetYear: {
      type: Number,
      default: null,
      min: 2015,
      max: 2100,
      index: true,
    },

    forecastTargetMonth: {
      type: Number,
      default: null,
      min: 1,
      max: 12,
      index: true,
    },

    forecastHorizonMonths: {
      type: Number,
      default: null,
      min: 1,
      max: 36,
    },
  },
  { timestamps: true }
);

// indexes
predictionRunSchema.index({
  model: 1,
  granularity: 1,
  datasetScope: 1,
  generatedAt: -1,
});

predictionRunSchema.index({
  basisDatasetId: 1,
  basisYear: 1,
  generatedAt: -1,
});

module.exports = mongoose.model('PredictionRun', predictionRunSchema);