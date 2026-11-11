// Etapa 1 — Los fallos de red, tal como los ve el dominio.
// Un solo árbol sellado: quien recibe una FallaRed sabe que hay cinco casos
// y solo cinco, y el compilador lo obliga a tratarlos.

sealed class FallaRed implements Exception {
  const FallaRed();
}

/// No se pudo abrir la conexión (sin internet, dominio inexistente, etc.).
final class SinConexion extends FallaRed {
  const SinConexion();
}

/// Conexión aceptada pero sin respuesta a tiempo.
final class TiempoAgotado extends FallaRed {
  const TiempoAgotado();
}

/// El servidor contestó con un 5xx.
final class ErrorDelServidor extends FallaRed {
  const ErrorDelServidor(this.codigo);

  final int codigo;
}

/// El servidor rechazó la petición (4xx).
final class PeticionRechazada extends FallaRed {
  const PeticionRechazada(this.codigo);

  final int codigo;
}

/// La respuesta llegó, pero no en la forma que esperábamos.
final class RespuestaInvalida extends FallaRed {
  const RespuestaInvalida();
}
