import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../logic/blocs/deal_bloc.dart';
import '../../data/models/deal_model.dart';

class DealDetailsScreen extends StatelessWidget {
  final String dealId;

  const DealDetailsScreen({super.key, required this.dealId});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Deal Details')),
      body: BlocBuilder<DealBloc, DealState>(
        builder: (context, state) {
          if (state is DealLoaded) {
            final deal = state.allDeals.firstWhere((d) => d.id == dealId);
            final isInterested = state.interestedDealIds.contains(deal.id);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.companyName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(deal.industry, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  const SizedBox(height: 24),
                  _buildSection('Company Overview', deal.description),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricCard(context, 'Investment', currencyFormat.format(deal.investmentRequired)),
                      _buildMetricCard(context, 'Expected ROI', '${deal.expectedRoi}%'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('ROI Projection (5 Years)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildRoiChart(deal.roiProjection),
                  const SizedBox(height: 32),
                  _buildSection('Risk Analysis', deal.riskExplanation),
                  const SizedBox(height: 16),
                  _buildRiskAlert(deal.riskLevel),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInterested ? Colors.grey : Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        context.read<DealBloc>().add(ToggleInterestEvent(deal.id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isInterested ? 'Removed from interests' : 'Added to interests!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(isInterested ? "I'm Interested (Undo)" : "I'm Interested"),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String label, String value) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRoiChart(List<double> projection) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: projection.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: Colors.indigo,
              barWidth: 4,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.indigo.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskAlert(RiskLevel level) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[700]!),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This investment is classified as ${level.name} risk. Please review all financials before proceeding.',
              style: TextStyle(color: Colors.amber[900], fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
