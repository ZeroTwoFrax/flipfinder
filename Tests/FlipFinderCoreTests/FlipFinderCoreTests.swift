import Testing
@testable import FlipFinderCore

@Test func returnsBuyNowRecommendationForStrongDeal() {
    let opportunity = FlipOpportunity(
        title: "Vintage Denim Jacket",
        sourceMarketplace: .facebookMarketplace,
        targetMarketplace: .ebay,
        purchasePrice: 25,
        expectedSalePrice: 95,
        shippingCost: 10,
        platformFeePercent: 13.25,
        sellThroughRate: 72,
        averageDaysToSell: 6
    )

    let analysis = FlipCalculator.analyze(opportunity)

    #expect(analysis.netProfit == 47.41)
    #expect(analysis.roiPercent == 189.65)
    #expect(analysis.confidenceScore == 100)
    #expect(analysis.recommendation == .buyNow)
}

@Test func returnsPassForNegativeProfit() {
    let opportunity = FlipOpportunity(
        title: "Mass Market Board Game",
        sourceMarketplace: .poshmark,
        targetMarketplace: .ebay,
        purchasePrice: 18,
        expectedSalePrice: 20,
        shippingCost: 8,
        platformFeePercent: 13.25,
        sellThroughRate: 20,
        averageDaysToSell: 40
    )

    let analysis = FlipCalculator.analyze(opportunity)

    #expect(analysis.netProfit == -8.65)
    #expect(analysis.roiPercent == -48.06)
    #expect(analysis.confidenceScore == 0)
    #expect(analysis.recommendation == .pass)
}

@Test func returnsWatchForModerateDeal() {
    let opportunity = FlipOpportunity(
        title: "Running Shoes",
        sourceMarketplace: .facebookMarketplace,
        targetMarketplace: .poshmark,
        purchasePrice: 40,
        expectedSalePrice: 78,
        shippingCost: 7,
        platformFeePercent: 20,
        sellThroughRate: 55,
        averageDaysToSell: 18
    )

    let analysis = FlipCalculator.analyze(opportunity)

    #expect(analysis.netProfit == 15.40)
    #expect(analysis.roiPercent == 38.50)
    #expect(analysis.confidenceScore == 50)
    #expect(analysis.recommendation == .watch)
}
