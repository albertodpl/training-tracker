import SwiftUI

struct RepsView: View {
    var repsStepData: RepsStepData
    let repsFontSize = CGFloat(80)
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Text(formattedReps())
                    .font(.system(size: repsFontSize))
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                
                Circle()
                    .stroke(lineWidth: 10)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
            .frame(maxWidth: 500)
        }
        .padding()
        .padding(.horizontal, 30)
    }
    
    private func formattedReps() -> String {
        return "x \(repsStepData.repetitions)"
    }
}

#Preview("Reps") {
    let repsStepData = RepsStepData(repetitions: 8)
    return RepsView(repsStepData: repsStepData)
}

#Preview("Reps 2 digits") {
    let repsStepData = RepsStepData(repetitions: 56)
    return RepsView(repsStepData: repsStepData)
}

#Preview("Reps 3 digits") {
    let repsStepData = RepsStepData(repetitions: 56)
    return RepsView(repsStepData: repsStepData)
}
