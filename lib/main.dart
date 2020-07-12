import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  SpeechRecognition speechRecognition;
  bool isAvailable = false;
  bool isListening = false;
  bool stop = true;
  String resultText = "";

  @override
  void initState() {
    initSpeech();
    super.initState();
  }

  void initSpeech() {
    speechRecognition = SpeechRecognition();
    speechRecognition.setAvailabilityHandler((bool result) {
      setState(() {
        isAvailable = result;
      });
    });
    speechRecognition.setRecognitionStartedHandler(() {
      setState(() {
        isListening = true;
      });
    });
    speechRecognition.setRecognitionResultHandler((String speech) {
      setState(() {
        resultText = speech;
      });
    });
    speechRecognition.setRecognitionCompleteHandler(() {
      setState(() {
        isListening = false;
      });
    });
    speechRecognition.activate().then((result) {
      setState(() {
        isAvailable = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text("Speech To Text"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if(isAvailable && !isListening){
                      speechRecognition.listen(locale: "en_US").then((result){
                        print("$result");
                        setState(() {
                          stop = false;
                        });
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Start",style: TextStyle(fontSize: 20,color: Colors.white,),),
                        ),
                        Icon(Icons.keyboard_voice,color: Colors.white,),
                      ],
                    )
                  ),
                ),
                InkWell(
                  onTap: () {
                    if(isListening){
                      speechRecognition.stop().then((result){
                        resultText="";
                        setState(() {
                          isListening=result;
                          stop =true;
                        });
                      });
                    }
                  },

                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children: <Widget>[
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 16),
                           child: Text("Stop",style: TextStyle(fontSize: 20,color: Colors.white,),),
                         ),
                        Icon(Icons.stop,color: Colors.white,)
                      ],
                    )
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(.5),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Text(stop ? "" :resultText,style: TextStyle(fontSize: 18,color: Colors.blueGrey.shade900,fontWeight: FontWeight.w300),),
            ),
          ],
        ),
      ),
    );
  }
}
