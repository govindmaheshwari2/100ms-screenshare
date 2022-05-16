import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:test/meeting_cubit.dart';
import 'package:tuple/tuple.dart';

class Meeting extends StatefulWidget {
  final String name, roomLink;
  const Meeting({required this.name, required this.roomLink, Key? key})
      : super(key: key);

  @override
  State<Meeting> createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetingCubit()
        ..initMeeting()
        ..joinMeeting(widget.name, widget.roomLink),
      child: BlocBuilder<MeetingCubit,
              Tuple4<List<HMSVideoTrack>, bool, bool, int>>(
          builder: (context, data) {
        return Scaffold(
            appBar: AppBar(
              title: const Text("100ms"),
              actions: [
                IconButton(
                    onPressed: () {
                      BlocProvider.of<MeetingCubit>(context).startScreenShare();
                    },
                    icon: const Icon(Icons.screenshot)),
                IconButton(
                    onPressed: () {
                      BlocProvider.of<MeetingCubit>(context).leave();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.star))
              ],
            ),
            body: !data.item2
                ? const Center(
                    child: Text("gg"),
                  )
                : Column(
                    children: [
                      if (data.item1.isNotEmpty)
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 4,
                          child: data.item1.isNotEmpty
                              ? HMSVideoView(
                                  track: data.item1[0],
                                )
                              : const Center(child: Text("Empty")),
                        ),
                      if (data.item1.length > 1)
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 4,
                          child: data.item1.isNotEmpty
                              ? HMSVideoView(
                                  track: data.item1[1],
                                )
                              : const Center(child: Text("Empty")),
                        ),
                      if (data.item1.length > 2)
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 4,
                          child: data.item1.isNotEmpty
                              ? HMSVideoView(
                                  track: data.item1[2],
                                  matchParent: false,
                                  scaleType: ScaleType.SCALE_ASPECT_FILL,
                                )
                              : const Center(child: Text("Empty")),
                        )
                    ],
                  ));
      }),
    );
  }
}
