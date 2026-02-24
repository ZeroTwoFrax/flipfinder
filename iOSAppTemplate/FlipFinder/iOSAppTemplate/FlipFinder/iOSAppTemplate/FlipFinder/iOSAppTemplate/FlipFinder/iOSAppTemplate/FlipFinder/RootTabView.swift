import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            DealsView()
                .tabItem {
                    Label("Deals", systemImage: "bolt.fill")
                }

            AnalyzerView()
                .tabItem {
                    Label("Analyzer", systemImage: "chart.xyaxis.line")
                }

            SavedView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    RootTabView()
        .environmentObject(AppModel())
}
