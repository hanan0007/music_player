import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/song_controller.dart';
import 'package:music_player/controller/statoc_data.dart';
import 'package:music_player/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  @override
  void initState() {
    // TODO: implement initState
    Get.put(PlayerController());
     fetchSongs().then((fetchedSongs) {
      setState(() {
        songs = fetchedSongs;
        

      });
    });

    super.initState();
  }

  var height, width;
  int index = 0;
  bool isplay = false;
  var songname = '';
  late List<SongModel> songs = [];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    PageController controller = PageController();
    return GetBuilder<PlayerController>(builder: (obj) {
      return Scaffold(
        body: Container(
          height: height,
          width: width,
          color: Colors.black,
          child: Column(
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              //my music
              Row(
                children: [
                  SizedBox(
                    width: width * 0.05,
                  ),
                  Text(
                    "My Music",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.04),
                  )
                ],
              ),
              // pageview for favourite and all songs
              Container(
                height: height * 0.07,
                width: width * 0.9,
                // color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //all songs
                    InkWell(
                      onTap: () {
                        controller.jumpToPage(index = 0);
                      },
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.3,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: index == 0
                                    ? Colors.grey.withOpacity(0.5)
                                    : Colors.black,
                                spreadRadius: 4,
                                blurRadius: 7,
                                offset: const Offset(
                                    1, 0), // changes the shadow direction
                              ),
                            ],
                            color: index == 0
                                ? Colors.black
                                : const Color.fromARGB(255, 51, 49, 49),
                            border: Border.all(
                                color: index == 0
                                    ? Colors.white
                                    : const Color.fromARGB(255, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          "All Songs",
                          style: TextStyle(
                              color: index == 0
                                  ? Colors.white
                                  : const Color.fromARGB(255, 158, 158, 158),
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    // fav
                    InkWell(
                      onTap: () {
                        controller.jumpToPage(index = 1);
                        // test();
                      },
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.3,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: index == 1
                                    ? Colors.grey.withOpacity(0.5)
                                    : Colors.black,
                                spreadRadius: 4,
                                blurRadius: 7,
                                offset: const Offset(
                                    1, 0), // changes the shadow direction
                              ),
                            ],
                            color: index == 1
                                ? Colors.black
                                : const Color.fromARGB(255, 51, 49, 49),
                            border: Border.all(
                                color: index == 1
                                    ? Colors.white
                                    : const Color.fromARGB(255, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          "Favourite",
                          style: TextStyle(
                              color: index == 1
                                  ? Colors.white
                                  : const Color.fromARGB(255, 158, 158, 158),
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: height * 0.01,
                width: width * 0.9,
                child: Divider(),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              // pageview
              Container(
                height: height * 0.6,
                width: width * 0.9,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  onPageChanged: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  children: [
                    // all songs list
                    Container(
                      height: height * 0.7,
                      width: width,
                      color: Colors.black,
                      child: songs == null
        ? Center(child: CircularProgressIndicator())
        : songs.isEmpty
            ? Center(child: Text('No songs found')):
                            //
                             Center(
                              child: ListView.builder(
                                itemCount: songs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      height: height * 0.08,
                                      width: width,
                                      decoration: BoxDecoration(
                                        //  color: Colors.amber,

                                        border: obj.playindex.value == index
                                            ? Border.all(color: Colors.red)
                                            : null,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 7,
                                            offset: const Offset(1,
                                                0), // changes the shadow direction
                                          ),
                                        ],
                                      ),
                                      child: Obx(
                                        () =>  ListTile(
                                          title: Text(
                                            songs[index].displayNameWOExt,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: obj.playindex.value == index
                                                  ? Colors.red
                                                  : Colors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${songs[index].artist}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          leading: QueryArtworkWidget(
                                            id: songs[index].id,
                                            type: ArtworkType.AUDIO,
                                            nullArtworkWidget: Icon(
                                              Icons.music_note,
                                              color:
                                                  obj.playindex.value == index &&
                                                          obj.isplaying.value
                                                      ? Colors.red
                                                      : Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                          trailing: obj.playindex.value ==
                                                      index &&
                                                  obj.isplaying.value
                                              ? Icon(
                                                  Icons.play_arrow,
                                                  size: 26,
                                                  color: obj.playindex.value ==
                                                              index &&
                                                          obj.isplaying.value
                                                      ? Colors.red
                                                      : Colors.white,
                                                )
                                              : null,
                                          onTap: () {
                                            // Get.to(())
                                            Get.to(() => HomeScreen());
                                            StaticData.data = songs;
                                            obj.playsong(
                                                songs[index].uri, index);
                                              
                                            StaticData.songname = songs[index].displayNameWOExt;
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              //list complete
                            )
                            //
                    ),
                          
                     
                    
                    //favourite songs liat
                    Container(
                      height: height * 0.7,
                      width: width,
                      color: Colors.blue,
        //               child:  songs == null
        // ? Center(child: CircularProgressIndicator())
        // : songs.isEmpty
        //     ? Center(child: Text('No songs found'))
        //     : Center(
        //         child: ListView.builder(
        //           itemCount: songs.length,
        //           itemBuilder: (context, index) {
        //             return ListTile(
        //               title: Text(songname),
        //               // Add other ListTile properties as needed
        //             );
        //           },
        //         ),
        //       ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              // play pause function design
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => HomeScreen(),
                  //     ));
                  // animation
                  
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return HomeScreen();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOutQuart;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                  // animation
                  //  Get.to(() => HomeScreen(

                  //                             ));
                },
                child:  Container(
                  height: height * 0.08,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: Stack(
                    children: [
                      Container(
                          height: height * 0.08,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: const Offset(
                                    1, 0), // changes the shadow direction
                              ),
                            ],
                            color: const Color.fromARGB(255, 158, 158, 158),
                          ),
                          child: obj.isplaying.value
                              ? Center(
                                  child: WaveWidget(
                                    config: CustomConfig(
                                      gradients: [
                                        [Colors.black, Colors.purple.shade200],
                                        [Colors.black, Colors.black],
                                      ],
                                      durations: [35000, 19440],
                                      heightPercentages: [0.25, 0.30],
                                      gradientBegin: Alignment.bottomLeft,
                                      gradientEnd: Alignment.topRight,
                                    ),
                                    waveAmplitude: 1,
                                    size: const Size(double.infinity, 200),
                                    waveFrequency: 5,
                                    backgroundColor: const Color.fromARGB(
                                        255, 158, 158, 158),
                                    wavePhase: 20.0,
                                  ),
                                )
                              : null),
                      SizedBox(
                        width: width * 0.08,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: width * 0.6,
                          child: Text(
                            StaticData.songname.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.12,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: height * 0.08,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 184, 168, 168),
                                  width: 4)),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: IconButton(
                              onPressed: () {
                                if (obj.isplaying.value) {
                                  obj.audioPlayer.pause();
                                  obj.updateplaypausebutton(false);
                                } else {
                                  obj.audioPlayer.play();
                                  obj.updateplaypausebutton(true);
                                }
                              },
                              icon: Icon(
                                obj.isplaying.value
                                    ? Icons.pause
                                    : Icons.play_arrow_outlined,
                                color: Colors.white,
                                size: height * 0.05,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
  // void test() async {
  //   final plugin = DeviceInfoPlugin();
  //   final android = await plugin.androidInfo;

  //   final storageStatus = android.version.sdkInt < 33
  //       ? await Permission.storage.request()
  //       : PermissionStatus.granted;

  //   if (storageStatus == PermissionStatus.granted) {
  //     print("granted");
  //   }
  //   if (storageStatus == PermissionStatus.denied) {
  //     print("denied");
  //   }
  //   if (storageStatus == PermissionStatus.permanentlyDenied) {
  //     openAppSettings();
  //   }
  // }
  Future<List<SongModel>> fetchSongs() async {
    final audioQuery = OnAudioQuery();
    try {
      List<SongModel> fetchedSongs = await audioQuery.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
        ignoreCase: true,
        sortType: null,
        uriType: UriType.EXTERNAL,
      );

      return fetchedSongs;
    } catch (error) {
      // Handle error if needed
      print('Error fetching songs: $error');
      return [];
    }
  }
}
