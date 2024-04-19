import Foundation

protocol PeriodicTimer {
    init(timeIntervalInSeconds interval: TimeInterval)
    func registerCallback(onTick: @escaping () -> Void)
}

final class PeriodicTimerWrapper: PeriodicTimer {
    private let interval: TimeInterval
    private let repeats = true
    private var timer: Timer? = nil
    private var callback: () -> Void = {}
    
    init(timeIntervalInSeconds interval: TimeInterval = 1/100) {
        self.interval = interval
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: self.repeats) { _ in
            self.onTick()
        }
    }
    
    private func onTick() {
        self.callback()
    }
    
    func registerCallback(onTick: @escaping () -> Void) {
        self.callback = onTick
    }
    
    deinit {
        timer?.invalidate()
    }
}
