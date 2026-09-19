protocol SensorReadable {
    associatedtype Reading
    var value: Reading {get set}
    func readValue() async -> Reading
    func describe(value: Reading) -> String
}

class FakeHeartSensor: SensorReadable {
    var value: Int = 0
    func readValue() async -> Int {
        try? await Task.sleep(nanoseconds: 500_000_000)
        value = Int.random(in: 50...100)
        return value
    }

    func describe(value: Int) -> String {
        return "heartrate is \(value.description) bpm"
    }
}

class TemperatureSensor: SensorReadable {
    var value: Double = 0
    func readValue() async -> Double {
        try? await Task.sleep(nanoseconds: 500_000_000)
        value = Double.random(in: -10.0...40.0)
        return value
    }

    func describe(value: Double)  -> String {
        return "Temperature is \(value.description) degrees"
    }
}

// class FakeHeartSensor: SensorReadable {
// var value: Int = 0
//     func readValue() async -> Int {
//         // Simulate reading a value from a sensor
//         try? await Task.sleep(nanoseconds: 500_000_000)
//         self.setValue(newValue: Int.random(in: 50...100))
//         return value
//     }
//     mutating func setValue(newValue: Reading){
//         value = newValue
//     }
    
// }

func run<S: SensorReadable>(sensor: S) async {
    for _ in 1...5 {
        let bpm = await sensor.readValue()
        print(sensor.describe(value: bpm))
    }
}
var fakeHeartSensor = FakeHeartSensor()
var temperatureFakeSensor = TemperatureSensor()
await run(sensor: fakeHeartSensor)
await run(sensor: temperatureFakeSensor)