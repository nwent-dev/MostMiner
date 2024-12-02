import SwiftUI

enum AppScreenState {
    case menu
    case game
    case color
    case privacy
}

struct MainView: View {
    @State private var screenState: AppScreenState = .menu
    @State private var isVolumeMuted = true
    @StateObject private var orientationManager = OrientationManager()

    var body: some View {
        ZStack {
            Image(orientationManager.isLandscape ? "backgroundLandsacpe" : "background")
                .ignoresSafeArea()

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

                case .color:
                    Text("Color")

                case .privacy:
                    ZStack {
                        WebView(urlString: "https://google.com/")

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
            } label: {
                Image("startBtn")
            }

            Button {
                screenState = .color
            } label: {
                Image("colorBtn")
            }

            Button {
                isVolumeMuted.toggle()
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
}

#Preview {
    MainView()
}
