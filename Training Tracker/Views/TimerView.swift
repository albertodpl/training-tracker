import SwiftUI

struct TimerView: View {
    var timedStepModel: TimedStepModel
    private let timerFontSize = CGFloat(80) // TODO: Make it dynamic/adapt to device
    private let prepTimeColor = Color.orange
    private let restTimeColor = Color.green
    private let exerciseTimeColor = Color.blue
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Text(formattedTime())
                    .font(.system(size: timerFontSize))
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(color())
                
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                
                Circle()
                    .trim(from: 0, to: ((timedStepModel.state.prepTimeRemainingInSeconds > 0) ? CGFloat(timedStepModel.state.prepTimeRemainingInSeconds / timedStepModel.definition.prepTimeInSeconds) : CGFloat(timedStepModel.state.exerciseTimeRemainingInSeconds / timedStepModel.definition.durationInSeconds)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(-90))
                    .foregroundColor(color())
            }
            .frame(maxWidth: 500)
        }
        .padding()
        .padding(.horizontal, 30)
    }
    
    private func formattedTime() -> String {
        let secondsRemaining = Int((timedStepModel.state.prepTimeRemainingInSeconds > 0) ? timedStepModel.state.prepTimeRemainingInSeconds : timedStepModel.state.exerciseTimeRemainingInSeconds)
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func color() -> Color {
        if timedStepModel.state.prepTimeRemainingInSeconds > 0 {
            return prepTimeColor
        } else if timedStepModel.definition.type == .rest {
            return restTimeColor
        } else {
            return exerciseTimeColor
        }
    }
}

#Preview("Rest") {
    let timedStepDefinition = TimedStepDefinition(type: .rest, duration: 75)
    let timedStepModel = TimedStepModel(timedStepDefinition: timedStepDefinition)
    timedStepModel.state.exerciseTimeRemainingInSeconds = 25
    return TimerView(timedStepModel: timedStepModel)
}

#Preview("Prep") {
    let timedStepDefinition = TimedStepDefinition(type: .exercise, prepTime: 20, duration: 75)
    let timedStepModel = TimedStepModel(timedStepDefinition: timedStepDefinition)
    timedStepModel.state.prepTimeRemainingInSeconds = 10
    return TimerView(timedStepModel: timedStepModel)
}

#Preview("Exercise") {
    let timedStepDefinition = TimedStepDefinition(type: .exercise, prepTime: 20, duration: 75)
    let timedStepModel = TimedStepModel(timedStepDefinition: timedStepDefinition)
    timedStepModel.state.prepTimeRemainingInSeconds = 0
    timedStepModel.state.exerciseTimeRemainingInSeconds = 15
    return TimerView(timedStepModel: timedStepModel)
}
