import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:provider/provider.dart';

import 'adaptive_image.dart'; // Add this line
import 'app_state.dart';

class Playlists extends StatelessWidget {
  const Playlists({super.key, required this.playlistSelected});

  final PlaylistsListSelected playlistSelected;

  @override
  Widget build(BuildContext context) {
    return Consumer<FlutterDevPlaylists>(
      builder: (context, flutterDev, _) {
        final playlistItems = flutterDev.playlistItems(playlistId: playlistId);
        if (playlistItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return _PlaylistDetailsListView(playlistItems: playlistItems);
      },
    );
  }
}

typedef PlaylistsListSelected = void Function(Playlist playlist);

class _PlaylistsListView extends StatefulWidget {
  const _PlaylistsListView({
    required this.items,
    required this.playlistSelected,
  });

  final List<Playlist> items;
  final PlaylistsListSelected playlistSelected;

  @override
  State<_PlaylistsListView> createState() => _PlaylistsListViewState();
}

class _PlaylistsListViewState extends State<_PlaylistsListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        var playlist = widget.items[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: AdaptiveImage.network(  // Change this one.
              playlist.snippet!.thumbnails!.default_!.url!,
            ),
            title: Text(playlist.snippet!.title!),
            subtitle: Text(
              playlist.snippet!.description!,
            ),
            onTap: () {
              widget.playlistSelected(playlist);
            },
          ),
        );
      },
    );
  }
}