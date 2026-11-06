import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/network/api_result.dart';
import 'package:shopping_app/features/auth/data/api/auth_api.dart';
import 'package:shopping_app/features/auth/data/models/login_response_model.dart';
import 'package:shopping_app/features/auth/presentation/view_model/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  Future<void> login(String email, String password) async {
    emit(LoginLoadingState());
    final result = await AuthApi.login(email, password);
    if (result is Success<LoginResponseModel>) {
      emit(LoginSuccessState(result.data));
    } else if (result is Failure<LoginResponseModel>) {
      emit(LoginFailureState(result.message));
    }
  }
}
