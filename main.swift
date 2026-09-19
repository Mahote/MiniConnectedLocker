protocol SensorReadable {
    associatedtype Reading
    var value: Reading {get set}
    func readValue() async -> Reading
    func getInfo() -> String
}

protocol AdvancedSensor: SensorReadable {
    var name: String {get}
}

extension AdvancedSensor {
    func getInfo() -> String {
            return "Named : \(self.name) \n value : \(self.value)"
        }
}

class FakeHeartSensor: AdvancedSensor {
    var value: Int = 0
    var name = "Heart sensor"
    func readValue() async -> Int {
        try? await Task.sleep(nanoseconds: 500_000_000)
        value = Int.random(in: 50...100)
        return value
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
        return "Iam override ? Yes"
    }
}

func run<S: AdvancedSensor>(sensor: S) async {
    for _ in 1...5 {
        await sensor.readValue()
        print(sensor.getInfo())
    }
}
var fakeHeartSensor = FakeHeartSensor()
var temperatureFakeSensor = TemperatureSensor()
await run(sensor: fakeHeartSensor)
await run(sensor: temperatureFakeSensor)