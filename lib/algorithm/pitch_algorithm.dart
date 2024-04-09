import 'package:pitch_detector_dart/pitch_detector_result.dart';

/// Defines a contract on how a pitch can be obtained
abstract class PitchAlgorithm {
  Future<PitchDetectorResult> getPitch(final List<double> audioBuffer);
}
