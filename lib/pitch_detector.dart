library yin;

import 'package:yin/algorithm/pitch_algorithm.dart';
import 'package:yin/algorithm/yin.dart';
import 'package:yin/pitch_detector_result.dart';

class PitchDetector {
  final PitchAlgorithm _pitchAlgorithm;

  PitchDetector(double audioSampleRate, int bufferSize)
      : this._pitchAlgorithm = new Yin(audioSampleRate, bufferSize);

  PitchDetectorResult getPitch(final List<double> audioBuffer) {
    return _pitchAlgorithm.getPitch(audioBuffer);
  }
}
