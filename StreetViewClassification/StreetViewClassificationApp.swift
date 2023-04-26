import Siren
import SwiftUI

@main
struct StreetViewClassificationApp: App {
    // swiftlint:disable weak_delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// UIKit(storyboard用)
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let siren = Siren.shared
        siren.rulesManager = RulesManager(
            majorUpdateRules: .critical,    // 1.0.0.0 -> 2.0.0.0
            minorUpdateRules: .persistent,  // 1.0.0.0 -> 1.1.0.0
            patchUpdateRules: .default,     // 1.0.0.0 -> 1.0.1.0
            revisionUpdateRules: .hinting,  // 1.0.0.0 -> 1.0.0.1
            showAlertAfterCurrentVersionHasBeenReleasedForDays: 1   // 何日遅れでアラートが来るか
        )
        siren.wail()
        return true
    }
}
