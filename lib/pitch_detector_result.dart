library pitch_detector_dart;

class PitchDetectorResult {
  double pitch;
  double probability;
  bool pitched;

  PitchDetectorResult({required this.pitch, required this.probability, required this.pitched});
}
