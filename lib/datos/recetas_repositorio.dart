// Etapa 3 — El contrato que conocen el ViewModel y las vistas.
// El dominio de la app depende de esta interfaz, no de Dio ni de DummyJSON.

import 'package:recetario_utez/dominio/receta.dart';

abstract class RecetasRepositorio {
  /// Busca recetas por texto. Texto vacío (o solo espacios) trae la lista
  /// general. Falla con [FallaRed] si algo sale mal.
  Future<PaginaRecetas> buscar({String texto = ''});
}
