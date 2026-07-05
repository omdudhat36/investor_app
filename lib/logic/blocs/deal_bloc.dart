import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/deal_model.dart';
import '../../data/repositories/deal_repository.dart';


abstract class DealEvent extends Equatable {
  const DealEvent();
  @override
  List<Object?> get props => [];
}

class FetchDeals extends DealEvent {}

class UpdateFilters extends DealEvent {
  final String? searchQuery;
  final RiskLevel? riskLevel;
  final String? industry;
  final double? minRoi;

  const UpdateFilters({this.searchQuery, this.riskLevel, this.industry, this.minRoi});

  @override
  List<Object?> get props => [searchQuery, riskLevel, industry, minRoi];
}

class ToggleInterestEvent extends DealEvent {
  final String dealId;
  const ToggleInterestEvent(this.dealId);
  @override
  List<Object> get props => [dealId];
}


abstract class DealState extends Equatable {
  const DealState();
  @override
  List<Object?> get props => [];
}

class DealLoading extends DealState {}

class DealLoaded extends DealState {
  final List<Deal> allDeals;
  final List<Deal> filteredDeals;
  final List<String> interestedDealIds;
  final String? searchQuery;
  final RiskLevel? riskLevel;
  final String? industry;
  final double? minRoi;

  const DealLoaded({
    required this.allDeals,
    required this.filteredDeals,
    required this.interestedDealIds,
    this.searchQuery,
    this.riskLevel,
    this.industry,
    this.minRoi,
  });

  @override
  List<Object?> get props => [allDeals, filteredDeals, interestedDealIds, searchQuery, riskLevel, industry, minRoi];
}

class DealError extends DealState {
  final String message;
  const DealError(this.message);
  @override
  List<Object> get props => [message];
}


class DealBloc extends Bloc<DealEvent, DealState> {
  final DealRepository dealRepository;

  DealBloc({required this.dealRepository}) : super(DealLoading()) {
    on<FetchDeals>((event, emit) async {
      emit(DealLoading());
      try {
        final deals = await dealRepository.getDeals();
        final interests = await dealRepository.getInterestedDealIds();
        emit(DealLoaded(allDeals: deals, filteredDeals: deals, interestedDealIds: interests));
      } catch (e) {
        emit(DealError(e.toString()));
      }
    });

    on<UpdateFilters>((event, emit) {
      if (state is DealLoaded) {
        final currentState = state as DealLoaded;
        final filtered = currentState.allDeals.where((deal) {
          final matchesSearch = event.searchQuery == null ||
              deal.companyName.toLowerCase().contains(event.searchQuery!.toLowerCase());
          final matchesRisk = event.riskLevel == null || deal.riskLevel == event.riskLevel;
          final matchesIndustry = event.industry == null || deal.industry == event.industry;
          final matchesRoi = event.minRoi == null || deal.expectedRoi >= event.minRoi!;
          return matchesSearch && matchesRisk && matchesIndustry && matchesRoi;
        }).toList();

        emit(DealLoaded(
          allDeals: currentState.allDeals,
          filteredDeals: filtered,
          interestedDealIds: currentState.interestedDealIds,
          searchQuery: event.searchQuery ?? currentState.searchQuery,
          riskLevel: event.riskLevel,
          industry: event.industry,
          minRoi: event.minRoi,
        ));
      }
    });

    on<ToggleInterestEvent>((event, emit) async {
      if (state is DealLoaded) {
        final currentState = state as DealLoaded;
        await dealRepository.toggleInterest(event.dealId);
        final updatedInterests = await dealRepository.getInterestedDealIds();
        emit(DealLoaded(
          allDeals: currentState.allDeals,
          filteredDeals: currentState.filteredDeals,
          interestedDealIds: updatedInterests,
          searchQuery: currentState.searchQuery,
          riskLevel: currentState.riskLevel,
          industry: currentState.industry,
          minRoi: currentState.minRoi,
        ));
      }
    });
  }
}
