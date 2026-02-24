import Foundation

public enum Marketplace: String, CaseIterable, Sendable, Codable {
    case ebay = "eBay"
    case facebookMarketplace = "Facebook Marketplace"
    case poshmark = "Poshmark"
}

public struct FlipOpportunity: Sendable, Codable, Equatable {
    public var title: String
    public var sourceMarketplace: Marketplace
    public var targetMarketplace: Marketplace
    public var purchasePrice: Decimal
    public var expectedSalePrice: Decimal
    public var shippingCost: Decimal
    public var sourcingCost: Decimal
    public var platformFeePercent: Decimal
    public var sellThroughRate: Decimal
    public var averageDaysToSell: Int

    public init(
        title: String,
        sourceMarketplace: Marketplace,
        targetMarketplace: Marketplace,
        purchasePrice: Decimal,
        expectedSalePrice: Decimal,
        shippingCost: Decimal,
        sourcingCost: Decimal = 0,
        platformFeePercent: Decimal,
        sellThroughRate: Decimal,
        averageDaysToSell: Int
    ) {
        self.title = title
        self.sourceMarketplace = sourceMarketplace
        self.targetMarketplace = targetMarketplace
        self.purchasePrice = purchasePrice
        self.expectedSalePrice = expectedSalePrice
        self.shippingCost = shippingCost
        self.sourcingCost = sourcingCost
        self.platformFeePercent = platformFeePercent
        self.sellThroughRate = sellThroughRate
        self.averageDaysToSell = averageDaysToSell
    }
}

public struct FlipAnalysis: Sendable, Equatable {
    public let netProfit: Decimal
    public let roiPercent: Decimal
    public let marginPercent: Decimal
    public let confidenceScore: Int
    public let recommendation: Recommendation

    public enum Recommendation: String, Sendable {
        case buyNow = "Buy now"
        case watch = "Watch"
        case pass = "Pass"
    }
}

public enum FlipCalculator {
    public static func analyze(_ opportunity: FlipOpportunity) -> FlipAnalysis {
        let feeAmount = opportunity.expectedSalePrice * (opportunity.platformFeePercent / 100)
        let totalCost = opportunity.purchasePrice + opportunity.shippingCost + opportunity.sourcingCost + feeAmount
        let netProfit = opportunity.expectedSalePrice - totalCost

        let roiPercent: Decimal = opportunity.purchasePrice == 0 ? 0 : (netProfit / opportunity.purchasePrice) * 100
        let marginPercent: Decimal = opportunity.expectedSalePrice == 0 ? 0 : (netProfit / opportunity.expectedSalePrice) * 100

        let score = confidenceScore(
            netProfit: netProfit,
            roiPercent: roiPercent,
            sellThroughRate: opportunity.sellThroughRate,
            averageDaysToSell: opportunity.averageDaysToSell
        )

        let recommendation: FlipAnalysis.Recommendation
        switch score {
        case 75...100:
            recommendation = .buyNow
        case 50..<75:
            recommendation = .watch
        default:
            recommendation = .pass
        }

        return FlipAnalysis(
            netProfit: netProfit.rounded(scale: 2),
            roiPercent: roiPercent.rounded(scale: 2),
            marginPercent: marginPercent.rounded(scale: 2),
            confidenceScore: score,
            recommendation: recommendation
        )
    }

    private static func confidenceScore(
        netProfit: Decimal,
        roiPercent: Decimal,
        sellThroughRate: Decimal,
        averageDaysToSell: Int
    ) -> Int {
        var score = 0

        if netProfit >= 40 { score += 35 }
        else if netProfit >= 20 { score += 25 }
        else if netProfit > 0 { score += 10 }

        if roiPercent >= 50 { score += 30 }
        else if roiPercent >= 30 { score += 20 }
        else if roiPercent >= 15 { score += 10 }

        if sellThroughRate >= 70 { score += 20 }
        else if sellThroughRate >= 50 { score += 12 }
        else if sellThroughRate >= 30 { score += 6 }

        if averageDaysToSell <= 7 { score += 15 }
        else if averageDaysToSell <= 14 { score += 10 }
        else if averageDaysToSell <= 30 { score += 8 }

        return min(max(score, 0), 100)
    }
}

private extension Decimal {
    func rounded(scale: Int, mode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
        var original = self
        var roundedValue = Decimal()
        NSDecimalRound(&roundedValue, &original, scale, mode)
        return roundedValue
    }
}
