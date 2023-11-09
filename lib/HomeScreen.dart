import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ml_facemask_detector/scanController.dart';



class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('ML Objector- TensorFlowLite', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.purple,
        ),
        body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            print("LABEL IS ${controller.label}");
            return controller.isCameraInitialized.value
                ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      CameraPreview(controller.cameraController),
                      Positioned(
                        bottom: 80,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.purple,
                              width: 4.0,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                color: Colors.red,
                                child: Text(
                                  "Object: ${controller.label.toUpperCase()}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 25,color:Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text("Object Detector"),
                  ),
                ],
              ),
            )
                : const Stack(
              children: [
                Center(child: Text("Loading Preview...")),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Object Detector"),
                      SizedBox(
                        height: 35,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}