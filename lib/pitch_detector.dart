library pitch_detector_dart;

import 'dart:typed_data';

import 'package:pitch_detector_dart/algorithm/pitch_algorithm.dart';
import 'package:pitch_detector_dart/algorithm/yin.dart';
import 'package:pitch_detector_dart/exceptions/invalid_audio_buffer_exception.dart';
import 'package:pitch_detector_dart/pitch_detector_result.dart';
import 'package:pitch_detector_dart/util/pcm_util_extensions.dart';

class PitchDetector {
  static const int DEFAULT_SAMPLE_RATE = 44100;
  static const int DEFAULT_BUFFER_SIZE = 2048;

  double audioSampleRate;
  int bufferSize;
  final PitchAlgorithm _pitchAlgorithm;

  PitchDetector(
    {
      double this.audioSampleRate = DEFAULT_SAMPLE_RATE * 1.0,
      int this.bufferSize = DEFAULT_BUFFER_SIZE,
    }
  ): this._pitchAlgorithm = Yin(audioSampleRate, bufferSize);

  Future<PitchDetectorResult> getPitchFromIntBuffer(final Uint8List intPCM16AudioBuffer) {
    final floatBuffer = intPCM16AudioBuffer.convertPCM16ToFloat();

    return getPitchFromFloatBuffer(floatBuffer);
  }

  Future<PitchDetectorResult> getPitchFromFloatBuffer(final List<double> floatPCM32AudioBuffer) {
    
    if (floatPCM32AudioBuffer.length != bufferSize) {
      throw InvalidAudioBufferException(
        floatPCM32AudioBuffer.length,
        bufferSize,
      );
    }

    return _pitchAlgorithm.getPitch(floatPCM32AudioBuffer);
  }

}
