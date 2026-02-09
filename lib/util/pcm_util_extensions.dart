import 'dart:typed_data';

/// Converts PCM16 encoding to normalized float samples.
extension PCMConversions on Uint8List {
  /// Convert 16-bit PCM bytes to normalized doubles in [-1.0, 1.0).
  /// Assumes samples are interleaved 16-bit signed integers.
  /// Set [endian] to Endian.big if your data is big-endian.
  List<double> convertPCM16ToFloat({Endian endian = Endian.little}) {
    final byteData = buffer.asByteData(offsetInBytes, lengthInBytes);
    final floats = <double>[];
    for (var offset = 0; offset + 1 < lengthInBytes; offset += 2) {
      final sample = byteData.getInt16(offset, endian);
      // Divide by 32768.0 to map -32768..32767 -> ~-1.0..+1.0
      floats.add(sample / 32768.0);
    }
    return floats;
  }
}
