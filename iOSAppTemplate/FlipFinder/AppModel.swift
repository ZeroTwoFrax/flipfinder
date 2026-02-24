import Foundation
import FlipFinderCore

@MainActor
final class AppModel: ObservableObject {
    @Published private(set) var deals: [DealListing] = []
    @Published private(set) var savedDeals: [DealListing] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    let configuration: AppConfiguration

    private let feedService: DealFeedService
    private let savedStore: SavedDealsStore
    private let analytics: AnalyticsTracking

    init(
        configuration: AppConfiguration = .production,
        feedService: DealFeedService? = nil,
        savedStore: SavedDealsStore = UserDefaultsSavedDealsStore(),
        analytics: AnalyticsTracking = ConsoleAnalyticsTracker(),
        tokenStore: AuthTokenStore = UserDefaultsAuthTokenStore()
    ) {
        self.configuration = configuration
        self.savedStore = savedStore
        self.analytics = analytics
        self.savedDeals = savedStore.load()

        if let feedService {
            self.feedService = feedService
        } else {
            let remote = MarketplaceAPIDealFeedService(configuration: configuration, tokenStore: tokenStore)
            let mock = MockDealFeedService()
            self.feedService = FallbackDealFeedService(primary: remote, fallback: mock)
        }
    }

    func refreshDeals() async {
        analytics.track(.dealsRefreshStarted)
        isLoading = true
        errorMessage = nil

        do {
            deals = try await feedService.fetchDeals()
            analytics.track(.dealsRefreshSucceeded)
        } catch {
            errorMessage = error.localizedDescription
            analytics.track(.dealsRefreshFailed)
        }

        isLoading = false
    }

    func isSaved(_ deal: DealListing) -> Bool {
        savedDeals.contains(where: { $0.id == deal.id })
    }

    func toggleSaved(_ deal: DealListing) {
        if let index = savedDeals.firstIndex(where: { $0.id == deal.id }) {
            savedDeals.remove(at: index)
            analytics.track(.dealUnsaved)
        } else {
            savedDeals.append(deal)
            analytics.track(.dealSaved)
        }
        savedStore.save(savedDeals)
    }

    func deleteAccountData() {
        savedDeals = []
        savedStore.save([])
        analytics.track(.accountDataDeleted)
    }

    func analysis(for deal: DealListing) -> FlipAnalysis {
        FlipCalculator.analyze(deal.opportunity)
    }
}
