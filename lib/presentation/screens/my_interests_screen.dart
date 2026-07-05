import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/deal_bloc.dart';
import '../widgets/deal_card.dart';
import 'deal_details_screen.dart';

class MyInterestsScreen extends StatelessWidget {
  const MyInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Interests')),
      body: BlocBuilder<DealBloc, DealState>(
        builder: (context, state) {
          if (state is DealLoaded) {
            final interestedDeals = state.allDeals.where((d) => state.interestedDealIds.contains(d.id)).toList();

            if (interestedDeals.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('You haven\'t marked any deals yet.', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: interestedDeals.length,
              itemBuilder: (context, index) {
                final deal = interestedDeals[index];
                return DealCard(
                  deal: deal,
                  isInterested: true,
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
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
