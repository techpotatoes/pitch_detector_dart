library pitch_detector_dart;

import 'package:pitch_detector_dart/algorithm/pitch_algorithm.dart';
import 'package:pitch_detector_dart/algorithm/yin.dart';
import 'package:pitch_detector_dart/pitch_detector_result.dart';

class PitchDetector {
  final PitchAlgorithm _pitchAlgorithm;

  PitchDetector(double audioSampleRate, int bufferSize)
      : this._pitchAlgorithm = new Yin(audioSampleRate, bufferSize);

  PitchDetectorResult getPitch(final List<double> audioBuffer) {
    return _pitchAlgorithm.getPitch(audioBuffer);
  }
}
