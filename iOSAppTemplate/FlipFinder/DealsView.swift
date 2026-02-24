import SwiftUI

struct DealsView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        NavigationStack {
            Group {
                if model.isLoading {
                    ProgressView("Loading deals…")
                        .accessibilityLabel("Loading deals")
                } else if let errorMessage = model.errorMessage {
                    ContentUnavailableView(
                        "Could Not Load Deals",
                        systemImage: "wifi.exclamationmark",
                        description: Text(errorMessage)
                    )
                } else {
                    List(model.deals) { item in
                        let analysis = model.analysis(for: item)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.title)
                                .font(.headline)
                            Text("\(item.sourceMarketplace.rawValue) → \(item.targetMarketplace.rawValue)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            HStack {
                                Text("Profit: $\(analysis.netProfit.formatted())")
                                Spacer()
                                Button(model.isSaved(item) ? "Unsave" : "Save") {
                                    model.toggleSaved(item)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(model.isSaved(item) ? .gray : .blue)
                            }
                            Text(analysis.recommendation.rawValue)
                                .fontWeight(.semibold)
                                .foregroundStyle(analysis.recommendation == .buyNow ? .green : .orange)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Flip Finder")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Refresh") {
                        Task { await model.refreshDeals() }
                    }
                    .accessibilityHint("Fetches the latest opportunities")
                }
            }
            .task {
                if model.deals.isEmpty {
                    await model.refreshDeals()
                }
            }
        }
    }
}

#Preview {
    DealsView()
        .environmentObject(AppModel())
