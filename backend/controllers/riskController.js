const OfficialCase = require('../models/officialCaseModel');
const Report = require('../models/reportModel');
const {
  computeRiskScore,
  riskLevelFromScore,
  riskLabel,
} = require('../utils/riskUtils');

function monthsAgoDate(months) {
  const d = new Date();
  d.setMonth(d.getMonth() - months);
  return d;
}

async function aggregateOfficialByBarangay(since) {
  const match = { barangayNo: { $ne: null } };
  if (since) {
    const startYear = since.getFullYear();
    const startMonth = since.getMonth() + 1;
    match.$or = [
      { year: { $gt: startYear } },
      { year: startYear, month: { $gte: startMonth } },
    ];
  }
  return OfficialCase.aggregate([
    { $match: match },
    {
      $group: {
        _id: {
          barangayNo: '$barangayNo',
          barangay: '$barangay',
          district: '$district',
        },
        officialCases: { $sum: '$cases' },
      },
    },
  ]);
}

async function aggregateReportsByBarangay(since) {
  const match = {
    isCounted: true,
    $or: [
      { 'location.barangayNo': { $ne: null } },
      { exposureBarangayNo: { $ne: null } },
    ],
  };
  if (since) match.reportedAt = { $gte: since };

  return Report.aggregate([
    { $match: match },
    {
      $group: {
        _id: {
          barangayNo: {
            $ifNull: ['$exposureBarangayNo', '$location.barangayNo'],
          },
          barangay: {
            $ifNull: ['$exposureBarangay', '$location.barangay'],
          },
          district: {
            $ifNull: ['$exposureDistrict', '$location.district'],
          },
        },
        suspectedCases: { $sum: '$caseCount' },
      },
    },
  ]);
}

function mergeAreaRows(officialRows, reportRows) {
  const map = new Map();

  for (const row of officialRows) {
    const id = row._id;
    const key = String(id.barangayNo);
    map.set(key, {
      barangayNo: id.barangayNo,
      barangay: id.barangay,
      district: id.district,
      officialCases: row.officialCases,
      suspectedCases: 0,
    });
  }

  for (const row of reportRows) {
    const id = row._id;
    const key = String(id.barangayNo);
    const existing = map.get(key) || {
      barangayNo: id.barangayNo,
      barangay: id.barangay,
      district: id.district,
      officialCases: 0,
      suspectedCases: 0,
    };
    existing.suspectedCases += row.suspectedCases;
    if (!existing.barangay && id.barangay) existing.barangay = id.barangay;
    if (!existing.district && id.district) existing.district = id.district;
    map.set(key, existing);
  }

  return [...map.values()].map((area) => {
    const riskScore = computeRiskScore(area.officialCases, area.suspectedCases);
    const riskLevel = riskLevelFromScore(riskScore);
    return {
      ...area,
      totalCases: area.officialCases + area.suspectedCases,
      riskScore,
      riskLevel,
      riskLabel: riskLabel(riskLevel),
      classification: {
        official: area.officialCases,
        suspected: area.suspectedCases,
      },
    };
  });
}

exports.getHeatmap = async (req, res) => {
  try {
    const months = Math.min(24, Math.max(1, parseInt(req.query.months, 10) || 12));
    const since = monthsAgoDate(months);

    const [officialRows, reportRows] = await Promise.all([
      aggregateOfficialByBarangay(since),
      aggregateReportsByBarangay(since),
    ]);

    const areas = mergeAreaRows(officialRows, reportRows);

    const summary = {
      high: areas.filter((a) => a.riskLevel === 'high').length,
      moderate: areas.filter((a) => a.riskLevel === 'moderate').length,
      low: areas.filter((a) => a.riskLevel === 'low').length,
    };

    res.json({ success: true, months, areas, summary });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

exports.getNearbyRisk = async (req, res) => {
  try {
    const lat = parseFloat(req.query.lat);
    const lng = parseFloat(req.query.lng);
    const barangayNo = parseInt(req.query.barangayNo, 10);

    if (!barangayNo && (Number.isNaN(lat) || Number.isNaN(lng))) {
      return res.status(400).json({ message: 'barangayNo or lat/lng required' });
    }

    const months = Math.min(24, Math.max(1, parseInt(req.query.months, 10) || 6));
    const since = monthsAgoDate(months);

    const [officialRows, reportRows] = await Promise.all([
      aggregateOfficialByBarangay(since),
      aggregateReportsByBarangay(since),
    ]);

    const areas = mergeAreaRows(officialRows, reportRows);

    let area = null;
    if (barangayNo) {
      area = areas.find((a) => a.barangayNo === barangayNo) || null;
    }

    const alerts = areas
      .filter((a) => a.riskLevel === 'high')
      .sort((a, b) => b.riskScore - a.riskScore)
      .slice(0, 10);

    res.json({
      success: true,
      area,
      isHighRisk: area?.riskLevel === 'high',
      highRiskAreas: alerts,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};
