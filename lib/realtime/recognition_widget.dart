import 'package:flutter/material.dart';

class RecognitionWidget extends StatefulWidget {
  final List<dynamic>? currentRecognition;
  const RecognitionWidget({Key? key, this.currentRecognition}) : super(key: key);

  @override
  _RecognitionState createState() => _RecognitionState();
}


class _RecognitionState extends State<RecognitionWidget> {

  Widget titleWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 20, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[
          Text(
            "Recognitions",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _contentWidget() {
    var width = MediaQuery.of(context).size.width;
    var padding = 20.0;
    var labelWitdth = 150.0;
    var labelConfidence = 30.0;
    var barWitdth = width - labelWitdth - labelConfidence - padding * 2.0;

    if (widget.currentRecognition!.isNotEmpty) {
      return SizedBox(
        height: 145,
        child: ListView.builder(
          itemCount: widget.currentRecognition!.length,
          itemBuilder: (context, index) {
            if (widget.currentRecognition!.length > index) {
              return SizedBox(
                height: 40,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: padding, right: padding),
                      width: labelWitdth,
                      child: Text(
                        widget.currentRecognition![index]['label'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: barWitdth,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        value: widget.currentRecognition![index]['confidence'],
                      ),
                    ),
                    SizedBox(
                      width: labelConfidence,
                      child: Text(
                        (widget.currentRecognition![index]['confidence'] * 100)
                                .toStringAsFixed(0) +
                            '%',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),

                      ),
                    )
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      );
    } else {
      return const Text('');
    }
  }

  @override
  void initState() {
    super.initState();
    // starts the streaming to tensorflow results
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF120320),
                ),
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    // shows recognition title
                    titleWidget(),

                    // shows recognitions list
                    _contentWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
