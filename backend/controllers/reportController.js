const Report = require('../models/reportModel');

function parseSymptoms(symptoms) {
  if (Array.isArray(symptoms)) {
    return symptoms.map((item) => String(item).trim()).filter((item) => item.length > 0);
  }

  if (typeof symptoms === 'string') {
    return symptoms
      .split(',')
      .map((item) => item.trim())
      .filter((item) => item.length > 0);
  }

  return [];
}

async function submitReport(req, res) {
  const {
    reportedBy,
    reportLocation,
    symptoms,
    foodSource,
    foodLocation,
    datasetId,
    exposureDistrict,
    exposureBarangay,
    exposureBarangayNo,
    caseCount,
    source,
    caseClassification,
    isCounted,
    excludeReason,
    reportedAt,
  } = req.body;

  const parsedSymptoms = parseSymptoms(symptoms);

  if (!reportedBy || !reportLocation || parsedSymptoms.length === 0 || !foodSource) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    const locationPayload = req.body.location || {};
    const locationName = locationPayload.name || reportLocation;
    const locationDistrict = locationPayload.district || reportLocation;
    const locationBarangay = locationPayload.barangay || null;
    const locationBarangayNo = locationPayload.barangayNo ?? null;

    const report = await Report.create({
      datasetId: datasetId || null,
      location: {
        name: locationName,
        district: locationDistrict,
        barangay: locationBarangay,
        barangayNo: locationBarangayNo,
        coordinates: {
          lat: locationPayload.coordinates?.lat ?? 0,
          lng: locationPayload.coordinates?.lng ?? 0,
        },
      },
      exposureDistrict: exposureDistrict || null,
      exposureBarangay: exposureBarangay || null,
      exposureBarangayNo: exposureBarangayNo || null,
      symptoms: parsedSymptoms,
      caseCount: caseCount || 1,
      foodSource,
      reportedAt: reportedAt ? new Date(reportedAt) : new Date(),
      reportedBy,
      source: source || 'citizen_app',
      caseClassification: caseClassification || 'suspected',
      isCounted: typeof isCounted === 'boolean' ? isCounted : true,
      excludeReason: excludeReason || null,
    });

    res.status(201).json(report);
  } catch (error) {
    console.error('Submit report error', error);
    res.status(500).json({ message: 'Failed to submit report' });
  }
}

async function getUserReports(req, res) {
  const { userId } = req.params;

  try {
    const reports = await Report.find({ reportedBy: userId }).sort({ reportedAt: -1 });

    const formattedReports = reports.map((report) => {
      const obj = report.toObject({ getters: true, versionKey: false });
      const location = obj.location || {};
      const reportLocation = location.name || location.district || 'Unknown';
      const exposureSite =
        obj.exposureDistrict || obj.exposureBarangay || location.name || 'Unknown';
      const symptomsValue = obj.symptoms;
      const symptomsString = Array.isArray(symptomsValue)
        ? symptomsValue.join(', ')
        : symptomsValue ?? '';

      return {
        ...obj,
        report_location: reportLocation,
        food_location: exposureSite,
        food_source: obj.foodSource ?? '',
        symptoms: symptomsString,
        reported_at: obj.reportedAt
          ? obj.reportedAt.toISOString()
          : obj.createdAt?.toISOString(),
      };
    });

    res.json(formattedReports);
  } catch (error) {
    console.error('Get reports error', error);
    res.status(500).json({ message: 'Failed to load reports' });
  }
}

async function getLastReport(req, res) {
  const { userId } = req.params;

  try {
    const latestReport = await Report.findOne({ reportedBy: userId }).sort({ reportedAt: -1 });
    res.json({ lastReportAt: latestReport ? latestReport.reportedAt : null });
  } catch (error) {
    console.error('Get last report error', error);
    res.status(500).json({ message: 'Failed to load last report' });
  }
}

module.exports = {
  submitReport,
  getUserReports,
  getLastReport,
};
