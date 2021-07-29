import 'package:test/scaffolding.dart';
import 'package:yin/algorithm/yin.dart';
import "package:test/test.dart";

import '../test_util.dart';

void main() {
  group("Given a 2 seconds sine audio input of 440hz at 44.1Khz", () {
    final List<double> audioBuffer = TestUtil.audioBufferSine();
    test("should return 440Hz when using the Yin algorithm", () {
      Yin yin = new Yin(44100, 1024);

      final result = yin.getPitch(audioBuffer);

      expect(result.pitch, closeTo(440.0, 0.1));
    });
  });
}
