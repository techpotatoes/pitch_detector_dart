## Pitch detector dart library

A dart library for pitch detection. It implements the yin algorithm ported from the tarsosDSP library by Joren Six.

## Getting started

To import the library into your project, go to your project pubspec.yaml and add the dependency: 

```dart
dependencies:
  pitch_detector_dart: ^0.0.5
```

## Usage

```dart
//Create a new pitch detector and set the sample rate and buffer size  
final pitchDetectorDart = PitchDetector(44100, 2000);

//Call the get pitch method passing as a parameter the audio sample (List<double>) to detect a pitch 
final result = await pitchDetectorDart.getPitch(audioSample);
=======
//Call the get pitch method passing as a parameter the audio sample. There are two methods that can be used:

//The first acccepts a List<double> - This should be a sample from the PCM float enconding type.

final result = pitchDetectorDart.getPitchFromFloatBuffer(PCM32FloataudioSample);

//The second acccepts a UInt8List - This should be an audio sample from the PCM16 enconding type. Most recording libraties use a UInt8List to hold the samples. So I decided to follow that to facilitate using the library.

final result = pitchDetectorDart.getPitchFromIntBuffer(PCM16Int8AudioSample);

```

* Other input types might be added in the future if needed.


See the full example here: https://github.com/techpotatoes/pitchup_flutter_sample

#### The result will contain: 
* pitch: The pitch extracted from the audio sample if existent  
* probability: The probability of the pitch found 
* pitched: A flag to indicated if a pitch was identified or not from the sample given

## Contributing

Please, drop me an email if you have any suggestions, problems or feedback. Feel free to submit a pull request if you improved the library and want to share it. 

### Privacy Policy

This page informs you of our policies regarding the collection, use and disclosure of Personal Information when you use our Service.

The library don't store or share any kind of information. No data is saved or shared through any means. 
