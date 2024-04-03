import SwiftUI

struct TimerViewCopied: View {
    @State private var timeRemaining: TimeInterval = 10
    @State private var timer: Timer?
    @State private var isRunning: Bool = false
    private let delta: TimeInterval = 1/100
        
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining / 10))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                    Text(formattedTime())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: 500)
                
                HStack {
                    Button {
                        isRunning.toggle()
                        if isRunning {
                            startTimer()
                        } else {
                            stopTimer()
                        }
                    } label: {
                        Image(systemName: isRunning ? "stop.fill" : "play.fill")
                            .foregroundStyle(.foreground)
                            .frame(width: 50, height: 50)
                            .font(.largeTitle)
                            .padding()
                    }
                }
            }
            .padding(.horizontal, 30)
            .navigationTitle("My iTimer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func formattedTime() -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timeRemaining = 10
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: delta, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= delta
            } else {
                stopTimer()
            }
        }
    }
}

#Preview {
    TimerViewOld()
}
