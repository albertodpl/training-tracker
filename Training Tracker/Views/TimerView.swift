import SwiftUI

struct TimerView: View {
    var timerModel: TimerModel
    var stepType: StepType
    let timerFontSize = CGFloat(80)
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                switch stepType {
                case .rest(_):
                    Text(formattedTime())
                        .font(.system(size: timerFontSize))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                default:
                    Text(formattedTime())
                        .font(.system(size: timerFontSize))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor((timerModel.prepTimeRemainingInSeconds > 0) ? .orange : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
                
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                
                switch stepType {
                case .rest(_):
                    Circle()
                        .trim(from: 0, to: CGFloat(timerModel.exerciseTimeRemainingInSeconds / timerModel.exerciseTimeInSeconds))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                        .foregroundColor(.green)
                default:
                    Circle()
                        .trim(from: 0, to: ((timerModel.prepTimeRemainingInSeconds > 0) ? CGFloat(timerModel.prepTimeRemainingInSeconds / timerModel.prepTimeInSeconds) : CGFloat(timerModel.exerciseTimeRemainingInSeconds / timerModel.exerciseTimeInSeconds)))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                        .foregroundColor((timerModel.prepTimeRemainingInSeconds > 0) ? .orange : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            }
            .frame(maxWidth: 500)
        }
        .padding()
        .padding(.horizontal, 30)
        .opacity((stepType == .repExercise) ? 0.3 : 1)
    }
    
    private func formattedTime() -> String {
        let secondsRemaining = Int((timerModel.prepTimeRemainingInSeconds > 0) ? timerModel.prepTimeRemainingInSeconds : timerModel.exerciseTimeRemainingInSeconds)
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview("Rest") {
    let step = Step(name: "Rest", duration: 75, stepType: .rest(.stopped))
    let timerModel = TimerModel(step: step)
    timerModel.exerciseTimeRemainingInSeconds = 25
    return TimerView(timerModel: timerModel, stepType: step.stepType)
}

#Preview("Prep") {
    let step = Step(name: "Prep", prepTime: 20, duration: 75, stepType: .timedExercise)
    let timerModel = TimerModel(step: step)
    timerModel.prepTimeRemainingInSeconds = 10
    return TimerView(timerModel: timerModel, stepType: step.stepType)
}

#Preview("Exercise") {
    let step = Step(name: "Prep", prepTime: 20, duration: 75, stepType: .timedExercise)
    let timerModel = TimerModel(step: step)
    timerModel.prepTimeRemainingInSeconds = 0
    timerModel.exerciseTimeRemainingInSeconds = 15
    return TimerView(timerModel: timerModel, stepType: step.stepType)
}
