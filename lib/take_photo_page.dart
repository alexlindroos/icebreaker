import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class TakePhotoPage extends StatefulWidget {
  @override
    _TakePhotoPageState createState() {
      return _TakePhotoPageState();
  }
}

  class _TakePhotoPageState extends State {
    CameraController controller;
    List cameras;
    int selectedCameraIdx;
    String imagePath;
  
    final GlobalKey _scaffoldKey = GlobalKey();
  
    @override
    void initState() {
      super.initState();
  
      // Get the list of available cameras.
      // Then set the first camera as selected.
      availableCameras()
      .then((availableCameras) {
        cameras = availableCameras;
  
        if (cameras.length > 0) {
          setState(() {
            selectedCameraIdx = 1;
          });
  
          _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
        }
      })
      .catchError((err) {
        print('Error: $err.code\nError Message: $err.message');
      });
    }
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Please take a picture of yourself'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Center(
                    child: imagePath == null ? _cameraPreviewWidget() : _thumbnailWidget(),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.grey,
                    width: 3.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _retakeButton(), //_cameraTogglesRowWidget(),
                  _captureControlRowWidget(),
                  _nextPage(),
                ],
              ),
            ),
          ],
        ),
      );
    }
  
    /// Display 'Loading' text when the camera is still loading.
    Widget _cameraPreviewWidget() {
      if (controller == null || !controller.value.isInitialized) {
        return const Text(
          'Loading',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w900,
          ),
        );
      }
  
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  
    Widget _retakeButton() {
      return Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: imagePath == null 
            ? SizedBox()
            : FlatButton(
              onPressed: () {
                setState(() {
                  imagePath = null;  
                });
              }, 
              child: new Text('Retake')
            ),
        ),
      );
    }

    /// Display the thumbnail of the captured image
    Widget _thumbnailWidget() {
      return Container(
        child: Align(
          alignment: Alignment.center,
          child: imagePath == null
            ? SizedBox()
            : SizedBox(
              child: Image.file(File(imagePath)),
              width: 400.0,
              height: 400.0,
            ),
        ),
      );
    }

    Widget _nextPage() {
      return Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: imagePath == null
            ? SizedBox()
            : FlatButton(onPressed: _onNextClick, child: new Text('Next')),
        ),
      );
    }
  
    /// Display the control bar with buttons to take pictures
    Widget _captureControlRowWidget() {
      return Expanded(
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt),
                color: Colors.blue,
                onPressed: controller != null &&
                    controller.value.isInitialized
                    ? _onCapturePressed
                    : null,
              )
            ],
          ),
        ),
      );
    }
  
    /// Display a row of toggle to select the camera (or a message if no camera is available).
    Widget _cameraTogglesRowWidget() {
      if (cameras == null) {
        return Row();
      }

  
      CameraDescription selectedCamera = cameras[selectedCameraIdx];
      CameraLensDirection lensDirection = selectedCamera.lensDirection;
  
      return Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: FlatButton.icon(
              onPressed: _onSwitchCamera,
              icon: Icon(
                  _getCameraLensIcon(lensDirection)
              ),
              label: Text("${lensDirection.toString()
                  .substring(lensDirection.toString().indexOf('.')+1)}")
          ),
        ),
      );
    }
  
    IconData _getCameraLensIcon(CameraLensDirection direction) {
      switch (direction) {
        case CameraLensDirection.back:
          return Icons.camera_rear;
        case CameraLensDirection.front:
          return Icons.camera_front;
        case CameraLensDirection.external:
          return Icons.camera;
        default:
          return Icons.device_unknown;
      }
    }
  
    Future _onCameraSwitched(CameraDescription cameraDescription) async {
      if (controller != null) {
        await controller.dispose();
      }
  
      controller = CameraController(cameraDescription, ResolutionPreset.high);
  
      // If the controller is updated then update the UI.
      controller.addListener(() {
        if (mounted) {
          setState(() {});
        }
  
        if (controller.value.hasError) {
          // Error
        }
      });
  
      try {
        await controller.initialize();
      } on CameraException catch (e) {
        _showCameraException(e);
      }
  
      if (mounted) {
        setState(() {});
      }
    }
  
    void _onSwitchCamera() {
      selectedCameraIdx = selectedCameraIdx < cameras.length - 1
          ? selectedCameraIdx + 1
          : 0;
      CameraDescription selectedCamera = cameras[selectedCameraIdx];
  
      _onCameraSwitched(selectedCamera);
  
      setState(() {
        selectedCameraIdx = selectedCameraIdx;
      });
    }
  
    Future _takePicture() async {
      if (!controller.value.isInitialized) {
        // Please Wait
  
        return null;
      }
  
      // Do nothing if a capture is on progress
      if (controller.value.isTakingPicture) {
        return null;
      }
  
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String pictureDirectory = '${appDirectory.path}/Pictures';
      await Directory(pictureDirectory).create(recursive: true);
      final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = '$pictureDirectory/${currentTime}.jpg';
  
      try {
        await controller.takePicture(filePath);
      } on CameraException catch (e) {
        _showCameraException(e);
        return null;
      }
  
      return filePath;
    }
  
    void _onCapturePressed() {
      _takePicture().then((filePath) {
        if (mounted) {
          setState(() {
            imagePath = filePath;
          });
  
          if (filePath != null) {
            // Picture saves
          }
        }
      });
    }

    _onNextClick() {
      // Save to firebase and go to next page
    }
  
    void _showCameraException(CameraException e) {
      String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
      print(errorText);
  
      // Error
    }
  }