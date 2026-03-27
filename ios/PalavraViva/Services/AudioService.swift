import AVFoundation

@Observable
final class AudioService {
    var isSpeaking: Bool = false
    var isPaused: Bool = false
    var currentText: String = ""
    var progress: Double = 0

    private var synthesizer: AVSpeechSynthesizer?
    private var delegate: SpeechDelegate?
    private var totalLength: Int = 0
    private var spokenLength: Int = 0
    private var isSetup: Bool = false

    init() {}

    private func ensureSetup() {
        guard !isSetup else { return }
        isSetup = true
        let synth = AVSpeechSynthesizer()
        let del = SpeechDelegate { [weak self] in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.isSpeaking = false
                self.isPaused = false
                self.progress = 0
                self.currentText = ""
                try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            }
        } onProgress: { [weak self] range in
            Task { @MainActor [weak self] in
                guard let self, self.totalLength > 0 else { return }
                self.spokenLength = range.location + range.length
                self.progress = Double(self.spokenLength) / Double(self.totalLength)
            }
        }
        synth.delegate = del
        delegate = del
        synthesizer = synth
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.duckOthers])
            try session.setActive(true, options: [])
        } catch {}
    }

    func speak(_ text: String) {
        ensureSetup()
        guard let synthesizer else { return }

        if synthesizer.isSpeaking && currentText == text {
            if isPaused {
                synthesizer.continueSpeaking()
                isPaused = false
            } else {
                synthesizer.pauseSpeaking(at: .word)
                isPaused = true
            }
            return
        }

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        configureAudioSession()

        currentText = text
        totalLength = text.count
        spokenLength = 0
        progress = 0

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = Self.findBestVoice()
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
        utterance.pitchMultiplier = 1.05
        utterance.volume = 1.0
        utterance.prefersAssistiveTechnologySettings = false

        isSpeaking = true
        isPaused = false
        synthesizer.speak(utterance)
    }

    private static func findBestVoice() -> AVSpeechSynthesisVoice? {
        if let voice = AVSpeechSynthesisVoice(language: "pt-BR") {
            return voice
        }
        if let voice = AVSpeechSynthesisVoice(language: "pt") {
            return voice
        }
        let allVoices = AVSpeechSynthesisVoice.speechVoices()
        if let ptVoice = allVoices.first(where: { $0.language.hasPrefix("pt") }) {
            return ptVoice
        }
        return AVSpeechSynthesisVoice(language: "en-US")
    }

    func stop() {
        synthesizer?.stopSpeaking(at: .immediate)
        isSpeaking = false
        isPaused = false
        progress = 0
        currentText = ""
    }

    func isSpeakingText(_ text: String) -> Bool {
        isSpeaking && currentText == text
    }
}

nonisolated private final class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate, @unchecked Sendable {
    private let onFinish: @Sendable () -> Void
    private let onProgress: @Sendable (NSRange) -> Void

    init(onFinish: @escaping @Sendable () -> Void, onProgress: @escaping @Sendable (NSRange) -> Void) {
        self.onFinish = onFinish
        self.onProgress = onProgress
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onFinish()
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        onFinish()
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        onProgress(characterRange)
    }
}
