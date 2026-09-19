protocol SensorReadable {
    associatedtype Reading
    var value: Reading {get set}
    func readValue() async -> Reading
    func getInfo() -> String
}

protocol Calibratable {
    func calibrate() async
}

protocol AdvancedSensor: SensorReadable {
    var name: String {get}
} 

extension AdvancedSensor {
    func getInfo() -> String {
            return "Named : \(self.name) \n value : \(self.value)"
        }
}

class FakeHeartSensor: AdvancedSensor & Calibratable{
    var value: Int = 0
    var name = "Heart sensor"
    func readValue() async -> Int {
        try? await Task.sleep(nanoseconds: 500_000_000)
        value = Int.random(in: 50...160)
        return value
    }

    func calibrate() async {
        value = Int.random(in: 40...70) 
    }
}

class TemperatureSensor: AdvancedSensor  & Calibratable {
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

    func calibrate() async {
        value = Double.random(in: 15.0...25.0) 
    }
}

func compareReading<S1: SensorReadable, S2: SensorReadable>(s1: S1, s2: S2)  -> Bool 
    where S1.Reading == S2.Reading, S1.Reading: Comparable {
    if s1.value > s2.value {
        print("Sensor1 (\(s1.value)) > Sensor2 (\(s2.value))")
        return true
    } else {
        print("Sensor2 (\(s2.value)) >= Sensor1 (\(s1.value))")
        return false
    }
}

func setupSensor<S: AdvancedSensor & Calibratable>(sensor: S) async {
    print(sensor.name)
    await sensor.calibrate()
    print("Reading before calibration: \(sensor.value)")
    let reading = await sensor.readValue()
    print("Reading after calibration: \(reading)")

}

func run<S: AdvancedSensor>(sensor: S) async {
    for _ in 1...5 {
        await sensor.readValue()
        print(sensor.getInfo())
    }
}
var fakeHeartSensor = FakeHeartSensor()
var temperatureFakeSensor = TemperatureSensor()
await setupSensor(sensor: fakeHeartSensor)
await setupSensor(sensor: temperatureFakeSensor)


let sensor1 = FakeHeartSensor()
let sensor2 = FakeHeartSensor()
await setupSensor(sensor: sensor1)
await setupSensor(sensor: sensor2)
await compareReading(s1: sensor1, s2: sensor2)