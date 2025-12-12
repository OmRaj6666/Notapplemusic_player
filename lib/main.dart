// lib/main.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

void main() {
  runApp(MyApp());
}

class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String art;
  final String url;
  final Duration duration;
  final bool isExplicit;
  final bool isDownloaded;
  final bool isLiked;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.art,
    required this.url,
    required this.duration,
    this.isExplicit = false,
    this.isDownloaded = false,
    this.isLiked = false,
  });
}

// Updated library songs with your assets
final List<Song> librarySongs = [
  Song(
    id: '1',
    title: 'Sample Track 1',
    artist: 'Artist A',
    album: 'Demo Album',
    art: 'assets/images/album1.jpg',
    url: 'assets/audio/sample1.mp3',
    duration: Duration(minutes: 3, seconds: 20),
    isExplicit: false,
    isDownloaded: true,
    isLiked: true,
  ),
  Song(
    id: '2',
    title: 'Sample Track 2',
    artist: 'Artist B',
    album: 'Demo Album',
    art: 'assets/images/album2.jpg',
    url: 'assets/audio/sample2.mp3',
    duration: Duration(minutes: 2, seconds: 45),
    isExplicit: false,
    isDownloaded: true,
    isLiked: false,
  ),
  Song(
    id: '3',
    title: 'Chill Vibes',
    artist: 'Various Artists',
    album: 'Lofi Beats',
    art: 'assets/cover3.jpg',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    duration: Duration(minutes: 3, seconds: 58),
    isExplicit: false,
    isDownloaded: false,
    isLiked: true,
  ),
  Song(
    id: '4',
    title: 'Focus Mix',
    artist: 'Study Beats',
    album: 'Productivity',
    art: 'assets/cover4.jpg',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    duration: Duration(minutes: 2, seconds: 47),
    isExplicit: false,
    isDownloaded: false,
    isLiked: true,
  ),
  Song(
    id: '5',
    title: 'Energy Boost',
    artist: 'Workout Crew',
    album: 'Fitness Hits',
    art: 'assets/cover5.jpg',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    duration: Duration(minutes: 3, seconds: 52),
    isExplicit: false,
    isDownloaded: true,
    isLiked: false,
  ),
];

// Additional songs for Top Picks section with your assets
final List<Song> topPicks = [
  Song(
    id: 'tp1',
    title: 'Morning Coffee',
    artist: 'Chillhop Music',
    album: 'Relaxing Vibes',
    art: 'assets/images/album1.jpg',
    url: 'assets/audio/sample1.mp3',
    duration: Duration(minutes: 3, seconds: 15),
    isExplicit: false,
    isDownloaded: true,
    isLiked: true,
  ),
  Song(
    id: 'tp2',
    title: 'Night Drive',
    artist: 'Synthwave Collective',
    album: 'Retro Dreams',
    art: 'assets/images/album2.jpg',
    url: 'assets/audio/sample2.mp3',
    duration: Duration(minutes: 4, seconds: 20),
    isExplicit: false,
    isDownloaded: true,
    isLiked: true,
  ),
  Song(
    id: 'tp3',
    title: 'Study Session',
    artist: 'Lo-fi Beats',
    album: 'Focus Flow',
    art: 'assets/cover3.jpg',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    duration: Duration(minutes: 3, seconds: 45),
    isExplicit: false,
    isDownloaded: true,
    isLiked: false,
  ),
  Song(
    id: 'tp4',
    title: 'Workout Power',
    artist: 'Energy Crew',
    album: 'Gym Anthems',
    art: 'assets/cover4.jpg',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    duration: Duration(minutes: 2, seconds: 55),
    isExplicit: false,
    isDownloaded: false,
    isLiked: true,
  ),
];

final List<Map<String, dynamic>> browseCategories = [
  {'title': 'New Music', 'color': Colors.pink, 'icon': Icons.music_note},
  {'title': 'Charts', 'color': Colors.purple, 'icon': Icons.trending_up},
  {'title': 'Radio', 'color': Colors.orange, 'icon': Icons.radio},
  {'title': 'Made for You', 'color': Colors.blue, 'icon': Icons.person},
  {'title': 'Curated Playlists', 'color': Colors.green, 'icon': Icons.playlist_play},
  {'title': 'Genres & Moods', 'color': Colors.red, 'icon': Icons.mood},
];

