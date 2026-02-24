import Foundation

protocol AuthTokenStore {
    func getToken() -> String?
    func setToken(_ token: String?)
}

struct UserDefaultsAuthTokenStore: AuthTokenStore {
    private let key = "authToken"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func getToken() -> String? {
        defaults.string(forKey: key)
    }

    func setToken(_ token: String?) {
        defaults.set(token, forKey: key)
    }
}
