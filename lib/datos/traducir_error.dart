// Etapa 3 — De los errores de Dio a las fallas del dominio.
// El resto de la app nunca ve un DioException: ve una FallaRed.

import 'package:dio/dio.dart';
import 'package:recetario_utez/dominio/falla_red.dart';

FallaRed traducirError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const TiempoAgotado();
    case DioExceptionType.connectionError:
      return const SinConexion();
    case DioExceptionType.badCertificate:
      return const SinConexion();
    case DioExceptionType.badResponse:
      final codigo = e.response?.statusCode ?? 0;
      if (codigo >= 500) return ErrorDelServidor(codigo);
      return PeticionRechazada(codigo);
    case DioExceptionType.cancel:
      return const SinConexion();
    case DioExceptionType.unknown:
    // JSON mal escrito: la respuesta no era lo que prometía.
      if (e.error is FormatException) return const RespuestaInvalida();
      return const SinConexion();
  }
}
