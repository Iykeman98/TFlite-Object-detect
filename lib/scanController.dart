import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';



class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFlite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  // var x, y, w , h = 0.0;

  var x = 0.0;
  var y = 0.0;
  var w = 0.0;
  var h = 0.0;

  var width = 0.0;
  var height = 0.0;
  var left = 0.0;
  var top = 0.0;
  var right = 0.0;
  var bottom = 0.0;

  var label = "";

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(
        cameras[
        0], // cameras[0] means the rear camera while cameras[1] means the front camera
        ResolutionPreset.max,
      );

      await cameraController.initialize().then(
            (value) {
          cameraController.startImageStream(
                (image) {
              cameraCount++;
              if (cameraCount % 10 == 0) {
                cameraCount = 0;
                objectDetector(image);
              }
              update();
            },
          );
        },
      );
      isCameraInitialized(true);
      update();
    } else {
      print("Permission Denied");
    }
  }

  initTFlite() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map(
            (e) {
          return e.bytes;
        },
      ).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      rotation: 90,
      threshold: 0.1,
    );

    if (detector != null) {
      log("Result is $detector");
      var ourDetectedObject = detector.first;
      if (ourDetectedObject['confidence'] * 100 > 45) {
        label = detector.first['label'].toString();

        try {
          h = ourDetectedObject["rect"]["h"];
          w = ourDetectedObject["rect"]["w"];
          x = ourDetectedObject["rect"]["x"];
          y = ourDetectedObject["rect"]["y"];
        } catch (e) {
          print("ERROR IS $e");
        }

        // h = ourDetectedObject['h'];
        // w = ourDetectedObject['w'];
        // x = ourDetectedObject['x'];
        // y = ourDetectedObject['y'];
        //
        // var boundingBox = detector.first['boundingBox'];
        // left = boundingBox['left'];
        // top = boundingBox['top'];
        // right = boundingBox['right'];
        // bottom = boundingBox['bottom'];
        //
        // width = right - left;
        // height = bottom - top;
      }

      // print("HEIGHT IS ${detector.first["rect"]['h']}");
      update();
      print("HEIGHT IS $height");
    }

    // if (detector != null) {
    //   log("Result is $detector");
    // }
  }
}