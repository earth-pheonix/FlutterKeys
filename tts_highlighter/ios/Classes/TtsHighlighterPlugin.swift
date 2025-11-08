import Flutter
import UIKit
import AVFoundation

@MainActor
public class TtsHighlighterPlugin: NSObject, FlutterPlugin, AVSpeechSynthesizerDelegate {
    private var eventSink: FlutterEventSink?
    private let synthesizer = AVSpeechSynthesizer()
    private var channel: FlutterMethodChannel?

    override init() {
        super.init()
        // Ensure audio session allows TTS with pitch control
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)

        if #available(iOS 17.0, *) {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(voicesDidChange),
                                           name: AVSpeechSynthesizer.availableVoicesDidChangeNotification,
                                           object: nil)
        }
    }

    @objc func voicesDidChange() {
    channel?.invokeMethod("voicesChanged", arguments: nil)
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tts_highlighter_plugin", binaryMessenger: registrar.messenger())
        let instance = TtsHighlighterPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)

        let eventChannel = FlutterEventChannel(name: "tts_highlighter_events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)

        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
       case "speak":
    if let args = call.arguments as? [String: Any], let text = args["text"] as? String {
        DispatchQueue.main.async {
            let utterance = AVSpeechUtterance(string: text)

            // Rate (optional)
            if let rateArg = args["rate"] as? NSNumber {
                utterance.rate = rateArg.floatValue
            }

            // Pitch multiplier (optional)
            if let pitchArg = args["pitch"] as? NSNumber {
                utterance.pitchMultiplier = pitchArg.floatValue
            }

            // Voice
            if let voiceID = args["voice"] as? String,
               let voice = AVSpeechSynthesisVoice(identifier: voiceID) {
                utterance.voice = voice
            }

            self.synthesizer.speak(utterance)
        }
    }
    result(nil)

        case "stop":
            synthesizer.stopSpeaking(at: .immediate)
            result(nil)

        case "pause":
            synthesizer.pauseSpeaking(at: .immediate)
            result(nil)

        case "resume":
            synthesizer.continueSpeaking()
            result(nil)

        case "setLanguage":
            result(nil)

        case "awaitSpeakCompletion":
            if let dict = call.arguments as? [String: Any], let flag = dict["await"] as? Bool, flag {
                self.waitUntilNotSpeaking(result: result)
            } else if let flag = call.arguments as? Bool, flag {
                self.waitUntilNotSpeaking(result: result)
            } else {
                result(nil)
            }

       case "getVoices":
       print("got voices")
    if #available(iOS 17.0, *) {
        // Request Personal Voice authorization first
        AVSpeechSynthesizer.requestPersonalVoiceAuthorization { status in
            var voices: [[String: Any]] = []

            // Build the full voice list (including Personal Voices if authorized)
            for v in AVSpeechSynthesisVoice.speechVoices() {
                voices.append([
                    "name": v.name,
                    "identifier": v.identifier,
                    "language": v.language,
                    "isCompact": v.identifier.contains("compact")
                ])
            }

            // Return voices on main thread
            DispatchQueue.main.async {
                result(voices)
            }
        }
    } else {
        // iOS < 17 fallback
        var voices: [[String: Any]] = []
        for v in AVSpeechSynthesisVoice.speechVoices() {
            voices.append([
                "name": v.name,
                "identifier": v.identifier,
                "language": v.language,
                "isCompact": v.identifier.contains("compact")
            ])
        }
        result(voices)
    }

        case "requestPersonalVoiceAuthorization":
            if #available(iOS 17.0, *) {
                AVSpeechSynthesizer.requestPersonalVoiceAuthorization { status in
                    switch status {
                    case .authorized:
                        // User granted permission to use Personal Voices
                        result(true)
                    case .denied, .notDetermined:
                        // User denied, , or hasn't responded yet
                        result(false)
                    @unknown default:
                        result(false)
                    }
                }
            } else {
                // Personal Voices not available on iOS < 17
                result(false)
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func waitUntilNotSpeaking(result: @escaping FlutterResult) {
        if synthesizer.isSpeaking {
            DispatchQueue.global().async {
                while self.synthesizer.isSpeaking { Thread.sleep(forTimeInterval: 0.05) }
                DispatchQueue.main.async { result(nil) }
            }
        } else {
            result(nil)
        }
    }
}

// Event stream for word highlighting
extension TtsHighlighterPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        synthesizer.delegate = self
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}

// AVSpeechSynthesizerDelegate -> push lifecycle events to Dart
extension TtsHighlighterPlugin {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        channel?.invokeMethod("onStart", arguments: nil)
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        channel?.invokeMethod("onComplete", arguments: nil)
        eventSink?(["event": "speechFinished"])
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        channel?.invokeMethod("onPause", arguments: nil)
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        channel?.invokeMethod("onResume", arguments: nil)
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        channel?.invokeMethod("onCancel", arguments: nil)
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                  willSpeakRangeOfSpeechString characterRange: NSRange,
                                  utterance: AVSpeechUtterance) {
        if let text = utterance.speechString as NSString? {
            eventSink?([
                "word": text.substring(with: characterRange),
                "start": characterRange.location,
                "length": characterRange.length
            ])
        }
    }
}