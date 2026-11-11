// Etapa 3 — La bitácora de peticiones.
// Registra lo mínimo: método, ruta, código y tiempo. Nada de lo que se buscó,
// ni la consulta completa, ni encabezados, ni cuerpos: la bitácora no filtra
// datos personales ni de la búsqueda.

import 'dart:developer' as developer;

import 'package:dio/dio.dart';

/// Línea por petición, en dos tiempos: `→` al salir y `←`/`✗` al volver.
class BitacoraInterceptor extends Interceptor {
  BitacoraInterceptor({void Function(String linea)? escribir})
      : _escribir = escribir ?? _escribirEnConsola;

  final void Function(String linea) _escribir;

  static void _escribirEnConsola(String linea) =>
      developer.log(linea, name: 'recetario');

  static const _marcaTiempo = 'reloj';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_marcaTiempo] = Stopwatch()..start();
    _escribir('→ ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cerrar(response.requestOptions, '←', response.statusCode);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _cerrar(err.requestOptions, '✗', err.response?.statusCode);
    handler.next(err);
  }

  /// Escribe la línea de cierre con el tiempo transcurrido.
  void _cerrar(RequestOptions opciones, String marca, int? codigo) {
    final reloj = opciones.extra[_marcaTiempo];
    final ms = reloj is Stopwatch ? (reloj..stop()).elapsedMilliseconds : 0;
    final viaje = '${opciones.method} ${opciones.path}';
    if (codigo == null) {
      _escribir('$marca $viaje ($ms ms)');
    } else {
      _escribir('$marca $codigo $viaje ($ms ms)');
    }
  }
}
