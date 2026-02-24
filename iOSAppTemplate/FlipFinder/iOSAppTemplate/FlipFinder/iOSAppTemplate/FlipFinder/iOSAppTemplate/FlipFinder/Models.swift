import Foundation
import FlipFinderCore

struct DealListing: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let sourceMarketplace: Marketplace
    let targetMarketplace: Marketplace
    let purchasePrice: Decimal
    let expectedSalePrice: Decimal
    let shippingCost: Decimal
    let platformFeePercent: Decimal
    let sellThroughRate: Decimal
    let averageDaysToSell: Int

    init(
        id: UUID = UUID(),
        title: String,
        sourceMarketplace: Marketplace,
        targetMarketplace: Marketplace,
        purchasePrice: Decimal,
        expectedSalePrice: Decimal,
        shippingCost: Decimal,
        platformFeePercent: Decimal,
        sellThroughRate: Decimal,
        averageDaysToSell: Int
    ) {
        self.id = id
        self.title = title
        self.sourceMarketplace = sourceMarketplace
        self.targetMarketplace = targetMarketplace
        self.purchasePrice = purchasePrice
        self.expectedSalePrice = expectedSalePrice
        self.shippingCost = shippingCost
        self.platformFeePercent = platformFeePercent
        self.sellThroughRate = sellThroughRate
        self.averageDaysToSell = averageDaysToSell
    }

    var opportunity: FlipOpportunity {
        FlipOpportunity(
            title: title,
            sourceMarketplace: sourceMarketplace,
            targetMarketplace: targetMarketplace,
            purchasePrice: purchasePrice,
            expectedSalePrice: expectedSalePrice,
            shippingCost: shippingCost,
            platformFeePercent: platformFeePercent,
            sellThroughRate: sellThroughRate,
            averageDaysToSell: averageDaysToSell
        )
    }
}
