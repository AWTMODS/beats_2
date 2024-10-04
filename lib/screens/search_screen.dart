import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beats_music/controllers/player_controller.dart';
import 'package:beats_music/colors/colors.dart';
import 'package:beats_music/colors/text_style.dart';
import 'package:beats_music/screens/player.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PlayerController controller = Get.put(PlayerController());
  final TextEditingController searchController = TextEditingController();
  List<SongModel> allSongs = [];
  List<SongModel> filteredSongs = [];
  List<String> trendingTags = [];
  List<String> recentSearches = [];
  bool isLoading = true;
  bool isSearching = false;
  bool hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadTrendingTags();
    _loadRecentSearches();
    searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadData() async {
    final songs = await controller.audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: SongSortType.DISPLAY_NAME,
      uriType: UriType.EXTERNAL,
    );

    setState(() {
      allSongs = songs;
      filteredSongs = songs;
      isLoading = false;
    });
  }

  Future<void> _loadTrendingTags() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      trendingTags = prefs.getStringList('trendingTags') ?? [];
    });
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  Future<void> _saveRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    if (!recentSearches.contains(query)) {
      recentSearches.add(query);
      await prefs.setStringList('recentSearches', recentSearches);
    }
  }

  void _removeRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches.remove(query);
      prefs.setStringList('recentSearches', recentSearches);
    });
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredSongs = allSongs;
        isSearching = false;
        hasSearched = false;
      });
    } else {
      _saveRecentSearch(query);
      setState(() {
        filteredSongs = allSongs
            .where((song) => song.displayNameWOExt.toLowerCase().contains(query))
            .toList();
        isSearching = true;
        hasSearched = true;
      });
    }
  }

  void _clearSearch() {
    setState(() {
      searchController.clear();
      filteredSongs = allSongs;
      isSearching = false;
      hasSearched = false;
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgDarkColor,
        appBar: AppBar(
           automaticallyImplyLeading: false,
          toolbarHeight: 80,
          backgroundColor: Colors.black26,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 40.0),
            child: _buildSearchBar(),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Expanded(
              child: hasSearched ? _buildSongList() : _buildRecentSearches(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search or type a URL',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white12,
              hintStyle: const TextStyle(color: Colors.green),
              prefixIcon: const Icon(Icons.search, color: Colors.green),
              suffixIcon: isSearching
                  ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.green),
                onPressed: _clearSearch,
              )
                  : null,
            ),
            style: const TextStyle(color: Colors.green),
            onChanged: (_) => _onSearchChanged(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings_backup_restore, color: Colors.white),
          onPressed: () => setState(() => recentSearches.clear()),
        ),
      ],
    );
  }

  Widget _buildSongList() {
    return filteredSongs.isEmpty
        ? const Center(
      child: Text(
        'No results found',
        style: TextStyle(color: Colors.white),
      ),
    )
        : Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: filteredSongs.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Obx(
                  () => ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  filteredSongs[index].displayNameWOExt,
                  style: OurStyle(family: bold, size: 14),
                ),
                subtitle: Text(
                  filteredSongs[index].artist ?? 'Unknown Artist',
                  style: OurStyle(family: regular, size: 12),
                ),
                leading: QueryArtworkWidget(
                  id: filteredSongs[index].id,
                  type: ArtworkType.AUDIO,
                  artworkFit: BoxFit.cover,
                  artworkBorder: BorderRadius.circular(8),
                  nullArtworkWidget: const Icon(
                    Icons.music_note,
                    color: whiteColor,
                    size: 32,
                  ),
                ),
                trailing: controller.playIndex.value == index &&
                    controller.isPlaying.value
                    ? const Icon(Icons.pause_circle_filled,
                    color: whiteColor, size: 26)
                    : const Icon(Icons.play_circle_filled,
                    color: whiteColor, size: 26),
                onTap: () {
                  Get.to(
                        () => PlayerScreen(
                      data: filteredSongs,
                      index: index,
                    ),
                    transition: Transition.rightToLeft,
                  );
                  controller.playSong(filteredSongs[index].uri, index);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentSearches() {
    return recentSearches.isEmpty
        ? Container()
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Recent Searches',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: recentSearches
              .map((query) => GestureDetector(
            onTap: () {
              searchController.text = query;
              _onSearchChanged();
            },
            child: Chip(
              label: Text(query),
              deleteIcon: const Icon(Icons.clear),
              onDeleted: () {
                _removeRecentSearch(query);
              },
              deleteIconColor: Colors.white,
              backgroundColor: Colors.grey[800],
            ),
          ))
              .toList(),
        ),
      ],
    );
  }
}
