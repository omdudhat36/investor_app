import 'package:equatable/equatable.dart';

enum RiskLevel { Low, Medium, High }

enum DealStatus { Open, Closed }

class Deal extends Equatable {
  final String id;
  final String companyName;
  final String industry;
  final double investmentRequired;
  final double expectedRoi;
  final RiskLevel riskLevel;
  final DealStatus status;
  final String description;
  final List<double> roiProjection;
  final String riskExplanation;

  const Deal({
    required this.id,
    required this.companyName,
    required this.industry,
    required this.investmentRequired,
    required this.expectedRoi,
    required this.riskLevel,
    required this.status,
    required this.description,
    required this.roiProjection,
    required this.riskExplanation,
  });

  @override
  List<Object?> get props => [
        id,
        companyName,
        industry,
        investmentRequired,
        expectedRoi,
        riskLevel,
        status,
        description,
        roiProjection,
        riskExplanation,
      ];
}
