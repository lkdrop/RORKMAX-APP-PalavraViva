import SwiftUI

struct DevotionalCardView: View {
    let devotional: Devotional
    @State private var audioService = AudioService()
    @State private var isExpanded: Bool = false

    private let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)

    private var fullText: String {
        "\(devotional.scripture). \(devotional.reflection). \(devotional.prayer)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            devotionalImageHeader
            headerSection
            scriptureSection
            if isExpanded {
                expandedContent
            }
            if audioService.isSpeaking {
                audioProgressBar
            }
            actionBar
        }
        .background(Color(red: 0.12, green: 0.12, blue: 0.14), in: RoundedRectangle(cornerRadius: 16))
    }

    private var devotionalImageHeader: some View {
        Color(red: 0.15, green: 0.13, blue: 0.12)
            .frame(height: 140)
            .overlay {
                AsyncImage(url: URL(string: devotional.imageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .transition(.opacity.animation(.easeOut(duration: 0.4)))
                    }
                }
                .allowsHitTesting(false)
            }
            .overlay {
                LinearGradient(
                    colors: [.clear, Color(red: 0.12, green: 0.12, blue: 0.14)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)
            }
            .overlay(alignment: .topLeading) {
                Text(devotional.theme.uppercased())
                    .font(.caption2.bold())
                    .tracking(1)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(14)
            }
            .clipShape(.rect(topLeadingRadius: 16, topTrailingRadius: 16))
    }

    private var headerSection: some View {
        HStack(spacing: 10) {
            Image(systemName: "sun.and.horizon.fill")
                .font(.caption.bold())
                .foregroundStyle(accentRed)

            VStack(alignment: .leading, spacing: 2) {
                Text("DEVOCIONAL DO DIA")
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                    .tracking(1.2)
                Text(devotional.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
            }

            Spacer()

            Text(devotional.theme)
                .font(.caption2.bold())
                .foregroundStyle(accentRed)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(accentRed.opacity(0.12), in: Capsule())
        }
        .padding(.horizontal, 18)
        .padding(.top, 18)
        .padding(.bottom, 14)
    }

    private var scriptureSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\u{201C}\(devotional.scripture)\u{201D}")
                .font(.system(.callout, design: .serif))
                .lineSpacing(5)
                .foregroundStyle(.white.opacity(0.85))

            Text("— \(devotional.scriptureReference)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 14)
    }

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Rectangle()
                .fill(.white.opacity(0.08))
                .frame(height: 1)
                .padding(.horizontal, 18)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "text.book.closed")
                        .font(.caption2.bold())
                        .foregroundStyle(accentRed)
                    Text("Reflexão")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                Text(devotional.reflection)
                    .font(.subheadline)
                    .lineSpacing(4)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(.horizontal, 18)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "hands.sparkles")
                        .font(.caption2.bold())
                        .foregroundStyle(accentRed)
                    Text("Oração")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                Text(devotional.prayer)
                    .font(.system(.subheadline, design: .serif))
                    .italic()
                    .lineSpacing(4)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(.horizontal, 18)
        }
        .padding(.bottom, 6)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    private var audioProgressBar: some View {
        HStack(spacing: 10) {
            Image(systemName: audioService.isPaused ? "play.fill" : "waveform")
                .font(.caption2.bold())
                .foregroundStyle(accentRed)
                .symbolEffect(.variableColor.iterative, isActive: !audioService.isPaused)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(accentRed.opacity(0.12))
                        .frame(height: 3)
                    Capsule()
                        .fill(accentRed)
                        .frame(width: max(0, geo.size.width * audioService.progress), height: 3)
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 14)

            Button {
                audioService.stop()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 8)
        .transition(.opacity)
    }

    private var actionBar: some View {
        HStack(spacing: 0) {
            Button {
                audioService.speak(isExpanded ? fullText : "\(devotional.scripture). \(devotional.scriptureReference)")
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: audioService.isSpeaking ? (audioService.isPaused ? "play.fill" : "pause.fill") : "speaker.wave.2")
                        .font(.caption)
                        .foregroundStyle(audioService.isSpeaking ? accentRed : .secondary)
                        .contentTransition(.symbolEffect(.replace))
                    Text(audioService.isSpeaking ? (audioService.isPaused ? "Continuar" : "Pausar") : "Ouvir")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(audioService.isSpeaking ? accentRed : .secondary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }

            Spacer()

            Button {
                withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                    isExpanded.toggle()
                    if !isExpanded {
                        audioService.stop()
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(isExpanded ? "Menos" : "Ler devocional")
                        .font(.caption.weight(.semibold))
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption2.bold())
                }
                .foregroundStyle(accentRed)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            .sensoryFeedback(.impact(weight: .light), trigger: isExpanded)
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 8)
    }
}
