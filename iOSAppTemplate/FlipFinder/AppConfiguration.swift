import Foundation

struct AppConfiguration {
    let apiBaseURL: URL
    let privacyPolicyURL: URL
    let termsURL: URL
    let supportEmail: String

    static let production = AppConfiguration(
        apiBaseURL: URL(string: "https://api.flipfinder.app")!,
        privacyPolicyURL: URL(string: "https://flipfinder.app/privacy")!,
        termsURL: URL(string: "https://flipfinder.app/terms")!,
        supportEmail: "support@flipfinder.app"
    )

    var supportEmailURL: URL? {
        URL(string: "mailto:\(supportEmail)")
    }
}
