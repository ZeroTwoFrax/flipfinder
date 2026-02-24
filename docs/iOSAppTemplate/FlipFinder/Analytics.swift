import Foundation

protocol AnalyticsTracking {
    func track(_ event: AppEvent)
}

enum AppEvent: String {
    case dealsRefreshStarted
    case dealsRefreshSucceeded
    case dealsRefreshFailed
    case dealSaved
    case dealUnsaved
    case accountDataDeleted
}

struct NoOpAnalyticsTracker: AnalyticsTracking {
    func track(_ event: AppEvent) {}
}

struct ConsoleAnalyticsTracker: AnalyticsTracking {
    func track(_ event: AppEvent) {
        print("[analytics] event=\(event.rawValue)")
    }
}
