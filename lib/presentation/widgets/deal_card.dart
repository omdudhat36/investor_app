import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/deal_model.dart';

class DealCard extends StatelessWidget {
  final Deal deal;
  final bool isInterested;
  final VoidCallback onTap;
  final VoidCallback onInterestToggle;

  const DealCard({
    super.key,
    required this.deal,
    required this.isInterested,
    required this.onTap,
    required this.onInterestToggle,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      deal.companyName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildStatusChip(deal.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                deal.industry,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetric('Investment', currencyFormat.format(deal.investmentRequired)),
                  _buildMetric('Exp. ROI', '${deal.expectedRoi}%'),
                  _buildRiskBadge(deal.riskLevel),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onInterestToggle,
                    icon: Icon(
                      isInterested ? Icons.favorite : Icons.favorite_border,
                      color: isInterested ? Colors.red : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: onTap,
                    child: const Text('View Details'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(DealStatus status) {
    final isOpen = status == DealStatus.Open;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.name,
        style: TextStyle(
          color: isOpen ? Colors.green : Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRiskBadge(RiskLevel level) {
    Color color;
    switch (level) {
      case RiskLevel.Low:
        color = Colors.green;
        break;
      case RiskLevel.Medium:
        color = Colors.orange;
        break;
      case RiskLevel.High:
        color = Colors.red;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${level.name} Risk',
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
