import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../helper/date_converter_helper.dart';
import 'call_manager.dart';
import 'call_widgets.dart';

class VoiceCallScreen extends StatefulWidget {
  final int userId;
  final String userType;
  final String name;
  final String image;

  const VoiceCallScreen({
    super.key,
    required this.userId,
    required this.userType,
    required this.name,
    required this.image,
  });

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  bool isMuted = false;
  bool isSpeakerOn = false;
  bool _inCall = false; // false means call not yet accepted/connected
  Duration _inCallTime = Duration.zero;
  Timer? _inCallTimer;

  final CallManager callManager = Get.find<CallManager>();

  final AudioPlayer _audioPlayer = AudioPlayer();

  Timer? _callTimeOut; // Timer to enforce the 30 seconds call limit

  @override
  void initState() {
    super.initState();
    // Set up the call manager callback for when the call is connected.
    callManager.setOnCallConnected(_onCallConnected);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Play the looping tone
    _playTone();
    // Start the timeout timer.
    _startCallTimeout();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    callManager.clearCallbacks();
    _audioPlayer.stop();
    _callTimeOut?.cancel();
    _inCallTimer?.cancel();
    super.dispose();
  }

  void _playTone() async {
    if (_inCall) return; // Don't play if already in call
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.play(AssetSource('calling.mp3'));
  }

  /// Start a timer that will end the call if not connected within 30 seconds.
  void _startCallTimeout() {
    _callTimeOut = Timer(const Duration(seconds: 30), () {
      if (!_inCall) {
        // Timeout reached without receiving the call
        callManager.endCall();
        _audioPlayer.stop();
      }
    });
  }

  /// Call this method when the call is successfully connected.
  void _onCallConnected() {
    setState(() {
      _inCall = true;
    });
    // Cancel the timeout since the call has been connected.
    _callTimeOut?.cancel();
    // Stop the calling tone.
    _audioPlayer.stop();
    // Start counting call duration
    _startInCallTimer();
  }

  void _toggleMute() {
    // Only allow toggling if call is connected
    if (!_inCall) return;
    setState(() {
      isMuted = !isMuted;
    });
    callManager.toggleMicrophone(isMuted);
  }

  void _toggleSpeaker() {
    // Only allow toggling if call is connected
    if (!_inCall) return;
    setState(() {
      isSpeakerOn = !isSpeakerOn;
    });
    callManager.toggleSpeaker(isSpeakerOn);
  }

  void _startInCallTimer() {
    _inCallTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _inCallTime += const Duration(seconds: 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(widget.image),
              ),
              const SizedBox(height: 24),
              Text(
                widget.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Change text based on call status
              Text(
                _inCall ? "In Call" : "Calling...",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              if (_inCall)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateConverterHelper.formatDuration(_inCallTime),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Buttons remain visible, but onTap won't do anything if the call isn't connected
                    CallControlButton(
                      icon: isMuted ? Icons.mic_off : Icons.mic,
                      color: isMuted ? Colors.red : Colors.white,
                      background: const Color(0xFF2C2C2E),
                      onTap: _toggleMute,
                    ),
                    CallControlButton(
                      icon: Icons.call_end,
                      color: Colors.red,
                      background: Colors.white,
                      onTap: () {
                        callManager.endCall(
                            userId: widget.userId, userType: widget.userType);
                      },
                    ),
                    CallControlButton(
                      icon: isSpeakerOn ? Icons.volume_up : Icons.hearing,
                      color: isSpeakerOn ? Colors.green : Colors.white,
                      background: const Color(0xFF2C2C2E),
                      onTap: _toggleSpeaker,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
