const OfficialCase = require('../models/officialCaseModel');

exports.getAnalytics = async (req, res) => {
  try {
    const { year, month, caseClassification } = req.query;

    const match = {};

    if (year && year !== 'all') {
      match.year = parseInt(year);
    }

    if (month && month !== 'all') {
      match.month = parseInt(month);
    }

    if (caseClassification && caseClassification !== 'all') {
      match.caseClassification = caseClassification;
    }

    const globalMatch = {};

    const totalCasesAgg = await OfficialCase.aggregate([
      { $match: globalMatch },
      {
        $group: {
          _id: null,
          totalCases: { $sum: '$cases' },
        },
      },
    ]);

    const totalCases =
        totalCasesAgg.length > 0 ? totalCasesAgg[0].totalCases : 0;

    const topDistrictAgg = await OfficialCase.aggregate([
      { $match: globalMatch },
      {
        $group: {
          _id: '$district',
          total: { $sum: '$cases' },
        },
      },
      { $sort: { total: -1 } },
      { $limit: 1 },
    ]);

    const topDistrict =
        topDistrictAgg.length > 0 ? topDistrictAgg[0]._id : 'N/A';

    const baseYear = (year && year !== 'all')
      ? parseInt(year)
      : new Date().getFullYear();

    const currentYearAgg = await OfficialCase.aggregate([
      {
        $match: {
          year: baseYear
        }
      },
      {
        $group: {
          _id: null,
          total: { $sum: "$cases" }
        }
      }
    ]);

    const currentYearTotal = currentYearAgg[0]?.total || 0;

    const previousYearAgg = await OfficialCase.aggregate([
      {
        $match: {
          year: baseYear - 1
        }
      },
      {
        $group: {
          _id: null,
          total: { $sum: "$cases" }
        }
      }
    ]);

    const previousYearTotal = previousYearAgg[0]?.total || 0;

    let growth = 0;

    if (previousYearTotal > 0) {
      growth =
        ((currentYearTotal - previousYearTotal) / previousYearTotal) * 100;
    }

    const topDiseaseAgg = await OfficialCase.aggregate([
      { $match: globalMatch },
      {
        $group: {
          _id: '$disease',
          total: { $sum: '$cases' },
        },
      },
      { $sort: { total: -1 } },
      { $limit: 1 },
    ]);

    const topDisease =
        topDiseaseAgg.length > 0 ? topDiseaseAgg[0]._id : 'N/A';

    const districtData = await OfficialCase.aggregate([
      { $match: match },
      {
        $group: {
          _id: '$district',
          total: { $sum: '$cases' },
        },
      },
      { $sort: { _id: 1 } },
    ]);

    const diseaseDistribution = await OfficialCase.aggregate([
      { $match: match },
      {
        $group: {
          _id: '$disease',
          total: { $sum: '$cases' },
        },
      },
      { $sort: { total: -1 } },
      { $limit: 7 },
    ]);

    let trendGroup = {};
    let trendSort = {};

    if (!year || year === 'all') {
      // all years = totals per year
      trendGroup = {
        _id: '$year',
        total: { $sum: '$cases' },
      };

      trendSort = { _id: 1 };
    } else {
      // specific year = totals per month
      trendGroup = {
        _id: '$month',
        total: { $sum: '$cases' },
      };

      trendSort = { _id: 1 };
    }

    const trendData = await OfficialCase.aggregate([
      { $match: match },
      {
        $group: trendGroup,
      },
      { $sort: trendSort },
    ]);

    res.json({
      totalCases,
      topDistrict,
      topDisease,
      districtData,
      diseaseDistribution,
      trendData,
      growth: growth.toFixed(1),
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};