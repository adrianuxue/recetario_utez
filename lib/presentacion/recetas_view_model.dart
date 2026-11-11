// Etapa 4 — El ViewModel: coordina, no dibuja.
// Conoce el contrato del repositorio, nunca a Dio ni a DummyJSON, y no
// importa material.dart (solo foundation): esto no pinta nada.

import 'package:flutter/foundation.dart';
import 'package:recetario_utez/datos/recetas_repositorio.dart';
import 'package:recetario_utez/dominio/falla_red.dart';
import 'package:recetario_utez/dominio/receta.dart';
import 'package:recetario_utez/presentacion/mensajes.dart';

/// Lo que la pantalla puede estar mostrando. Sellado: agregar un caso nuevo
/// obliga a la vista a decidir qué hacer con él.
sealed class EstadoRecetas {
  const EstadoRecetas();
}

final class RecetasInicial extends EstadoRecetas {
  const RecetasInicial();
}

final class RecetasCargando extends EstadoRecetas {
  const RecetasCargando();
}

final class RecetasListas extends EstadoRecetas {
  const RecetasListas(this.recetas, this.total);

  final List<Receta> recetas;
  final int total;
}

final class RecetasVacias extends EstadoRecetas {
  const RecetasVacias(this.busqueda);

  /// Lo que se buscó (ya limpio), para poder decirlo en pantalla.
  final String busqueda;
}

final class RecetasFallidas extends EstadoRecetas {
  const RecetasFallidas(this.mensaje);

  /// Texto listo para mostrar, nunca el detalle técnico.
  final String mensaje;
}

class RecetasViewModel extends ChangeNotifier {
  RecetasViewModel(this._repositorio);

  final RecetasRepositorio _repositorio;

  EstadoRecetas _estado = const RecetasInicial();
  String _ultimaBusqueda = '';

  EstadoRecetas get estado => _estado;

  bool get cargando => _estado is RecetasCargando;

  /// Último texto buscado, limpio, con el que se puede reintentar.
  String get ultimaBusqueda => _ultimaBusqueda;

  /// Recetas rápidas del resultado actual; 0 si no hay resultado.
  int get rapidas {
    final actual = _estado;
    if (actual is! RecetasListas) return 0;
    return actual.recetas.where((receta) => receta.esRapida).length;
  }

  /// Busca y actualiza el estado. Una sola búsqueda a la vez: si ya hay una
  /// en el aire, esta se ignora (no se dispara una segunda petición).
  Future<void> buscar(String texto) async {
    if (_estado is RecetasCargando) return;

    final limpio = texto.trim();
    _ultimaBusqueda = limpio;
    _estado = const RecetasCargando();
    notifyListeners();

    try {
      final pagina = await _repositorio.buscar(texto: limpio);
      _estado = pagina.recetas.isEmpty
          ? RecetasVacias(limpio)
          : RecetasListas(pagina.recetas, pagina.total);
    } on FallaRed catch (falla) {
      _estado = RecetasFallidas(mensajePara(falla));
    } catch (_) {
      // Todo lo no previsto cae en un mensaje genérico; la pantalla nunca
      // se queda cargando ni se cae.
      _estado = RecetasFallidas(mensajeInesperado);
    }
    notifyListeners();
  }

  /// Repite la última búsqueda.
  Future<void> reintentar() => buscar(_ultimaBusqueda);
}
