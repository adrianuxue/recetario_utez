// Etapa 4 — Lo que se le dice a la persona.
// Mensajes claros, en español, sin tecnicismos: nadie quiere ver un
// "DioException" cuando su red no contesta.

import 'package:recetario_utez/dominio/falla_red.dart';

/// Mensaje para cualquier error que no supimos clasificar.
const String mensajeInesperado = 'Algo salió mal. Intenta de nuevo.';

String mensajePara(FallaRed falla) {
  return switch (falla) {
    SinConexion() => 'Sin conexión. Revisa tu red e intenta de nuevo.',
    TiempoAgotado() =>
    'El recetario tardó demasiado en responder. Intenta de nuevo.',
    ErrorDelServidor(:final codigo) =>
    'El recetario no está disponible ($codigo). Intenta más tarde.',
    PeticionRechazada() =>
    'No pudimos hacer esa búsqueda. Avisa al equipo de desarrollo.',
    RespuestaInvalida() => 'Las recetas llegaron con un formato inesperado.',
  };
}
