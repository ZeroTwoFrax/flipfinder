import SwiftUI

struct SavedView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        NavigationStack {
            if model.savedDeals.isEmpty {
                ContentUnavailableView(
                    "No Saved Items Yet",
                    systemImage: "bookmark",
                    description: Text("Save high-potential flips and track them as prices change.")
                )
            } else {
                List(model.savedDeals) { deal in
                    let analysis = model.analysis(for: deal)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(deal.title)
                            .font(.headline)
                        Text("Net: $\(analysis.netProfit.formatted()) • ROI: \(analysis.roiPercent.formatted())%")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Saved")
    }
}

#Preview {
    SavedView()
        .environmentObject(AppModel())
}
