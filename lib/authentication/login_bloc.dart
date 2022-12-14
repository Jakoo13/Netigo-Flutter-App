import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netigo_front/authentication/auth_repository.dart';
import 'package:netigo_front/authentication/form_submission_status.dart';
import 'package:netigo_front/authentication/login_event.dart';
import 'package:netigo_front/authentication/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;
  LoginBloc({required this.authRepo}) : super(LoginState()) {
    on<EmailChanged>(
      ((event, emit) => emit(state.copyWith(email: event.email))),
    );
    on<PasswordChanged>(
      ((event, emit) => emit(state.copyWith(password: event.password))),
    );
    on<LoginSubmitted>(_loginSubmitted);
  }

  _loginSubmitted(event, emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      await authRepo.login();
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e)));
    }
  }
}
