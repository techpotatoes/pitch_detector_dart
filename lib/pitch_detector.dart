/// Pitch detector library
library pitch_detector_dart;

import 'dart:typed_data';

import 'package:pitch_detector_dart/algorithm/pitch_algorithm.dart';
import 'package:pitch_detector_dart/algorithm/yin.dart';
import 'package:pitch_detector_dart/exceptions/invalid_audio_buffer_exception.dart';
import 'package:pitch_detector_dart/pitch_detector_result.dart';
import 'package:pitch_detector_dart/util/pcm_util_extensions.dart';

/// Pitch detector
///
/// Validates an audio sample and tries to find a pitch
class PitchDetector {
  static const int DEFAULT_SAMPLE_RATE = 44100;
  static const int DEFAULT_BUFFER_SIZE = 2048;

  double audioSampleRate;
  int bufferSize;
  final PitchAlgorithm _pitchAlgorithm;

  PitchDetector({
    double this.audioSampleRate = DEFAULT_SAMPLE_RATE * 1.0,
    int this.bufferSize = DEFAULT_BUFFER_SIZE,
  }) : this._pitchAlgorithm = Yin(audioSampleRate, bufferSize);

  /// PCM16 enconding
  ///
  /// Most libraries return PCM16 as UInt8List. Use this method to find a pitch.
  Future<PitchDetectorResult> getPitchFromIntBuffer(
      final Uint8List intPCM16AudioBuffer) {
    final floatBuffer = intPCM16AudioBuffer.convertPCM16ToFloat();

    return getPitchFromFloatBuffer(floatBuffer);
  }

  /// PCMFloat enconding
  ///
  /// Use this method to find a pitch from a PCM float encoding. Audio sample size needs to match or be greater than the buffer size
  Future<PitchDetectorResult> getPitchFromFloatBuffer(
      final List<double> floatPCM32AudioBuffer) {
    if (floatPCM32AudioBuffer.length < bufferSize) {
      throw InvalidAudioBufferException(
        floatPCM32AudioBuffer.length,
        bufferSize,
      );
    }

    return _pitchAlgorithm.getPitch(floatPCM32AudioBuffer);
  }
}
