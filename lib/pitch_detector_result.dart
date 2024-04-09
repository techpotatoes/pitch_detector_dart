/// @nodoc
library pitch_detector_dart;

/// Pitch detector result
/// Holds result of a pitch validation
class PitchDetectorResult {
  double pitch;
  double probability;
  bool pitched;

  /// Pitch is the pitch value in Hz
  /// Probability is the probability of it being the given pitch
  /// pitched shows if the audioSample contains a pitch.
  PitchDetectorResult(
      {required this.pitch, required this.probability, required this.pitched});
}
