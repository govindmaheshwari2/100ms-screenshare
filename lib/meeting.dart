import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:test/hms_sdk_interactor.dart';
import 'package:test/service.dart';

class Meeting extends StatefulWidget {
  final String name, roomLink;
  const Meeting({required this.name, required this.roomLink, Key? key})
      : super(key: key);

  @override
  State<Meeting> createState() => _MeetingState();
}

class _MeetingState extends State<Meeting>
    implements HMSUpdateListener, HMSActionResultListener {
  late HMSSDKInteractor hmssdkInteractor;
  List<HMSVideoTrack> tracks = [];
  bool isScreenShareOn = false;

  joinRoom() async {
    List<String?>? token =
        await RoomService().getToken(user: widget.name, room: widget.roomLink);
    if (token == null) return false;
    HMSConfig config = HMSConfig(authToken: token[0]!);

    await hmssdkInteractor.join(config: config);
    hmssdkInteractor.addUpdateListener(this);
  }

  @override
  void initState() {
    hmssdkInteractor = HMSSDKInteractor();
    joinRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                hmssdkInteractor.leave(hmsActionResultListener: this);
                hmssdkInteractor.removeUpdateListener(this);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.leave_bags_at_home)),
          IconButton(
              onPressed: () {
                hmssdkInteractor.startScreenShare();
              },
              icon: const Icon(Icons.screen_share)),
          IconButton(
              onPressed: () {
                hmssdkInteractor.stopScreenShare();
              },
              icon: const Icon(Icons.stop))
        ],
      ),
      body: Column(
        children: [
          if (tracks.isNotEmpty)
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: tracks.isNotEmpty
                  ? HMSVideoView(
                      track: tracks[0],
                    )
                  : const Center(child: Text("Empty")),
            ),
          if (tracks.length > 1)
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: tracks.isNotEmpty
                  ? HMSVideoView(
                      track: tracks[1],
                    )
                  : const Center(child: Text("Empty")),
            ),
          if (tracks.length > 2)
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: tracks.isNotEmpty
                  ? HMSVideoView(
                      track: tracks[2],
                    )
                  : const Center(child: Text("Empty")),
            )
        ],
      ),
    );
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // TODO: implement onChangeTrackStateRequest
  }

  @override
  void onError({required HMSException error}) {
    // TODO: implement onError
  }

  @override
  void onException(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    // TODO: implement onException
  }

  @override
  void onJoin({required HMSRoom room}) {
    // for (HMSPeer each in room.peers!) {
    //   if (each.isLocal &&
    //       each.videoTrack != null &&
    //       each.videoTrack!.kind == HMSTrackKind.kHMSTrackKindVideo) {
    //     tracks.add(each.videoTrack!);
    //     break;
    //   }
    // }
  }

  @override
  void onLocalAudioStats(
      {required HMSLocalAudioStats hmsLocalAudioStats,
      required HMSLocalAudioTrack track,
      required HMSPeer peer}) {
    // TODO: implement onLocalAudioStats
  }

  @override
  void onLocalVideoStats(
      {required HMSLocalVideoStats hmsLocalVideoStats,
      required HMSLocalVideoTrack track,
      required HMSPeer peer}) {
    // TODO: implement onLocalVideoStats
  }

  @override
  void onMessage({required HMSMessage message}) {
    // TODO: implement onMessage
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    // TODO: implement onPeerUpdate
  }

  @override
  void onRTCStats({required HMSRTCStatsReport hmsrtcStatsReport}) {
    // TODO: implement onRTCStats
  }

  @override
  void onReconnected() {
    // TODO: implement onReconnected
  }

  @override
  void onReconnecting() {
    // TODO: implement onReconnecting
  }

  @override
  void onRemoteAudioStats(
      {required HMSRemoteAudioStats hmsRemoteAudioStats,
      required HMSRemoteAudioTrack track,
      required HMSPeer peer}) {
    // TODO: implement onRemoteAudioStats
  }

  @override
  void onRemoteVideoStats(
      {required HMSRemoteVideoStats hmsRemoteVideoStats,
      required HMSRemoteVideoTrack track,
      required HMSPeer peer}) {
    // TODO: implement onRemoteVideoStats
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // TODO: implement onRemovedFromRoom
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // TODO: implement onRoleChangeRequest
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  @override
  void onSuccess(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments}) {
    // TODO: implement onSuccess
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    switch (trackUpdate) {
      case HMSTrackUpdate.trackAdded:
        tracks.add(track as HMSVideoTrack);

        setState(() {});
        break;
      case HMSTrackUpdate.trackRemoved:
        tracks.remove(track as HMSVideoTrack);
        setState(() {});
        isScreenShareActive();
        break;
    }
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // TODO: implement onUpdateSpeakers
  }

  Future<void> isScreenShareActive() async {
    isScreenShareOn = await hmssdkInteractor.isScreenShareActive();
    print("screenshare {$isScreenShareOn}");
  }
}
