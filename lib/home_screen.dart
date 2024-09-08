import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/song_controller.dart';
import 'package:music_player/controller/statoc_data.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
 
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GetBuilder<PlayerController>(builder: (obj) {
      return Scaffold(
        body: GestureDetector(
           onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            Navigator.pop(context);
          }
        },
          child: Container(
            height: height,
            width: width,
            color: Colors.red,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                // on top music label
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.07,
                    ),
                    IconButton(
                       onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.keyboard_arrow_down_outlined,
                      color: Colors.white,
                    )),
                     
                    
                    SizedBox(
                      width: width * 0.2,
                    ),
                    Container(
                      height: height * 0.04,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 146, 64, 58)),
                      child: Center(
                          child: Text(
                        "Music",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.08,
                ),
                //center image and add
                Container(
                  height: height * 0.4,
                  width: width * 0.8,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 156, 147),
                      borderRadius: BorderRadius.circular(20)),
                  child: CarouselSlider(
                    items: [
                      // Your carousel items go here
                      Container(
                        color: Colors.red,
                        
                      ),
                      Container(
                        color: Colors.blue,
                        child: Center(child: Text('Slide 2')),
                      ),
                      Container(
                        color: Colors.green,
                        child: Center(child: Text('Slide 3')),
                      ),
                    ],
                    options: CarouselOptions(
                      height: 300.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval:
                          Duration(seconds: 5), // Set the interval for slow speed
                      autoPlayAnimationDuration: Duration(milliseconds: 100),
                      aspectRatio: 10 / 5,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                    ),
                    // Icon(Icons.music_note,size: height*0.1,color: Colors.white,),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                // name and the favourite icon
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.21,
                    ),
                    Container(
                        height: height * 0.05,
                        width: width * 0.55,
                        // color: Colors.amber,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Text( 
                            StaticData.data![obj.playindex.value].displayNameWOExt,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.022),
                          ),
                        )),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: height * 0.04,
                    )
                  ],
                ),
                Text( 
                  StaticData.data![obj.playindex.value].artist.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                // duration meter and time
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(obj.position.value.toString()),
                      Expanded(
                        // height: height * 0.01,
                        // width: width * 0.75,
                        child: Slider(
                            activeColor: Colors.purple,
                            min: Duration(seconds: 0).inSeconds.toDouble(),
                            max: obj.max.value,
                            value: obj.value.value,
                            onChanged: (newvalue) {
                              obj.changeDurationtoseconds(newvalue.toInt());
                              newvalue = newvalue;
                            }),
                      ),
                      Text(obj.duration.value.toString())
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.07,
                ),
                // play pause function
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.repeat,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (StaticData.data![obj.playindex.value] != 0 &&
                              obj.playindex.value != 0) {
                            obj.playsong(StaticData.data![obj.playindex.value - 1].uri,
                                obj.playindex.value - 1);
                                setState(() {
                                  StaticData.songname=StaticData.data![obj.playindex.value].displayNameWOExt;
                                });
                          } else {
                            print("hello");
                          }
                        },
                        icon: Icon(
                          Icons.skip_previous_outlined,
                          color: Colors.white,
                          size: height * 0.05,
                        ),
                      ),
                      Container(
                        height: height * 0.08,
                        width: width * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Color.fromARGB(255, 184, 168, 168),
                                width: 4)),
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
                      IconButton(
                        onPressed: () {
                          obj.playsong(StaticData.data![obj.playindex.value + 1].uri,
                              obj.playindex.value + 1);
                              setState(() {
                                  StaticData.songname=StaticData.data![obj.playindex.value].displayNameWOExt;
                                });
                        },
                        icon: Icon(
                          Icons.skip_next_outlined,
                          color: Colors.white,
                          size: height * 0.05,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.repeat,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
// flutter pub run flutter_launcher_icons:main
// flutter pub run flutter_launcher_icons