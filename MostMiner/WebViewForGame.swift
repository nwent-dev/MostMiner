import SwiftUI
import WebKit

struct WebViewForGame: UIViewRepresentable {
    @Binding var isSoundMuted: Bool
    @Binding var currentScreen: AppScreenState

    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true

        if #available(iOS 10.0, *) {
            configuration.mediaTypesRequiringUserActionForPlayback = []
        }

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.configuration.userContentController.add(context.coordinator, name: "onGameOver")
        
        context.coordinator.webViewReference = webView
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let baseAddress = "https://mostminer.space/"
        let queryString = "\(baseAddress)?isMuted=\(isSoundMuted)"
        print("Navigating to URL: \(queryString)")
        
        if let url = URL(string: queryString) {
            uiView.load(URLRequest(url: url))
        }
    }

    class WebViewCoordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        var parentView: WebViewForGame
        weak var webViewReference: WKWebView?

        init(_ parentView: WebViewForGame) {
            self.parentView = parentView
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "onGameOver" {
                DispatchQueue.main.async {
                    self.parentView.currentScreen = .menu
                }
            }
        }

        deinit {
            webViewReference?.configuration.userContentController.removeScriptMessageHandler(forName: "onGameOver")
        }
    }
}
