import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/controller/statoc_data.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController{
  static PlayerController get to => Get.find();
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  var playindex= 0.obs ;
  var isplaying = false.obs;
  var duration= ''.obs;
  var position = ''.obs;
  var max = 0.0.obs;
  var value = 0.0.obs;
  var songname='';
  var maxduration = 0.0.obs;
  // RxList<String> songs = <String>[].obs;
   late List<SongModel> songs = [];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkpermission();
    fetchSongs().then((fetchedSongs) {
      
        songs = fetchedSongs;
      
    });
  }
  // update list
  // void setSongs(List<String> newSongs) {
  //   songs.assignAll(newSongs);
  // }
  // stime streaming
  updateposition(){
    audioPlayer.durationStream.listen((d) { 
      duration.value=d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) { 
      position.value=p.toString().split(".")[0];
      value.value =p.inSeconds.toDouble();
    });
  }
  // slider positin
  changeDurationtoseconds(seconds){
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }
  // device permisiton
  checkpermission()async{
    var perm= await Permission.storage.request();
    if(perm.isGranted)
    {
     print("grauntedddddddddddddddddddddddddd");
    }
    else{
      print("nottttttttttttttttttttttttttgrauntedddddddddddddddddddddddddd");
    }
  }
// play song function
  playsong(String? uri,  index,){
    playindex.value=index;
    updateIndex(index);
    
try{
audioPlayer.setAudioSource(
  AudioSource.uri(Uri.parse(uri!))
);
audioPlayer.play();
isplaying(true); 
updateposition();
}
on Exception catch(e){
 print(e.toString());

}
  }
  //update index
  updateIndex(int v) {
    playindex.value = v;
  
    isplaying.value;

    update();
  }
// update playing
  updateplaypausebutton(bool v) {
    
    isplaying(v);
    update();
  }
  // fetching song from device
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