final List<Map<String, dynamic>> recentlyPlayed = [
  {'title': 'Daily Mix 1', 'subtitle': 'Sample Track 1, Chill Vibes...', 'color': Colors.blue},
  {'title': 'Your Top Picks', 'subtitle': 'Based on your listening', 'color': Colors.purple},
  {'title': 'Recently Added', 'subtitle': 'Your latest favorites', 'color': Colors.red},
  {'title': 'Study Focus', 'subtitle': 'Concentration music', 'color': Colors.green},
];

class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  List<Song> _queue = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLiked = false;
  bool _isShuffle = false;
  LoopMode _loopMode = LoopMode.off;
  double _volume = 0.7;

  AudioPlayer get player => _player;
  List<Song> get queue => _queue;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isLiked => _isLiked;
  bool get isShuffle => _isShuffle;
  LoopMode get loopMode => _loopMode;
  double get volume => _volume;

  Song? get currentSong {
    if (_queue.isEmpty || _currentIndex >= _queue.length) return null;
    return _queue[_currentIndex];
  }

  AudioPlayerProvider() {
    _init();
  }

  Future<void> _init() async {
    // Configure audio session for better audio handling
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    // Listen to player state
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
      }
      notifyListeners();
    });

    // Listen to position changes
    _player.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    // Listen to duration changes
    _player.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });

    // Listen to current index
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        _currentIndex = index;
        if (_currentIndex < _queue.length) {
          _isLiked = _queue[_currentIndex].isLiked;
        }
        notifyListeners();
      }
    });

    // Initialize with all songs
    await _initializeQueue([...librarySongs, ...topPicks]);
  }

  Future<void> _initializeQueue(List<Song> songs) async {
    _queue = songs;

    try {
      // Create audio sources from the songs
      final sources = _queue.map((song) {
        if (song.url.startsWith('http')) {
          return AudioSource.uri(Uri.parse(song.url));
        } else {
          return AudioSource.asset(song.url);
        }
      }).toList();

      // Set the audio source
      await _player.setAudioSource(
        ConcatenatingAudioSource(children: sources),
      );

      notifyListeners();
    } catch (e) {
      print("Error initializing queue: $e");
    }
  }

  Future<void> play() async {
    try {
      await _player.play();
    } catch (e) {
      print("Error playing: $e");
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print("Error pausing: $e");
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      print("Error seeking: $e");
    }
  }

  Future<void> playSong(Song song) async {
    try {
      final index = _queue.indexWhere((s) => s.id == song.id);
      if (index != -1) {
        // If the player hasn't been initialized yet, initialize it
        if (_player.audioSource == null) {
          await _initializeQueue(_queue);
        }

        // Seek to the song
        await _player.seek(Duration.zero, index: index);
        await play();
      }
    } catch (e) {
      print("Error playing song: $e");
      // Fallback: try to play directly
      await _playSongDirectly(song);
    }
  }

  Future<void> _playSongDirectly(Song song) async {
    try {
      _queue = [song];
      _currentIndex = 0;
      _isLiked = song.isLiked;

      final source = song.url.startsWith('http')
          ? AudioSource.uri(Uri.parse(song.url))
          : AudioSource.asset(song.url);

      await _player.setAudioSource(source);
      await play();
      notifyListeners();
    } catch (e) {
      print("Error playing song directly: $e");
    }
  }

  Future<void> next() async {
    try {
      await _player.seekToNext();
    } catch (e) {
      print("Error going to next: $e");
    }
  }

  Future<void> previous() async {
    try {
      if (_position.inSeconds > 3) {
        await seek(Duration.zero);
      } else {
        await _player.seekToPrevious();
      }
    } catch (e) {
      print("Error going to previous: $e");
    }
  }

  void toggleLike() {
    if (currentSong != null) {
      _isLiked = !_isLiked;
      notifyListeners();
    }
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    _player.setShuffleModeEnabled(_isShuffle);
    notifyListeners();
  }

  void toggleLoop() {
    switch (_loopMode) {
      case LoopMode.off:
        _loopMode = LoopMode.one;
        break;
      case LoopMode.one:
        _loopMode = LoopMode.all;
        break;
      case LoopMode.all:
        _loopMode = LoopMode.off;
        break;
    }
    _player.setLoopMode(_loopMode);
    notifyListeners();
  }

  void setVolume(double volume) {
    _volume = volume;
    _player.setVolume(volume);
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AudioPlayerProvider(),
      child: MaterialApp(
        title: 'Not Apple Music',
        theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(fontSize: 10),
            unselectedLabelStyle: TextStyle(fontSize: 10),
          ),
        ),
        home: MainTabBar(),
      ),
    );
  }
}

