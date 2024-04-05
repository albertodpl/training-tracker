import SwiftUI

struct TimerView: View {
    @Binding var timerModel: TimerModel
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(.blue)
                if timerModel.stepType == .rest {
                    Circle()
                        .trim(from: 0, to: CGFloat(timerModel.exerciseTimeRemainingInSeconds / timerModel.exerciseTimeInSeconds))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                        .foregroundColor(.green)
                    Text(formattedTime())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                } else {
                    Circle()
                        .trim(from: 0, to: ((timerModel.prepTimeRemainingInSeconds > 0) ? CGFloat(timerModel.prepTimeRemainingInSeconds / timerModel.prepTimeInSeconds) : CGFloat(timerModel.exerciseTimeRemainingInSeconds / timerModel.exerciseTimeInSeconds)))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                        .foregroundColor((timerModel.prepTimeRemainingInSeconds > 0) ? .orange : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Text(formattedTime())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor((timerModel.prepTimeRemainingInSeconds > 0) ? .orange : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            }
            .frame(maxWidth: 500)
        }
        .padding()
        .padding(.horizontal, 30)
        .opacity((timerModel.stepType == .repExercise) ? 0.3 : 1)
    }
    
    private func formattedTime() -> String {
        let secondsRemaining = Int((timerModel.prepTimeRemainingInSeconds > 0) ? timerModel.prepTimeRemainingInSeconds : timerModel.exerciseTimeRemainingInSeconds)
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview("Rest") {
    @State var timerModel = TimerModel(timerStatus: .stopped, exerciseTimeInSeconds: 75, exerciseTimeRemainingInSeconds: 25, stepType: .rest)
    return TimerView(timerModel: $timerModel)
}

#Preview("Prep") {
    @State var timerModel = TimerModel(timerStatus: .stopped, prepTimeInSeconds: 20, prepTimeRemainingInSeconds: 10, exerciseTimeInSeconds: 75, exerciseTimeRemainingInSeconds: 75, stepType: .timedExercise)
    return TimerView(timerModel: $timerModel)
}

#Preview("Exercise") {
    @State var timerModel = TimerModel(timerStatus: .stopped, prepTimeInSeconds: 20, prepTimeRemainingInSeconds: 0, exerciseTimeInSeconds: 75, exerciseTimeRemainingInSeconds: 15, stepType: .timedExercise)
    return TimerView(timerModel: $timerModel)
}
