import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/auth_bloc.dart';
import '../../logic/blocs/deal_bloc.dart';
import '../../data/models/deal_model.dart';
import '../widgets/deal_card.dart';
import 'deal_details_screen.dart';

class DealListScreen extends StatelessWidget {
  const DealListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Deals'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                    child: const Text('Logout', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) {
                context.read<DealBloc>().add(UpdateFilters(searchQuery: value));
              },
              decoration: InputDecoration(
                hintText: 'Search companies...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<DealBloc, DealState>(
              builder: (context, state) {
                if (state is DealLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DealLoaded) {
                  if (state.filteredDeals.isEmpty) {
                    return const Center(child: Text('No deals found matching your criteria.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.filteredDeals.length,
                    itemBuilder: (context, index) {
                      final deal = state.filteredDeals[index];
                      final isInterested = state.interestedDealIds.contains(deal.id);
                      return DealCard(
                        deal: deal,
                        isInterested: isInterested,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<DealBloc>(),
                                child: DealDetailsScreen(dealId: deal.id),
                              ),
                            ),
                          );
                        },
                        onInterestToggle: () {
                          context.read<DealBloc>().add(ToggleInterestEvent(deal.id));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isInterested ? 'Removed from interests' : 'Added to interests!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is DealError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return BlocProvider.value(
          value: context.read<DealBloc>(),
          child: const FilterBottomSheet(),
        );
      },
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RiskLevel? _selectedRisk;
  String? _selectedIndustry;
  double _minRoi = 0;

  final List<String> _industries = [
    'Renewable Energy',
    'Fintech',
    'Healthcare',
    'Agriculture',
    'Real Estate'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Deals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Risk Level', style: TextStyle(fontWeight: FontWeight.w600)),
            Wrap(
              spacing: 8,
              children: RiskLevel.values.map((level) {
                return ChoiceChip(
                  label: Text(level.name),
                  selected: _selectedRisk == level,
                  onSelected: (selected) {
                    setState(() => _selectedRisk = selected ? level : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Industry', style: TextStyle(fontWeight: FontWeight.w600)),
            Wrap(
              spacing: 8,
              children: _industries.map((industry) {
                return ChoiceChip(
                  label: Text(industry),
                  selected: _selectedIndustry == industry,
                  onSelected: (selected) {
                    setState(() => _selectedIndustry = selected ? industry : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Minimum ROI: ${_minRoi.toInt()}%', style: const TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: _minRoi,
              min: 0,
              max: 30,
              divisions: 6,
              label: '${_minRoi.toInt()}%',
              onChanged: (value) => setState(() => _minRoi = value),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<DealBloc>().add(UpdateFilters(
                        riskLevel: _selectedRisk,
                        industry: _selectedIndustry,
                        minRoi: _minRoi,
                      ));
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
