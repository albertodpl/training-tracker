import Foundation

// TODO: Populate with sensible values if they are not present and makes sense, e.g., prepTime = 0.
//       Explained on https://www.swiftbysundell.com/tips/default-decoding-values/

struct JsonRoutine: Codable {
    var name: String
    var exercisesGroups: [JsonExerciseGroup]
    
    static func load<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }


        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }


        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}

struct JsonExerciseGroup: Codable {
    var name: String?
    var restInBetween: Int?
    var restAtTheEnd: Int?
    var exercisesGroups: [JsonExerciseGroup]?
    var exercises: [JsonExercise]?
}

struct JsonExercise: Codable {
    var name: String
    var description: String?
    var numberOfSets: Int
    var prepTimes: [Int]?
    var durations: [Int]?
    var repetitions: [Int]?
    var tempo: JsonTempo?
}

struct JsonTempo: Codable {
    var eccentric: Int?
    var eccentricRest: Int?
    var concentric: Int?
    var concentricRest: Int?
}
