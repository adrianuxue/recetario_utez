// Etapa 3 — El cliente HTTP, prudente por defecto.
// Una sola configuración para toda la app: HTTPS, tiempos de espera razonables
// y la bitácora puesta antes de cualquier interceptor que agregue quien llame.

import 'package:dio/dio.dart';
import 'package:recetario_utez/datos/bitacora_interceptor.dart';

/// Servicio de recetas usado por la práctica.
const String urlDummyJson = 'https://dummyjson.com';

/// Crea el cliente apuntando a DummyJSON.
Dio crearDioRecetas({List<Interceptor> interceptores = const []}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: urlDummyJson,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 12),
    ),
  );
  // La bitácora va primero para que observe todo lo que pase después.
  dio.interceptors.add(BitacoraInterceptor());
  dio.interceptors.addAll(interceptores);
  return dio;
}
