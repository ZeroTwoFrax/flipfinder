import SwiftUI

@main
struct FlipFinderApp: App {
    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(model)
        }
    }
}
