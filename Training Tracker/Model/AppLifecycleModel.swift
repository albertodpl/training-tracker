import Foundation

enum AppLifecycleStatus {
    case trainingNotStrated
    case trainingStarted
    case trainingCompleted
}

@Observable
final class AppLifecycleModel {
    var appLifecycleStatus: AppLifecycleStatus
    
    init(appLifecycleStatus: AppLifecycleStatus = .trainingNotStrated) {
        self.appLifecycleStatus = appLifecycleStatus
    }
}
