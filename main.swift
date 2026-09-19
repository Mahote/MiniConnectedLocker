protocol SensorReadable {
    associatedtype Reading
    var value: Reading {get set}
    func readValue() async -> Reading
    func describe(value: Reading) -> String
}

protocol AdvancedSensor: SensorReadable {
    var name: String {get}
    func getInfo() -> String
}

class FakeHeartSensor: AdvancedSensor {
    var value: Int = 0
    var name = "Heart sensor"
    func readValue() async -> Int {
        try? await Task.sleep(nanoseconds: 500_000_000)
        value = Int.random(in: 50...100)
        return value
    }

    func getInfo() -> String {
        return "Named : \(name) \n value : \(self.describe(value))"
    }

    func describe(value: Int) -> String {
        return "heartrate is \(value.description) bpm"
    }
}

class TemperatureSensor: AdvancedSensor {
    var value: Double = 0
    var name = "Temperature sensor"
    func readValue() async -> Double {
        try? await Task.sleep(nanoseconds: 500_000_000)
        value = Double.random(in: -10.0...40.0)
        return value
    }

    func getInfo() -> String {
        return "Named : \(name) \n value : \(self.describe(value))"
    }

    func describe(value: Double)  -> String {
        return "Temperature is \(value.description) degrees"
    }
}

func printSensorInfo<S: AdvancedSensor>(sensor: S) -> String {
    return "Named : \(sensor.name) \n value : \(sensor.describe(value))"
}


func run<S: AdvancedSensor>(sensor: S) async {
    for _ in 1...5 {
        let bpm = await sensor.readValue()
        print(sensor.describe(value: bpm))
        print(sensor.getInfo())
    }
}
var fakeHeartSensor = FakeHeartSensor()
var temperatureFakeSensor = TemperatureSensor()
await run(sensor: fakeHeartSensor)
await run(sensor: temperatureFakeSensor)