import 'dart:typed_data';

import 'package:pitch_detector_dart/exceptions/invalid_audio_buffer_exception.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitch_detector_dart/pitch_detector_result.dart';
import "package:test/test.dart";

import 'test_util.dart';

void main() {
  group("Given a pitch_detector and an audio sample", () {
    final pitchDetector = PitchDetector(
      audioSampleRate: 44100,
      bufferSize: 200,
    );
    final List<double> audioSample200 = TestUtil.audioSampleSine200Size();
    final List<double> audioSample100 = TestUtil.audioSampleSine100Size();
    final Uint8List audioSampleInt = TestUtil.audioSampleInt();
    test("should return an error if audioSample is smaller than the bufferSize",
        () async {
      expect(() => pitchDetector.getPitchFromFloatBuffer(audioSample100),
          throwsA(isA<InvalidAudioBufferException>()));
    });

    test("should return a response if bufferSize and sample size match",
        () async {
      final result =
          await pitchDetector.getPitchFromFloatBuffer(audioSample200);

      expect(result, isA<PitchDetectorResult>());
    });

    test("should return a response when the audio sample is a UInt8List",
        () async {
      final result = await pitchDetector.getPitchFromIntBuffer(audioSampleInt);

      expect(result, isA<PitchDetectorResult>());
    });
  });
}
