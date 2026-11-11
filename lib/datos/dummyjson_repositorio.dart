// Etapa 3 — El repositorio concreto: DummyJSON sobre Dio.

import 'package:dio/dio.dart';
import 'package:recetario_utez/datos/recetas_json.dart';
import 'package:recetario_utez/datos/recetas_repositorio.dart';
import 'package:recetario_utez/datos/traducir_error.dart';
import 'package:recetario_utez/dominio/falla_red.dart';
import 'package:recetario_utez/dominio/receta.dart';

/// Cuántas recetas trae cada petición.
const int recetasPorPagina = 10;

class DummyJsonRepositorio implements RecetasRepositorio {
  DummyJsonRepositorio(this._dio);

  final Dio _dio;

  @override
  Future<PaginaRecetas> buscar({String texto = ''}) async {
    final limpio = texto.trim();
    final hayTexto = limpio.isNotEmpty;

    try {
      final respuesta = await _dio.get<dynamic>(
        hayTexto ? '/recipes/search' : '/recipes',
        queryParameters: hayTexto
            ? {'q': limpio, 'limit': recetasPorPagina}
            : {'limit': recetasPorPagina},
      );

      final cuerpo = respuesta.data;
      // Una lista (u otra cosa) no es una página: eso es respuesta inválida.
      if (cuerpo is! Map<String, dynamic>) throw const RespuestaInvalida();

      try {
        return paginaDesdeJson(cuerpo);
      } on FormatException {
        // El JSON tenía otra forma de la que esperábamos.
        throw const RespuestaInvalida();
      }
    } on DioException catch (e) {
      throw traducirError(e);
    }
  }
}
