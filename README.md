# starter_tflite_classification_model
This project is an example of integration between tflite model and flutter mobile application framework.
 Resourcecs:
 1. [tflite model maker]
 2. [Official package for tflite]
 3. [My answer on some issues related to tflite package]
 
   [tflite model maker]: <https://www.tensorflow.org/lite/models/modify/model_maker/image_classification?hl=en>
   [Official package for tflite]: <https://pub.dev/packages/tflite>
   [My answer on some issues related to tflite package]: <https://stackoverflow.com/a/73624706/19933098>
   
 ## How to use this project?
 1. Clone it 
 ```sh
git clone https://github.com/MOo207/starter_tflite_classification_model.git
```
2. Get dependencies
```sh
flutter pub get
```
3. When you export your model, jsut copy it in _assets/model_ and update _pubspec_ if required
4. Change _tf_model_config.dart_ but make sure that your model is quantized to *float16*
```dart
class TFModelConfig {
  // TODO: change the model here
  static const assetsModel = "assets/model/model.tflite";
  // TODO: Change the labels here
  static const assetsLabels = "assets/model/labels.txt";
  // TODO: change your assets also
}
```
5. Run the project
```sh
flutter run
```
6. You will have all use cases for using tflite with flutter (run on image, run on frame)