class MainTabBar extends StatefulWidget {
  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ListenNowPage(),
    BrowsePage(),
    RadioPage(),
    LibraryPage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          // Mini Player at bottom
          Positioned(
            bottom: 60, // Above the bottom navigation bar
            left: 0,
            right: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[800]!)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              activeIcon: Icon(Icons.play_circle_filled),
              label: 'Listen Now',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              activeIcon: Icon(Icons.grid_view),
              label: 'Browse',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radio),
              activeIcon: Icon(Icons.radio),
              label: 'Radio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              activeIcon: Icon(Icons.music_note),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    );
  }
}

// Mini Player Widget
class MiniPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioPlayerProvider>(context);
    final song = provider.currentSong;

    if (song == null) {
      return SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NowPlayingScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[900]!.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            // Album Art
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: song.art.contains('album1') || song.art.contains('album2')
                    ? DecorationImage(
                  image: AssetImage(song.art),
                  fit: BoxFit.cover,
                )
                    : null,
                color: song.art.contains('album1') || song.art.contains('album2')
                    ? null
                    : Colors.blue,
              ),
            ),
            SizedBox(width: 12),

            // Song Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Play/Pause Button
            StreamBuilder<PlayerState>(
              stream: provider.player.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return IconButton(
                  icon: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: provider.togglePlayPause,
                );
              },
            ),

            // Next Button
            IconButton(
              icon: Icon(Icons.skip_next, color: Colors.white),
              onPressed: provider.next,
            ),
          ],
        ),
      ),
    );
  }
}

class ListenNowPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioPlayerProvider>(context, listen: false);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0,
          title: Text('Listen Now'),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none),
              onPressed: () {},
            ),
            SizedBox(width: 8),
            IconButton(
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 18),
              ),
              onPressed: () {},
            ),
            SizedBox(width: 8),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recently Played',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentlyPlayed.length,
                    itemBuilder: (context, index) {
                      final item = recentlyPlayed[index];
                      return Container(
                        width: 140,
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: item['color'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_circle_filled, size: 50, color: item['color']),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                item['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              item['subtitle'],
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Top Picks For You',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
        // TOP PICKS Section with your assets
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.6,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final song = topPicks[index];
                return GestureDetector(
                  onTap: () async {
                    await provider.playSong(song);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NowPlayingScreen()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Album Art
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            image: song.art.contains('album1') || song.art.contains('album2')
                                ? DecorationImage(
                              image: AssetImage(song.art),
                              fit: BoxFit.cover,
                            )
                                : null,
                            color: song.art.contains('album1') || song.art.contains('album2')
                                ? null
                                : Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  song.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  song.artist,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            song.isLiked ? Icons.favorite : Icons.favorite_border,
                                            color: song.isLiked ? Colors.pink : Colors.grey,
                                            size: 12,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            song.isDownloaded ? 'Downloaded' : 'Stream',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: topPicks.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Text(
              'Recommended For You',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: librarySongs.length,
              itemBuilder: (context, index) {
                final song = librarySongs[index];
                return GestureDetector(
                  onTap: () async {
                    await provider.playSong(song);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NowPlayingScreen()),
                    );
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Album Art with Play Button Overlay
                        Stack(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: song.art.contains('album1') || song.art.contains('album2')
                                    ? DecorationImage(
                                  image: AssetImage(song.art),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                                color: song.art.contains('album1') || song.art.contains('album2')
                                    ? null
                                    : Colors.blue,
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          song.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          song.artist,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 80), // Extra space for mini player
        ),
      ],
    );
  }
}

// Browse Page
class BrowsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0,
          title: Text('Browse'),
        ),
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final category = browseCategories[index];
                return Container(
                  decoration: BoxDecoration(
                    color: category['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(category['icon'], size: 40, color: category['color']),
                      SizedBox(height: 12),
                      Text(
                        category['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: browseCategories.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Featured Playlists',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: topPicks.length,
              itemBuilder: (context, index) {
                final song = topPicks[index];
                return Container(
                  width: 160,
                  margin: EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: song.art.contains('album1') || song.art.contains('album2')
                              ? DecorationImage(
                            image: AssetImage(song.art),
                            fit: BoxFit.cover,
                          )
                              : null,
                          color: song.art.contains('album1') || song.art.contains('album2')
                              ? null
                              : Colors.blue,
                        ),
                        child: song.art.contains('album1') || song.art.contains('album2')
                            ? null
                            : Icon(Icons.music_note, size: 60, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        song.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        song.artist,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Radio Page
class RadioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0,
          title: Text('Radio'),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildRadioCard('Apple Music 1', 'Hosted by Zane Lowe', Colors.purple),
                SizedBox(height: 12),
                _buildRadioCard('Chillhop Radio', 'Relaxing lofi beats', Colors.blue),
                SizedBox(height: 12),
                _buildRadioCard('Workout Energy', 'High energy tracks', Colors.red),
                SizedBox(height: 12),
                _buildRadioCard('Focus Study', 'Concentration music', Colors.green),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioCard(String title, String subtitle, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Icon(Icons.radio, size: 40, color: Colors.white),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'PLAY NOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Library Page
class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioPlayerProvider>(context, listen: false);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0,
          title: Text('Library'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
            SizedBox(width: 8),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLibrarySection('Playlists', Icons.playlist_play),
                SizedBox(height: 20),
                _buildLibrarySection('Artists', Icons.person),
                SizedBox(height: 20),
                _buildLibrarySection('Albums', Icons.album),
                SizedBox(height: 20),
                _buildLibrarySection('Songs', Icons.music_note),
                SizedBox(height: 20),
                _buildLibrarySection('Downloaded', Icons.download),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Recently Added',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final song = [...librarySongs, ...topPicks][index];
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: song.art.contains('album1') || song.art.contains('album2')
                        ? DecorationImage(
                      image: AssetImage(song.art),
                      fit: BoxFit.cover,
                    )
                        : null,
                    color: song.art.contains('album1') || song.art.contains('album2')
                        ? null
                        : Colors.blue,
                  ),
                  child: song.art.contains('album1') || song.art.contains('album2')
                      ? null
                      : Icon(Icons.music_note, color: Colors.white),
                ),
                title: Text(
                  song.title,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  song.artist,
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (song.isDownloaded)
                      Icon(Icons.download_done, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                onTap: () async {
                  await provider.playSong(song);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NowPlayingScreen()),
                  );
                },
              );
            },
            childCount: librarySongs.length + topPicks.length,
          ),
        ),
      ],
    );
  }

  Widget _buildLibrarySection(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}

// Search Page
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0,
          title: Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Artists, songs, lyrics, and more',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browse Categories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: browseCategories.map((category) {
                    return Chip(
                      backgroundColor: category['color'].withOpacity(0.2),
                      label: Text(
                        category['title'],
                        style: TextStyle(color: Colors.white),
                      ),
                      avatar: Icon(category['icon'], color: category['color'], size: 20),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NowPlayingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioPlayerProvider>(context);
    final song = provider.currentSong;

    if (song == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            'No song playing',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Album Art with Gradient
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.purple.withOpacity(0.3),
                        Colors.black,
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: song.art.contains('album1') || song.art.contains('album2')
                          ? DecorationImage(
                        image: AssetImage(song.art),
                        fit: BoxFit.cover,
                      )
                          : null,
                      color: song.art.contains('album1') || song.art.contains('album2')
                          ? null
                          : Colors.blue,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Controls
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              children: [
                // Song Info
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            song.artist,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        provider.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: provider.isLiked ? Colors.pink : Colors.white,
                      ),
                      onPressed: provider.toggleLike,
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Progress Bar
                StreamBuilder<Duration>(
                  stream: provider.player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration = provider.duration;

                    return Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 3,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.grey[800],
                            thumbColor: Colors.white,
                          ),
                          child: Slider(
                            value: position.inSeconds.toDouble(),
                            min: 0,
                            max: duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 100,
                            onChanged: (value) {
                              provider.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 30),

                // Main Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shuffle, color: provider.isShuffle ? Colors.pink : Colors.grey),
                      onPressed: provider.toggleShuffle,
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_previous, size: 40, color: Colors.white),
                      onPressed: provider.previous,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(
                          provider.isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                          color: Colors.black,
                        ),
                        onPressed: provider.togglePlayPause,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next, size: 40, color: Colors.white),
                      onPressed: provider.next,
                    ),
                    IconButton(
                      icon: Icon(
                        _getLoopIcon(provider.loopMode),
                        color: provider.loopMode != LoopMode.off ? Colors.pink : Colors.grey,
                      ),
                      onPressed: provider.toggleLoop,
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // Volume and Queue
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_up, color: Colors.grey),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Slider(
                        value: provider.volume,
                        onChanged: provider.setVolume,
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey[800],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.queue_music, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Bottom Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.laptop_mac, color: Colors.grey),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.lyrics, color: Colors.grey),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.list, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  IconData _getLoopIcon(LoopMode mode) {
    switch (mode) {
      case LoopMode.off:
        return Icons.repeat;
      case LoopMode.one:
        return Icons.repeat_one;
      case LoopMode.all:
        return Icons.repeat;
    }
  }
}