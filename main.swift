protocol SensorReadable {
    associatedtype Reading
    var value: Reading {get set}
    func getRandomValue()
    func getInfo() -> String
}

protocol Calibratable {
    func calibrate()
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
    func getRandomValue() {
        value = Int.random(in: 50...160)
    }

    func calibrate() {
        value = Int.random(in: 40...70) 
    }
}

class TemperatureSensor: AdvancedSensor  & Calibratable {
    var value: Double = 0
    var name = "Temperature sensor"
    func getRandomValue() {
        value = Double.random(in: -10.0...40.0)
    }

    func getInfo() -> String {
        return "Iam override ? Yes"
    }

    func calibrate() {
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

func setupSensor<S: AdvancedSensor & Calibratable>(sensor: S) {
    print(sensor.name)
    sensor.calibrate()
    print("Reading before calibration: \(sensor.value)")
    sensor.getRandomValue()
    print("Reading after calibration: \(sensor.value)")

}

func run<S: AdvancedSensor>(sensor: S) {
    for _ in 1...5 {
        sensor.getRandomValue()
        print(sensor.getInfo())
    }
}

func createHeartSensor() -> some AdvancedSensor & Calibratable {
    return FakeHeartSensor()
}

func createTemperatureSensor() -> some AdvancedSensor & Calibratable {
    return TemperatureSensor()
}

// let sensor1 = createHeartSensor()
// let sensor2 = createHeartSensor()
// setupSensor(sensor: sensor1)  
// setupSensor(sensor: sensor2)

let sensors: [any SensorReadable] = [
    FakeHeartSensor(),
    TemperatureSensor()
]

for sensor in sensors {
    sensor.getRandomValue()
    print(sensor.getInfo())
}