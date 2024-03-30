import SwiftUI

struct TrainingView: View {
    let routine: Routine
    @State private var myState = MyState()

    var body: some View {
        VStack {
            Text(routine.name).font(.title)
            Text("Eccentric pull-ups").font(.title2)
            Spacer()
            TimerView()
            Button("Next") {
                print(routine.exerciseGroup[myState.count].name!)
                if myState.count < routine.exerciseGroup.count - 1 {
                    myState.count += 1
                }
                else {
                    myState.count = 0
                }
            }
        }
        .padding()
    }
}

struct MyState {
    var count = 0
}

let routine: Routine = load("workoutRoutine.json")
#Preview {
    TrainingView(routine: routine)
}
