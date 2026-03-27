import SwiftUI

struct GabrielChatView: View {
    @State private var viewModel = GabrielViewModel()
    @State private var audioService = AudioService()
    @FocusState private var isInputFocused: Bool
    @State private var showClearConfirmation: Bool = false

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)
    private let bgColor = Color(red: 0.07, green: 0.07, blue: 0.08)

    var body: some View {
        VStack(spacing: 0) {
            chatMessages
            if audioService.isSpeaking {
                audioPlayerBar
            }
            inputBar
        }
        .background(bgColor)
        .navigationTitle("Gabriel")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                ZStack {
                    Circle()
                        .fill(accentRed.opacity(0.15))
                        .frame(width: 32, height: 32)
                    Image(systemName: "sparkle")
                        .font(.caption.bold())
                        .foregroundStyle(accentRed)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        showClearConfirmation = true
                    } label: {
                        Label("Limpar Conversa", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .confirmationDialog("Limpar conversa?", isPresented: $showClearConfirmation) {
            Button("Limpar", role: .destructive) {
                audioService.stop()
                viewModel.clearChat()
            }
        } message: {
            Text("Toda a conversa com Gabriel será apagada.")
        }
    }

    private var chatMessages: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    gabrielHeader
                        .padding(.bottom, 8)

                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message, audioService: audioService)
                            .id(message.id)
                    }

                    if viewModel.isLoading, let last = viewModel.messages.last, last.content.isEmpty {
                        TypingIndicator()
                            .id("typing")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: viewModel.messages.count) { _, _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    if let last = viewModel.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
            .onChange(of: viewModel.messages.last?.content) { _, _ in
                if let last = viewModel.messages.last {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            }
        }
    }

    private let suggestionChips: [(icon: String, text: String)] = [
        ("heart.fill", "Estou precisando de conforto"),
        ("questionmark.circle", "Tenho uma dúvida bíblica"),
        ("sun.max.fill", "Me dê uma palavra para hoje"),
        ("hands.sparkles", "Ore comigo"),
        ("lightbulb.fill", "Me ajude a entender um versículo"),
        ("face.smiling", "Quero compartilhar algo bom"),
    ]

    private var gabrielHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        .radialGradient(
                            colors: [accentRed.opacity(0.2), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)

                Circle()
                    .fill(accentRed.opacity(0.15))
                    .frame(width: 64, height: 64)

                Image(systemName: "sparkle")
                    .font(.title2.bold())
                    .foregroundStyle(accentRed)
                    .symbolEffect(.breathe)
            }

            VStack(spacing: 4) {
                Text("Gabriel")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text("Seu companheiro espiritual")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if viewModel.messages.count <= 1 {
                suggestionChipsView
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private var suggestionChipsView: some View {
        VStack(spacing: 8) {
            Text("Como posso te ajudar?")
                .font(.caption.weight(.medium))
                .foregroundStyle(.tertiary)
                .padding(.top, 4)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(suggestionChips, id: \.text) { chip in
                    Button {
                        viewModel.inputText = chip.text
                        viewModel.sendMessage()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: chip.icon)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(accentRed)
                            Text(chip.text)
                                .font(.caption2.weight(.medium))
                                .foregroundStyle(.white)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.15, green: 0.15, blue: 0.17), in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 4)
    }

    private var audioPlayerBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 12) {
                Button {
                    audioService.speak(audioService.currentText)
                } label: {
                    Image(systemName: audioService.isPaused ? "play.fill" : "pause.fill")
                        .font(.subheadline.bold())
                        .foregroundStyle(accentRed)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(accentRed.opacity(0.15))
                            .frame(height: 4)
                        Capsule()
                            .fill(accentRed)
                            .frame(width: geo.size.width * audioService.progress, height: 4)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                }

                Button {
                    audioService.stop()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(red: 0.1, green: 0.1, blue: 0.12))
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 12) {
                TextField("Fale com Gabriel...", text: $viewModel.inputText, axis: .vertical)
                    .lineLimit(1...5)
                    .font(.body)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.15, green: 0.15, blue: 0.17), in: RoundedRectangle(cornerRadius: 22))
                    .focused($isInputFocused)
                    .onSubmit {
                        viewModel.sendMessage()
                    }

                Button {
                    viewModel.sendMessage()
                } label: {
                    let isEmpty = viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading
                    ZStack {
                        Circle()
                            .fill(isEmpty ? Color(red: 0.2, green: 0.2, blue: 0.22) : accentRed)
                            .frame(width: 36, height: 36)

                        Image(systemName: "arrow.up")
                            .font(.subheadline.bold())
                            .foregroundStyle(isEmpty ? Color.secondary : Color.white)
                    }
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
                .sensoryFeedback(.impact(weight: .light), trigger: viewModel.messages.count)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(red: 0.1, green: 0.1, blue: 0.12))
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    @Bindable var audioService: AudioService

    private var isUser: Bool { message.role == .user }
    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    private var isPlayingThis: Bool {
        audioService.isSpeakingText(message.content)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 48) }

            if !isUser {
                ZStack {
                    Circle()
                        .fill(accentRed.opacity(0.12))
                        .frame(width: 28, height: 28)
                    Image(systemName: "sparkle")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(accentRed)
                }
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .lineSpacing(3)
                    .foregroundStyle(isUser ? .white : .white.opacity(0.9))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background {
                        if isUser {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(accentRed)
                        } else {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color(red: 0.15, green: 0.15, blue: 0.17))
                        }
                    }

                HStack(spacing: 12) {
                    if !isUser && !message.content.isEmpty {
                        Button {
                            audioService.speak(message.content)
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: isPlayingThis ? (audioService.isPaused ? "play.fill" : "pause.fill") : "speaker.wave.2")
                                    .font(.system(size: 10, weight: .semibold))
                                    .contentTransition(.symbolEffect(.replace))
                                Text(isPlayingThis ? (audioService.isPaused ? "Continuar" : "Pausar") : "Ouvir")
                                    .font(.caption2.weight(.medium))
                            }
                            .foregroundStyle(isPlayingThis ? accentRed : Color.secondary.opacity(0.6))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(isPlayingThis ? accentRed.opacity(0.1) : .clear, in: Capsule())
                        }
                        .sensoryFeedback(.impact(weight: .light), trigger: isPlayingThis)
                    }

                    Text(message.timestamp, format: .dateTime.hour().minute())
                        .font(.caption2)
                        .foregroundStyle(.quaternary)
                        .padding(.horizontal, 4)
                }
            }

            if !isUser { Spacer(minLength: 48) }
        }
    }
}

struct TypingIndicator: View {
    @State private var animating: Bool = false
    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack {
                Circle()
                    .fill(accentRed.opacity(0.12))
                    .frame(width: 28, height: 28)
                Image(systemName: "sparkle")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(accentRed)
            }

            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(.tertiary)
                        .frame(width: 7, height: 7)
                        .offset(y: animating ? -4 : 4)
                        .animation(
                            .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.15),
                            value: animating
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(red: 0.15, green: 0.15, blue: 0.17), in: RoundedRectangle(cornerRadius: 20, style: .continuous))

            Spacer(minLength: 48)
        }
        .onAppear { animating = true }
    }
}
