import 'package:flutter/material.dart';
import 'package:flutter_project/components/my_drawer.dart';
import 'package:flutter_project/models/playlist_provider.dart';
import 'package:flutter_project/pages/song_page.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final dynamic playlistProvider;
  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int index) {
    playlistProvider.setCurrentSongIndex = index;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SongView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('P L A Y L I S T',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
          centerTitle: true,
        ),
        drawer: const MyDrawer(),
        body: Consumer<PlaylistProvider>(builder: (context, value, child) {
          final List<Song> playlist = value.getPlaylist;
          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final Song song = playlist[index];
              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.asset(song.albumArtImagePath),
                onTap: () => goToSong(index),
              );
            },
          );
        }));
  }
}