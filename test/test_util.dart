import 'dart:math';
import 'dart:typed_data';

class TestUtil {
  
  static List<double> audioBufferSine() {
    final double sampleRate = 44100.0;
    final double f0 = 440.0;
    final double amplitudeF0 = 0.5;
    final double seconds = 4.0;
    final List<double> buffer =
        List<double>.filled((seconds * sampleRate).toInt(), 0.0);
    for (int sample = 0; sample < buffer.length; sample++) {
      final double time = sample / sampleRate;
      buffer[sample] = (amplitudeF0 * sin(2 * pi * f0 * time)).toDouble();
    }
    return buffer;
  }

  static List<double> audioBufferSine200Size() {
    final double sampleRate = 44100.0;
    final double f0 = 440.0;
    final double amplitudeF0 = 0.5;
    final List<double> buffer =
        List<double>.filled(200, 0.0);
    for (int sample = 0; sample < buffer.length; sample++) {
      final double time = sample / sampleRate;
      buffer[sample] = (amplitudeF0 * sin(2 * pi * f0 * time)).toDouble();
    }
    return buffer;
  }

  static Uint8List audioBufferInt() {
    final random = Random();
    int next(int min, int max) => min + random.nextInt(max - min);

    final Uint8List buffer = Uint8List.fromList(
      List<int>.filled(400, next(1, 127))
    );
    return buffer;
  }
}
