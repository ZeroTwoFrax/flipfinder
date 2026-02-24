import Foundation

protocol SavedDealsStore {
    func load() -> [DealListing]
    func save(_ deals: [DealListing])
}

struct UserDefaultsSavedDealsStore: SavedDealsStore {
    private let key = "savedDeals"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> [DealListing] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([DealListing].self, from: data)) ?? []
    }

    func save(_ deals: [DealListing]) {
        guard let data = try? JSONEncoder().encode(deals) else { return }
        defaults.set(data, forKey: key)
    }
}
