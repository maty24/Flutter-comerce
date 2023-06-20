//esta enum es para saber el estado de la autenticacion y es propio mio
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:teslo_shop/features/shared/infrastructure/service/key_value_impl.dart';

import '../../../shared/infrastructure/service/key_value_storage.dart';

////////////////////3333//////////////////////
////////////////////3333//////////////////////
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  //aqui tengo los datos del repositorio o caso de uso
  final authRepository = AuthRepositoryImpl();
  //aqui tengo los datos del servicio
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

/////////////////////////////////222222222//////////////////////////////
/////////////////////////////////222222222//////////////////////////////
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  //aca le mando el servicio
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.keyValueStorageService,
    required this.authRepository,
  }) : super(AuthState()) {
    //aca se ejecuta el constructor y se ejecuta la funcion
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggerUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }

    // final user = await authRepository.login(email, password);
    // state =state.copyWith(user: user, authStatus: AuthStatus.authenticated)
  }

  void registerUser(String email, String password) async {}

  void checkAuthStatus() async {
    //aca voy a buscar el token
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return;

    try {
      //aca voy a buscar el usuario
      final user = await authRepository.checkAuthStatus(token);
      //le envio el usuario
      _setLoggerUser(user);
    } catch (e) {
      logout();
    }
  }

  //esta funcion solo va tener el token
  void _setLoggerUser(User user) async {
    //aca guardo el token
    await keyValueStorageService.setKetValue('token', user.token);

    //necesito guradar el token fisicamente
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    //remuevo el token
    await keyValueStorageService.removeKey('token');
    // TODO: limpiar token
    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

//////////////////1111//////////////////////
//////////////////1111//////////////////////
enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}
