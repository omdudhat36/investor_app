import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/deal_model.dart';

class DealRepository {
  static const String _interestsKey = 'interested_deals';

  final List<Deal> _mockDeals = [
    const Deal(
      id: '1',
      companyName: 'SolarTech Energy',
      industry: 'Renewable Energy',
      investmentRequired: 5000000,
      expectedRoi: 12.5,
      riskLevel: RiskLevel.Low,
      status: DealStatus.Open,
      description: 'SolarTech is expanding its residential solar panel distribution network across Western India.',
      roiProjection: [5, 8, 10, 12, 12.5],
      riskExplanation: 'Stable market with government subsidies, though regulatory changes could pose minor risks.',
    ),
    const Deal(
      id: '2',
      companyName: 'FinGo Neobank',
      industry: 'Fintech',
      investmentRequired: 12000000,
      expectedRoi: 25.0,
      riskLevel: RiskLevel.High,
      status: DealStatus.Open,
      description: 'A digital-first bank targeting Gen Z with innovative micro-saving features.',
      roiProjection: [2, 10, 18, 22, 25],
      riskExplanation: 'High competition and regulatory hurdles in the banking sector.',
    ),
    const Deal(
      id: '3',
      companyName: 'HealthFlow AI',
      industry: 'Healthcare',
      investmentRequired: 7500000,
      expectedRoi: 18.0,
      riskLevel: RiskLevel.Medium,
      status: DealStatus.Open,
      description: 'AI-driven diagnostic tool for early detection of cardiovascular diseases.',
      roiProjection: [4, 9, 13, 16, 18],
      riskExplanation: 'Clinical trial success is critical for market entry and scaling.',
    ),
    const Deal(
      id: '4',
      companyName: 'AgriSmart Systems',
      industry: 'Agriculture',
      investmentRequired: 3000000,
      expectedRoi: 15.0,
      riskLevel: RiskLevel.Medium,
      status: DealStatus.Closed,
      description: 'Precision farming tools using IoT sensors to optimize water usage.',
      roiProjection: [3, 7, 11, 14, 15],
      riskExplanation: 'Climate dependency and adoption rates among traditional farmers.',
    ),
    const Deal(
      id: '5',
      companyName: 'UrbanPods',
      industry: 'Real Estate',
      investmentRequired: 9000000,
      expectedRoi: 10.0,
      riskLevel: RiskLevel.Low,
      status: DealStatus.Open,
      description: 'Compact, high-tech co-living spaces for young professionals in metro cities.',
      roiProjection: [4, 6, 8, 9, 10],
      riskExplanation: 'Real estate market fluctuations and occupancy rate volatility.',
    ),
  ];

  Future<List<Deal>> getDeals() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    return _mockDeals;
  }

  Future<List<String>> getInterestedDealIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_interestsKey) ?? [];
  }

  Future<void> toggleInterest(String dealId) async {
    final prefs = await SharedPreferences.getInstance();
    final interests = prefs.getStringList(_interestsKey) ?? [];
    if (interests.contains(dealId)) {
      interests.remove(dealId);
    } else {
      interests.add(dealId);
    }
    await prefs.setStringList(_interestsKey, interests);
  }
}
