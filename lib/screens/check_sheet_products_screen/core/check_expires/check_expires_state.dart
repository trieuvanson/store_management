part of 'check_expires_cubit.dart';

@immutable
abstract class CheckExpiresState {}

class CheckExpiresInitial extends CheckExpiresState {}

class CheckExpiresLoaded extends CheckExpiresState {
  final List<ProductDTO> checkExpires;
  int nextPage = 1;
  bool hasNext = true;
  String? isLoading;
  CheckExpiresLoaded(
      {required this.checkExpires,
      required this.nextPage,
      required this.hasNext,
      this.isLoading});

  //copy with
  CheckExpiresLoaded copyWith({
    List<ProductDTO>? checkExpires,
    int? nextPage,
    bool? hasNext,
    String? isLoading,
  }) {
    return CheckExpiresLoaded(
      checkExpires: checkExpires ?? this.checkExpires,
      nextPage: nextPage ?? this.nextPage,
      hasNext: hasNext ?? this.hasNext,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CheckExpiresLoading extends CheckExpiresState {}

class CheckExpiresError extends CheckExpiresState {
  final String error;

  CheckExpiresError({required this.error});
}
