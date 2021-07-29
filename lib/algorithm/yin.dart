import 'package:yin/algorithm/pitch_algorithm.dart';
import 'package:yin/pitch_detector_result.dart';

//  An implementation of the AUBIO_YIN pitch tracking algorithm.
//  This is a port of the TarsosDSP library developed by Joren Six and Paul Brossier at IPEM, University Ghent
//  Original implementation : https://github.com/JorenSix/TarsosDSP
//
//  Ported by Techpotatoes - Lucas Bento

class Yin extends PitchAlgorithm {
  //The default YIN threshold value. Should be around 0.10~0.15. See YIN
  //paper for more information.
  static final double DEFAULT_THRESHOLD = 0.20;
  //The default size of an audio buffer (in samples).
  static final int DEFAULT_BUFFER_SIZE = 2048;
  //The default overlap of two consecutive audio buffers (in samples).
  static final int DEFAULT_OVERLAP = 1536;

  final double _threshold;
  final double _sampleRate;
  final List<double> _yinBuffer;
  final PitchDetectorResult _result;

  Yin(double audioSampleRate, int bufferSize)
      : this._sampleRate = audioSampleRate,
        this._threshold = DEFAULT_THRESHOLD,
        this._yinBuffer = List<double>.filled(bufferSize ~/ 2, 0.0),
        this._result = new PitchDetectorResult.empty();

  @override
  PitchDetectorResult getPitch(final List<double> audioBuffer) {
    final int tauEstimate;
    final double pitchInHertz;

    // step 2
    _difference(audioBuffer);

    // step 3
    _cumulativeMeanNormalizedDifference();

    // step 4
    tauEstimate = _absoluteThreshold();

    // step 5
    if (tauEstimate != -1) {
      final double betterTau = _parabolicInterpolation(tauEstimate);

      // step 6
      // TODO Implement optimization for the AUBIO_YIN algorithm.
      // 0.77% => 0.5% error rate,
      // using the data of the YIN paper
      // bestLocalEstimate()

      // conversion to Hz
      pitchInHertz = _sampleRate / betterTau;
    } else {
      // no pitch found
      pitchInHertz = -1;
    }

    _result.pitch = pitchInHertz;

    return _result;
  }

  //Implements the difference function as described in step 2 of the YIN
  void _difference(final List<double> audioBuffer) {
    int index, tau;
    double delta;
    for (tau = 0; tau < _yinBuffer.length; tau++) {
      _yinBuffer[tau] = 0;
    }
    for (tau = 1; tau < _yinBuffer.length; tau++) {
      for (index = 0; index < _yinBuffer.length; index++) {
        delta = audioBuffer[index] - audioBuffer[index + tau];
        _yinBuffer[tau] += delta * delta;
      }
    }
  }

  //The cumulative mean normalized difference function as described in step 3 of the YIN paper.
  void _cumulativeMeanNormalizedDifference() {
    int tau;
    _yinBuffer[0] = 1;
    double runningSum = 0;
    for (tau = 1; tau < _yinBuffer.length; tau++) {
      runningSum += _yinBuffer[tau];
      _yinBuffer[tau] *= tau / runningSum;
    }
  }

  //Implements step 4 of the AUBIO_YIN paper.
  int _absoluteThreshold() {
    // Uses another loop construct
    // than the AUBIO implementation
    int tau;
    // first two positions in yinBuffer are always 1
    // So start at the third (index 2)
    for (tau = 2; tau < _yinBuffer.length; tau++) {
      if (_yinBuffer[tau] < _threshold) {
        while (tau + 1 < _yinBuffer.length &&
            _yinBuffer[tau + 1] < _yinBuffer[tau]) {
          tau++;
        }
        // found tau, exit loop and return
        // store the probability
        // From the YIN paper: The threshold determines the list of
        // candidates admitted to the set, and can be interpreted as the
        // proportion of aperiodic power tolerated
        // within a periodic signal.
        //
        // Since we want the periodicity and and not aperiodicity:
        // periodicity = 1 - aperiodicity
        _result.probability = 1 - _yinBuffer[tau];
        break;
      }
    }

    // if no pitch found, tau => -1
    if (tau == _yinBuffer.length || _yinBuffer[tau] >= _threshold) {
      tau = -1;
      _result.probability = 0;
      _result.pitched = false;
    } else {
      _result.pitched = true;
    }

    return tau;
  }

  //Implements step 5 of the AUBIO_YIN paper. It refines the estimated tau
  //value using parabolic interpolation. This is needed to detect higher
  //frequencies more precisely. See http://fizyka.umk.pl/nrbook/c10-2.pdf and
  // for more background
  //http://fedc.wiwi.hu-berlin.de/xplore/tutorials/xegbohtmlnode62.html
  double _parabolicInterpolation(final int tauEstimate) {
    final double betterTau;
    final int x0;
    final int x2;

    if (tauEstimate < 1) {
      x0 = tauEstimate;
    } else {
      x0 = tauEstimate - 1;
    }
    if (tauEstimate + 1 < _yinBuffer.length) {
      x2 = tauEstimate + 1;
    } else {
      x2 = tauEstimate;
    }
    if (x0 == tauEstimate) {
      if (_yinBuffer[tauEstimate] <= _yinBuffer[x2]) {
        betterTau = tauEstimate.toDouble();
      } else {
        betterTau = x2.toDouble();
      }
    } else if (x2 == tauEstimate) {
      if (_yinBuffer[tauEstimate] <= _yinBuffer[x0]) {
        betterTau = tauEstimate.toDouble();
      } else {
        betterTau = x0.toDouble();
      }
    } else {
      double s0, s1, s2;
      s0 = _yinBuffer[x0];
      s1 = _yinBuffer[tauEstimate];
      s2 = _yinBuffer[x2];
      // fixed AUBIO implementation, thanks to Karl Helgason:
      // (2.0f * s1 - s2 - s0) was incorrectly multiplied with -1
      betterTau = tauEstimate + (s2 - s0) / (2 * (2 * s1 - s2 - s0));
    }
    return betterTau;
  }
}
