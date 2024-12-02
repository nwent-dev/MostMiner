import SwiftUI
import AVFoundation

enum AppScreenState {
    case menu
    case game
    case privacy
}

struct MainView: View {
    @State private var screenState: AppScreenState = .menu
    @State private var isVolumeMuted = true
    @State private var backgroundAudioPlayer: AVAudioPlayer?
    @StateObject private var orientationManager = OrientationManager()

    var body: some View {
        ZStack {
            Image(orientationManager.isLandscape ? "backgroundLandsacpe" : "background")
                .ignoresSafeArea()
                .onAppear {
                    setupAudioPlayer()
                }

            switch screenState {
                case .menu:
                    if orientationManager.isLandscape {
                        landscapeMenuLayout
                    } else {
                        portraitMenuLayout
                    }

                case .game:
                    WebViewForGame(isSoundMuted: $isVolumeMuted, currentScreen: $screenState)
                        .ignoresSafeArea()

                case .privacy:
                    ZStack {
                        WebView(urlString: "https://mostminer.space/privacy")

                        Button {
                            screenState = .menu
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .position(x: UIScreen.main.bounds.width * 0.9, y: UIScreen.main.bounds.height * 0.1)
                    }
            }
        }
        .animation(.easeInOut, value: orientationManager.isLandscape)
    }
    
    var portraitMenuLayout: some View {
        VStack {
            menuButtons
        }
        .padding(.bottom, UIScreen.main.bounds.height * 0.15)
    }

    var landscapeMenuLayout: some View {
        VStack {
            menuButtons
        }
    }

    var menuButtons: some View {
        Group {
            Button {
                screenState = .game
                stopBackgroundMusic()
            } label: {
                Image("startBtn")
            }

            Button {
                isVolumeMuted.toggle()
                if !isVolumeMuted {
                    playBackgroundMusic()
                } else {
                    stopBackgroundMusic()
                }
            } label: {
                Image(isVolumeMuted ? "volumeOff" : "volumeOn")
            }
            .buttonStyle(PlainButtonStyle())

            Button {
                screenState = .privacy
            } label: {
                Image("privacyBtn")
            }
        }
    }
    
    private func setupAudioPlayer() {
        if let path = Bundle.main.path(forResource: "backgroundMusic", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                backgroundAudioPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundAudioPlayer?.numberOfLoops = -1
                backgroundAudioPlayer?.prepareToPlay()
            } catch {
                print("Audio Player Error: \(error.localizedDescription)")
            }
        }
    }

    private func playBackgroundMusic() {
        backgroundAudioPlayer?.play()
    }

    private func stopBackgroundMusic() {
        backgroundAudioPlayer?.stop()
        backgroundAudioPlayer?.currentTime = 0
    }
}

#Preview {
    MainView()
}
