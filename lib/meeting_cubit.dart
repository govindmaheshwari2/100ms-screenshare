import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:test/hms_sdk_interactor.dart';
import 'package:test/service.dart';
import 'package:tuple/tuple.dart';

class MeetingCubit extends Cubit<Tuple4<List<HMSVideoTrack>, bool, bool, int>>
    implements HMSUpdateListener, HMSActionResultListener {
  MeetingCubit() : super(const Tuple4([], false, false, 0));

  List<HMSVideoTrack> tracks = [];
  bool isScreenShareOn = false;
  bool meetingJoin = false;
  late HMSSDKInteractor hmssdkInteractor;

  initMeeting() {
    hmssdkInteractor = HMSSDKInteractor();
    hmssdkInteractor.addUpdateListener(this);
  }

  joinMeeting(String name, String roomLink) async {
    List<String?>? token =
        await RoomService().getToken(user: name, room: roomLink);
    if (token == null) return false;
    HMSConfig config = HMSConfig(authToken: token[0]!, userName: name);
    await hmssdkInteractor.join(config: config);
  }

  startScreenShare() {
    if (isScreenShareOn) {
      hmssdkInteractor.stopScreenShare();
    } else {
      hmssdkInteractor.startScreenShare();
    }
    isScreenShareOn = !isScreenShareOn;
  }

  leave() {
    hmssdkInteractor.leave(hmsActionResultListener: this);
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // TODO: implement onChangeTrackStateRequest
  }

  @override
  void onHMSError({required HMSException error}) {
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
    meetingJoin = true;
    emit(Tuple4(tracks, meetingJoin, isScreenShareOn, tracks.length));
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
        if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
          tracks.add(track as HMSVideoTrack);
          emit(Tuple4(tracks, meetingJoin, isScreenShareOn, tracks.length));
        }
        break;
      case HMSTrackUpdate.trackRemoved:
        if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
          tracks.remove(track as HMSVideoTrack);
          emit(Tuple4(tracks, meetingJoin, isScreenShareOn, tracks.length));
        }
        break;
    }
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // TODO: implement onUpdateSpeakers
  }
}
