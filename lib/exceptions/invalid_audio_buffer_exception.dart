
class InvalidAudioBufferException implements Exception {
  final int sampleSize;
  final int bufferSize;
  
  InvalidAudioBufferException(int this.sampleSize, int this.bufferSize);

  String errMsg() => "AudioSample size ($sampleSize) does not match BUFFER_SIZE ($bufferSize)";  
}