const OfficialCase = require('../models/officialCaseModel');
const Report = require('../models/reportModel');
const {
  computeRiskScore,
  riskLevelFromScore,
} = require('../utils/riskUtils');

exports.getDashboard = async (req, res) => {
  try {
    const year = new Date().getFullYear();

    const [totalCasesAgg, topDistrictAgg, topDiseaseAgg, reportCountAgg] =
      await Promise.all([
        OfficialCase.aggregate([
          { $match: { year } },
          { $group: { _id: null, total: { $sum: '$cases' } } },
        ]),
        OfficialCase.aggregate([
          { $match: { year } },
          { $group: { _id: '$district', total: { $sum: '$cases' } } },
          { $sort: { total: -1 } },
          { $limit: 1 },
        ]),
        OfficialCase.aggregate([
          { $match: { year } },
          { $group: { _id: '$disease', total: { $sum: '$cases' } } },
          { $sort: { total: -1 } },
          { $limit: 1 },
        ]),
        Report.aggregate([
          {
            $match: {
              isCounted: true,
              reportedAt: {
                $gte: new Date(year, 0, 1),
              },
            },
          },
          { $group: { _id: null, total: { $sum: '$caseCount' } } },
        ]),
      ]);

    const officialByDistrict = await OfficialCase.aggregate([
      { $match: { year } },
      { $group: { _id: '$district', total: { $sum: '$cases' } } },
    ]);

    const reportsByDistrict = await Report.aggregate([
      {
        $match: {
          isCounted: true,
          reportedAt: { $gte: new Date(year, 0, 1) },
        },
      },
      {
        $group: {
          _id: { $ifNull: ['$exposureDistrict', '$location.district'] },
          total: { $sum: '$caseCount' },
        },
      },
    ]);

    const districtRisk = new Map();
    for (const row of officialByDistrict) {
      districtRisk.set(row._id, {
        district: row._id,
        official: row.total,
        suspected: 0,
      });
    }
    for (const row of reportsByDistrict) {
      const key = row._id;
      if (!key) continue;
      const existing = districtRisk.get(key) || {
        district: key,
        official: 0,
        suspected: 0,
      };
      existing.suspected = row.total;
      districtRisk.set(key, existing);
    }

    let highRiskDistricts = 0;
    let moderateRiskDistricts = 0;
    let lowRiskDistricts = 0;

    for (const entry of districtRisk.values()) {
      const score = computeRiskScore(entry.official, entry.suspected);
      const level = riskLevelFromScore(score);
      if (level === 'high') highRiskDistricts += 1;
      else if (level === 'moderate') moderateRiskDistricts += 1;
      else lowRiskDistricts += 1;
    }

    const currentYearAgg = await OfficialCase.aggregate([
      { $match: { year } },
      { $group: { _id: null, total: { $sum: '$cases' } } },
    ]);
    const previousYearAgg = await OfficialCase.aggregate([
      { $match: { year: year - 1 } },
      { $group: { _id: null, total: { $sum: '$cases' } } },
    ]);

    const currentYearTotal = currentYearAgg[0]?.total || 0;
    const previousYearTotal = previousYearAgg[0]?.total || 0;
    let growth = 0;
    if (previousYearTotal > 0) {
      growth =
        ((currentYearTotal - previousYearTotal) / previousYearTotal) * 100;
    }

    res.json({
      totalCases: totalCasesAgg[0]?.total || 0,
      suspectedReports: reportCountAgg[0]?.total || 0,
      topDistrict: topDistrictAgg[0]?._id || 'N/A',
      topDisease: topDiseaseAgg[0]?._id || 'N/A',
      growth: growth.toFixed(1),
      highRiskDistricts,
      moderateRiskDistricts,
      lowRiskDistricts,
      year,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};
