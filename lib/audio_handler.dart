// import 'dart:async';
// import 'package:audio_service/audio_service.dart';
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/services.dart';
// import 'package:just_audio/just_audio.dart';
// import '../main.dart';
// import 'package:rxdart/rxdart.dart';

// abstract class AudioPlayerHandler implements AudioHandler {
//   Stream<QueueState> get queueState;

//   Future<void> moveQueueItem(int currentIndex, int newIndex);

//   ValueStream<double> get volume;

//   Future<void> setVolume(double volume);

//   ValueStream<double> get speed;
// }

// class MediaState {
//   final MediaItem? mediaItem;
//   final Duration position;

//   MediaState(this.mediaItem, this.position);
// }

// class PositionData {
//   final Duration position;
//   final Duration bufferedPosition;
//   final Duration duration;

//   PositionData(this.position, this.bufferedPosition, this.duration);
// }

// class QueueState {
//   static const QueueState empty =
//       QueueState([], 0, [], AudioServiceRepeatMode.none);

//   final List<MediaItem> queue;
//   final int? queueIndex;
//   final List<int>? shuffleIndices;
//   final AudioServiceRepeatMode repeatMode;

//   const QueueState(
//       this.queue, this.queueIndex, this.shuffleIndices, this.repeatMode);

//   bool get hasPrevious =>
//       repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;

//   bool get hasNext =>
//       repeatMode != AudioServiceRepeatMode.none ||
//       (queueIndex ?? 0) + 1 < queue.length;

//   List<int> get indices =>
//       shuffleIndices ?? List.generate(queue.length, (i) => i);
// }

// class AudioPlayerHandlerImpl extends BaseAudioHandler
//     with SeekHandler
//     implements AudioPlayerHandler {

//        @override
//   final BehaviorSubject<double> volume = BehaviorSubject.seeded(1.0);
//   @override
//   final BehaviorSubject<double> speed = BehaviorSubject.seeded(1.0);
//   late final AudioPlayer? _player;
//   @override
//   Stream<QueueState> get queueState =>
//       Rx.combineLatest3<List<MediaItem>, PlaybackState, List<int>, QueueState>(
//           queue,
//           playbackState,
//           _player!.shuffleIndicesStream.whereType<List<int>>(),
//           (queue, playbackState, shuffleIndices) => QueueState(
//                 queue,
//                 playbackState.queueIndex,
//                 playbackState.shuffleMode == AudioServiceShuffleMode.all
//                     ? shuffleIndices
//                     : null,
//                 playbackState.repeatMode,
//               )).where((state) =>
//           state.shuffleIndices == null ||
//           state.queue.length == state.shuffleIndices!.length);
          
//             @override
//             Future<void> moveQueueItem(int currentIndex, int newIndex) {
//               // TODO: implement moveQueueItem
//               throw UnimplementedError();
//             }
          
//             @override
//             Future<void> setVolume(double volume) {
//               // TODO: implement setVolume
//               throw UnimplementedError();
//             }
//     }
