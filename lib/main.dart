import 'dart:io';

import 'package:bloom/realtime/home.dart';
import 'package:bloom/tf_model_config.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error: $e.code\nError Message: $e.message');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isImageLoaded = false;
  bool modelLoaded = false;
  File? pickedImage;
  double? confidence;
  String? label;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  void loadModel() async {
    await Tflite.loadModel(
      model: TFModelConfig.assetsModel,
      labels: TFModelConfig.assetsLabels,
    ).onError(
      (error, stackTrace) {
        debugPrint(error.toString());
        return null;
      },
    ).then(
      (value) {
        setState(() {
          modelLoaded = true;
        });
      },
    );
  }

  grabImage(ImageSource source) async {
    var tempStore = await ImagePicker().pickImage(source: source);
    setState(() {
      if (tempStore != null) {
        pickedImage = File(tempStore.path);
        isImageLoaded = true;
        applyModelOnImage(pickedImage!);
      } else {
        isImageLoaded = false;
        debugPrint('Please select an Image to test');
      }
    });
  }

  applyModelOnImage(File file) async {
    var res = await Tflite.runModelOnImage(
      path: file.path,
      numResults: 2,
      threshold: 0.001,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    debugPrint(res.toString());
    setState(() {
      confidence = res![0]['confidence'] * 100;
      label = res[0]['label'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TFlite classification Model'),
      ),
      body: modelLoaded
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                isImageLoaded
                    ? Column(
                        children: [
                          const SizedBox(height: 50),
                          SizedBox(
                            height: 250,
                            width: 500,
                            child: isImageLoaded
                                ? Image.file(
                                    pickedImage!,
                                    fit: BoxFit.contain,
                                  )
                                : const Text(
                                    'Please select an Image to test',
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                          Text(
                            '$label : ${confidence?.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'TFlite classification Model model is loaded\nPlease select an Image to test',
                        textAlign: TextAlign.center,
                      ),
              ],
            )
          : const CircularProgressIndicator(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "real-time",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage(cameras)));
            },
            tooltip: 'Real Time',
            child: const Icon(Icons.live_tv),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "camera",
            onPressed: () {
              grabImage(ImageSource.camera);
            },
            tooltip: 'Camera',
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "gallery",
            onPressed: () {
              grabImage(ImageSource.gallery);
            },
            tooltip: 'Gallery',
            child: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}
