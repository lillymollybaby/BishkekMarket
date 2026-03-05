import SwiftUI

enum AppMode {
    case services
    case products
}

class AppState: ObservableObject {
    @Published var mode: AppMode = .services
    @Published var notificationCount: Int = 2
}
