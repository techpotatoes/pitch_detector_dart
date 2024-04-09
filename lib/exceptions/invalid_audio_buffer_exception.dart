/// Wrong audio sample size exception class
class InvalidAudioBufferException implements Exception {
  final int sampleSize;
  final int bufferSize;

  /// Sample size and buffer size given
  InvalidAudioBufferException(int this.sampleSize, int this.bufferSize);

  String errMsg() =>
      "AudioSample size ($sampleSize) can't be smaller than BUFFER_SIZE ($bufferSize)";
}
