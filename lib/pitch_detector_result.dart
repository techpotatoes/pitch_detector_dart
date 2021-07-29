library pitch_detector_dart;

class PitchDetectorResult {
  double pitch;
  double probability;
  bool pitched;

  PitchDetectorResult(this.pitch, this.probability, this.pitched);

  PitchDetectorResult.empty()
      : pitch = -1.0,
        probability = -1.0,
        pitched = false;
}
