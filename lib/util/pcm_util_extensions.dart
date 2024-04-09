import 'dart:typed_data';

/// Converts PCM16 encondig to float.
extension PCMConversions on Uint8List {
  List<double> convertPCM16ToFloat() {
    ByteData byteData = buffer.asByteData();
    List<double> floatList = [
      for (var offset = 0; offset < length; offset += 2)
        ((byteData.getUint16(offset) & 0xFF) - 32767) * (1.0 / 32767.0)
    ];

    return floatList;
  }
}
