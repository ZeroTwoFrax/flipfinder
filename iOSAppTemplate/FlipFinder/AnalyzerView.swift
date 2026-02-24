import SwiftUI
import FlipFinderCore

struct AnalyzerView: View {
    @State private var purchasePrice: Double = 30
    @State private var salePrice: Double = 90
    @State private var shipping: Double = 10
    @State private var feePercent: Double = 13.25

    var analysis: FlipAnalysis {
        let opportunity = FlipOpportunity(
            title: "Custom",
            sourceMarketplace: .facebookMarketplace,
            targetMarketplace: .ebay,
            purchasePrice: Decimal(purchasePrice),
            expectedSalePrice: Decimal(salePrice),
            shippingCost: Decimal(shipping),
            platformFeePercent: Decimal(feePercent),
            sellThroughRate: 60,
            averageDaysToSell: 10
        )
        return FlipCalculator.analyze(opportunity)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Costs") {
                    Slider(value: $purchasePrice, in: 0...300, step: 1) {
                        Text("Purchase")
                    }
                    Text("Purchase: $\(purchasePrice, specifier: "%.0f")")

                    Slider(value: $salePrice, in: 0...600, step: 1)
                    Text("Expected sale: $\(salePrice, specifier: "%.0f")")

                    Slider(value: $shipping, in: 0...40, step: 1)
                    Text("Shipping: $\(shipping, specifier: "%.0f")")

                    Slider(value: $feePercent, in: 5...30, step: 0.25)
                    Text("Marketplace fee: \(feePercent, specifier: "%.2f")%")
                }

                Section("Outcome") {
                    Text("Net profit: $\(analysis.netProfit.formatted())")
                    Text("ROI: \(analysis.roiPercent.formatted())%")
                    Text("Confidence: \(analysis.confidenceScore)")
                    Text("Recommendation: \(analysis.recommendation.rawValue)")
                        .fontWeight(.semibold)
                }
            }
            .navigationTitle("Analyzer")
        }
    }
}

#Preview {
    AnalyzerView()
}
