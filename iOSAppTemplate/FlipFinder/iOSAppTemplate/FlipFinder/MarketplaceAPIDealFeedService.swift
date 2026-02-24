import Foundation
import FlipFinderCore

struct MarketplaceAPIDealFeedService: DealFeedService {
    private let configuration: AppConfiguration
    private let tokenStore: AuthTokenStore
    private let session: URLSession

    init(
        configuration: AppConfiguration,
        tokenStore: AuthTokenStore,
        session: URLSession = .shared
    ) {
        self.configuration = configuration
        self.tokenStore = tokenStore
        self.session = session
    }

    func fetchDeals() async throws -> [DealListing] {
        guard let token = tokenStore.getToken(), !token.isEmpty else {
            throw DealFeedError.unauthorized
        }

        let endpoint = configuration.apiBaseURL.appendingPathComponent("v1/deals")
        var request = URLRequest(url: endpoint)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw DealFeedError.invalidResponse
        }

        switch http.statusCode {
        case 200:
            break
        case 401:
            throw DealFeedError.unauthorized
        default:
            throw DealFeedError.serverError(statusCode: http.statusCode)
        }

        let remoteDeals = try JSONDecoder().decode([RemoteDealListing].self, from: data)
        return remoteDeals.map { $0.localModel }
    }
}

private struct RemoteDealListing: Decodable {
    let id: UUID
    let title: String
    let sourceMarketplace: String
    let targetMarketplace: String
    let purchasePrice: Decimal
    let expectedSalePrice: Decimal
    let shippingCost: Decimal
    let platformFeePercent: Decimal
    let sellThroughRate: Decimal
    let averageDaysToSell: Int

    var localModel: DealListing {
        DealListing(
            id: id,
            title: title,
            sourceMarketplace: Marketplace(rawValue: sourceMarketplace) ?? .facebookMarketplace,
            targetMarketplace: Marketplace(rawValue: targetMarketplace) ?? .ebay,
            purchasePrice: purchasePrice,
            expectedSalePrice: expectedSalePrice,
            shippingCost: shippingCost,
            platformFeePercent: platformFeePercent,
            sellThroughRate: sellThroughRate,
            averageDaysToSell: averageDaysToSell
        )
    }
}
