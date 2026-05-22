function computeRiskScore(officialCases, suspectedCases) {
  const raw = officialCases * 1.0 + suspectedCases * 0.65;
  if (raw <= 0) return 0;
  // Log-scale normalization; 50 combined weighted cases ≈ high risk
  const score = Math.min(100, Math.round((Math.log1p(raw) / Math.log1p(50)) * 100));
  return score;
}

function riskLevelFromScore(score) {
  if (score >= 70) return 'high';
  if (score >= 35) return 'moderate';
  return 'low';
}

function riskLabel(level) {
  if (level === 'high') return 'High Risk';
  if (level === 'moderate') return 'Moderate Risk';
  return 'Low Risk';
}

module.exports = {
  computeRiskScore,
  riskLevelFromScore,
  riskLabel,
};
