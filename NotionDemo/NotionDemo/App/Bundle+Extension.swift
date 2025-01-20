import Foundation

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var buildVersion: String {
        infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
