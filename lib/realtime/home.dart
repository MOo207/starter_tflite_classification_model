import 'package:bloom/realtime/recognition_widget.dart';
import 'package:bloom/tf_model_config.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

import 'camera.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomePage(this.cameras, {super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions = [];

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String? res;
    res = await Tflite.loadModel(
      model: TFModelConfig.assetsModel,
      labels: TFModelConfig.assetsLabels,
    );
    debugPrint(res);
  }

  setRecognitions(recognitions) {
    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Camera(
            widget.cameras,
            setRecognitions,
          ),
          RecognitionWidget(
            currentRecognition: _recognitions,
          )
        ],
      ),
    );
  }
}
