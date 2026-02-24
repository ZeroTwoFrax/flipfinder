import Foundation

protocol DealFeedService {
    func fetchDeals() async throws -> [DealListing]
}

enum DealFeedError: LocalizedError {
    case offline
    case unauthorized
    case invalidResponse
    case serverError(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .offline:
            return "You appear to be offline. Check your connection and try again."
        case .unauthorized:
            return "Please sign in again to continue."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .serverError(let statusCode):
            return "Server error (\(statusCode)). Please try again in a moment."
        }
    }
}

struct MockDealFeedService: DealFeedService {
    var shouldFail: Bool = false

    func fetchDeals() async throws -> [DealListing] {
        try await Task.sleep(for: .milliseconds(300))

        if shouldFail {
            throw DealFeedError.offline
        }

        return [
            DealListing(
                title: "Patagonia Fleece",
                sourceMarketplace: .facebookMarketplace,
                targetMarketplace: .ebay,
                purchasePrice: 35,
                expectedSalePrice: 95,
                shippingCost: 9,
                platformFeePercent: 13.25,
                sellThroughRate: 76,
                averageDaysToSell: 7
            ),
            DealListing(
                title: "Dyson Airwrap",
                sourceMarketplace: .facebookMarketplace,
                targetMarketplace: .poshmark,
                purchasePrice: 210,
                expectedSalePrice: 350,
                shippingCost: 14,
                platformFeePercent: 20,
                sellThroughRate: 65,
                averageDaysToSell: 12
            )
        ]
    }
}

struct FallbackDealFeedService: DealFeedService {
    let primary: DealFeedService
    let fallback: DealFeedService

    func fetchDeals() async throws -> [DealListing] {
        do {
            return try await primary.fetchDeals()
        } catch {
            return try await fallback.fetchDeals()
        }
    }
}
