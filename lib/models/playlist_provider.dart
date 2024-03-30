import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> playlists = [
    Song(
        songName: "Watermelon Sugar",
        artistName: "Harry Styles",
        albumArtImagePath: "assets/images/watermelon.jpg",
        audioPath: "audio/watermelon.mp3"),
    Song(
        songName: "Formidable",
        artistName: "Stromae",
        albumArtImagePath: "assets/images/formidable.jpg",
        audioPath: "audio/formidable.mp3"),
    Song(
        songName: "Midnight City",
        artistName: "M83",
        albumArtImagePath: "assets/images/m83.jpg",
        audioPath: "audio/midnight.mp3"),
  ];

  int? currentSongIndex;
  List<Song> get getPlaylist => playlists;
  int? get getCurrentSongIndex => currentSongIndex;
  bool get getIsPlaying => isPlaying;
  Duration get getCurrentDuration => currentDuration;
  Duration get getTotalDuration => totalDuration;

  set setCurrentSongIndex(int? index) {
    currentSongIndex = index;
    if (index != null) {
      play();
    }
    notifyListeners();
  }

  final audioPlayer = AudioPlayer();
  Duration currentDuration = Duration.zero;
  Duration totalDuration = Duration.zero;
  PlaylistProvider() {
    listenToDuration();
  }
  bool isPlaying = false;
  void play() async {
    String audioPath = playlists[currentSongIndex!].audioPath;
    await audioPlayer.play(AssetSource(audioPath));
    isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await audioPlayer.pause();
    isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await audioPlayer.resume();
    isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    if (isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  void playNextSong() async {
    if (currentSongIndex != null) {
      if (currentSongIndex! < playlists.length - 1) {
        currentSongIndex = currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
      play();
    }
  }

  void playPreviousSong() async {
    if (currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (currentSongIndex! > 0) {
        currentSongIndex = currentSongIndex! - 1;
      } else {
        currentSongIndex = playlists.length - 1;
      }
      play();
    }
  }


  void listenToDuration() {
    audioPlayer.onDurationChanged.listen((newDuration) {
      totalDuration = newDuration;
      notifyListeners();
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      currentDuration = newPosition;
      notifyListeners();
    });

    audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }
}
