const mongoose = require('mongoose');

const officialCaseSchema = new mongoose.Schema(
  {
    city: { type: String, default: 'Manila' },
    district: {
      type: String,
      enum: [
        'District 1',
        'District 2',
        'District 3',
        'District 4',
        'District 5',
        'District 6',
      ],
      required: true,
      trim: true,
      index: true,
    },
    barangay: { type: String, trim: true, default: null },
    barangayNo: { type: Number, min: 1, max: 999, default: null },
    disease: { type: String, required: true, trim: true },
    year: { type: Number, required: true, min: 2015, max: 2100 },
    month: { type: Number, required: true, min: 1, max: 12 },
    caseClassification: {
      type: String,
      enum: ['confirmed', 'suspected', 'probable'],
      required: true,
      trim: true,
      index: true,
    },
    cases: { type: Number, required: true, min: 0 },
    source: {
      type: String,
      enum: ['official', 'csv', 'excel', 'system', 'file'],
      default: 'official',
    },
  },
  { timestamps: true }
);

officialCaseSchema.index({ year: 1, month: 1 });
officialCaseSchema.index({ district: 1, year: 1, month: 1 });
officialCaseSchema.index({ disease: 1, year: 1, month: 1 });
officialCaseSchema.index({ caseClassification: 1, year: 1, month: 1 });

module.exports = mongoose.model('OfficialCase', officialCaseSchema);
