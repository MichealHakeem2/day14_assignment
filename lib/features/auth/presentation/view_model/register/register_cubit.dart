import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/network/api_result.dart';
import 'package:shopping_app/features/auth/data/api/auth_api.dart';
import 'package:shopping_app/features/auth/data/models/register_request_model.dart';
import 'package:shopping_app/features/auth/presentation/view_model/register/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  Future<void> register(RegisterRequestModel request) async {
    emit(RegisterLoadingState());
    final result = await AuthApi.register(request);
    if (result is Success<String>) {
      emit(RegisterSuccessState(result.data));
    } else if (result is Failure<String>) {
      emit(RegisterFailureState(result.message));
    }
  }
}
