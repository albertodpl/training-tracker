import SwiftUI

struct TimerView: View {
    var timerModel: TimerModel
    var timedStepType: TimedStepType
    let timerFontSize = CGFloat(80)
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                switch timedStepType {
                case .rest(_):
                    Text(formattedTime())
                        .font(.system(size: timerFontSize))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                case .exercise(_):
                    Text(formattedTime())
                        .font(.system(size: timerFontSize))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor((timerModel.state.prepTimeRemainingInSeconds > 0) ? .orange : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
                
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                
                switch timedStepType {
                case .rest(_):
                    Circle()
                        .trim(from: 0, to: CGFloat(timerModel.state.exerciseTimeRemainingInSeconds / timerModel.definition.durationInSeconds))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                        .foregroundColor(.green)
                case .exercise(_):
                    Circle()
                        .trim(from: 0, to: ((timerModel.state.prepTimeRemainingInSeconds > 0) ? CGFloat(timerModel.state.prepTimeRemainingInSeconds / timerModel.definition.prepTimeInSeconds) : CGFloat(timerModel.state.exerciseTimeRemainingInSeconds / timerModel.definition.durationInSeconds)))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                        .foregroundColor((timerModel.state.prepTimeRemainingInSeconds > 0) ? .orange : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            }
            .frame(maxWidth: 500)
        }
        .padding()
        .padding(.horizontal, 30)
    }
    
    private func formattedTime() -> String {
        let secondsRemaining = Int((timerModel.state.prepTimeRemainingInSeconds > 0) ? timerModel.state.prepTimeRemainingInSeconds : timerModel.state.exerciseTimeRemainingInSeconds)
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview("Rest") {
    let timedStepDefinition = TimedStepDefinition(type: .rest, duration: 75)
    let timedStepType: TimedStepType = .rest(timedStepDefinition)
    let timerModel = TimerModel(timedStepDefinition: timedStepDefinition)
    timerModel.state.exerciseTimeRemainingInSeconds = 25
    return TimerView(timerModel: timerModel, timedStepType: timedStepType)
}

#Preview("Prep") {
    let timedStepDefinition = TimedStepDefinition(type: .exercise, prepTime: 20, duration: 75)
    let timedStepType: TimedStepType = .rest(timedStepDefinition)
    let timerModel = TimerModel(timedStepDefinition: timedStepDefinition)
    timerModel.state.prepTimeRemainingInSeconds = 10
    return TimerView(timerModel: timerModel, timedStepType: timedStepType)
}

#Preview("Exercise") {
    let timedStepDefinition = TimedStepDefinition(type: .exercise, prepTime: 20, duration: 75)
    let timedStepType: TimedStepType = .exercise(timedStepDefinition)
    let timerModel = TimerModel(timedStepDefinition: timedStepDefinition)
    timerModel.state.prepTimeRemainingInSeconds = 0
    timerModel.state.exerciseTimeRemainingInSeconds = 15
    return TimerView(timerModel: timerModel, timedStepType: timedStepType)
}
