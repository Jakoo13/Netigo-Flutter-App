import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netigo_front/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:netigo_front/features/authentication/domain/entities/logged_in_user.dart';
import 'package:netigo_front/features/authentication/form_submission_status.dart';
import 'package:netigo_front/features/authentication/presentation/bloc/register/register_event.dart';
import 'package:netigo_front/features/authentication/presentation/bloc/register/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepositoryImpl authRepo;
  RegisterBloc({required this.authRepo}) : super(RegisterState()) {
    on<RegisterFirstNameChanged>(
      ((event, emit) => emit(state.copyWith(firstName: event.firstName))),
    );
    on<RegisterLastNameChanged>(
      ((event, emit) => emit(state.copyWith(lastName: event.lastName))),
    );
    on<RegisterEmailChanged>(
      ((event, emit) => emit(state.copyWith(email: event.email))),
    );
    on<RegisterPasswordChanged>(
      ((event, emit) => emit(state.copyWith(password: event.password))),
    );
    on<RegisterSubmitted>(_registerSubmitted);
  }

  _registerSubmitted(event, emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      await authRepo.register(
          loggedInUser: LoggedInUser(
              id: "id",
              firstName: state.firstName!,
              lastName: state.lastName!,
              email: state.email!));
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e)));
    }
  }
}
