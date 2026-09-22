enum SensorError: Error {
    case disconnected
    case lowBattery
    case calibrationFailed
    case timeout
}



protocol SensorReadable {
    associatedtype Reading
    var value: Reading {get set}
    func getRandomValue() throws
    func getInfo() throws -> String
}

protocol Calibratable {
    func calibrate() throws
}

protocol AdvancedSensor: SensorReadable {
    var name: String {get}
} 

extension AdvancedSensor {
    func getInfo() throws -> String {
            if Bool.random() {
                print("Sensor is disconnected")
            throw SensorError.disconnected
            }
            return "Named : \(self.name) \n value : \(self.value)"
        }
}

class FakeHeartSensor: AdvancedSensor & Calibratable{
    var value: Int = 0
    var name = "Heart sensor"
    func getRandomValue() throws {
        if Bool.random() {
            throw SensorError.timeout
        }
        value = Int.random(in: 50...160)
    }

    func calibrate() throws {
        if Bool.random() {
            print("Calibration failed")
            throw SensorError.calibrationFailed
        }
        value = Int.random(in: 40...70) 
    }
}

class TemperatureSensor: AdvancedSensor  & Calibratable {
    var value: Double = 0
    var name = "Temperature sensor"
    func getRandomValue() throws {
        if Bool.random() {
            throw SensorError.disconnected
        }
        value = Double.random(in: -10.0...40.0)
    }

    func getInfo() throws -> String {
        if Bool.random() {
            print("Sensor is low on battery")
            throw SensorError.lowBattery
        }
        return "Named : \(self.name) \n value : \(self.value)"
    }

    func calibrate() throws {
        if Bool.random() {
            print("Calibration failed")
            throw SensorError.calibrationFailed
        }
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

let sensors: [any SensorReadable & Calibratable] = [
    FakeHeartSensor(),
    TemperatureSensor()
]

for sensor in sensors {
    do {
        try sensor.calibrate()
        try sensor.getRandomValue()
        print(try sensor.getInfo())
    } catch SensorError.disconnected {
        print("Sensor is disconnected")
    } catch SensorError.lowBattery {
        print("Sensor is low on battery")
    } catch SensorError.calibrationFailed {
        print("Calibration failed")
    } catch SensorError.timeout {
        print("Sensor timeout")
    }
    
}