// MARK: - Error Handling

enum SensorError: Error {
    case disconnected
    case lowBattery
    case calibrationFailed
    case timeout
}

// MARK: - Protocols

protocol SensorReadable {
    associatedtype Reading
    var value: Reading { get set }
    func getRandomValue() throws
    func getInfo() throws -> String
}

protocol Calibratable {
    func calibrate() throws
}

protocol AdvancedSensor: SensorReadable {
    var name: String { get }
}

// MARK: - Protocol Extensions

extension AdvancedSensor {
    func getInfo() throws -> String {
        if Bool.random() {
            throw SensorError.disconnected
        }
        return "Named: \(self.name)\nValue: \(self.value)"
    }
}

// MARK: - Sensor Classes

class FakeHeartSensor: AdvancedSensor & Calibratable {
    var value: Int = 0
    var name = "Heart Sensor"
    
    func getRandomValue() throws {
        if Bool.random() {
            throw SensorError.timeout
        }
        value = Int.random(in: 50...160)
    }
    
    func calibrate() throws {
        if Bool.random() {
            throw SensorError.calibrationFailed
        }
        value = Int.random(in: 40...70)
    }
}

class TemperatureSensor: AdvancedSensor & Calibratable {
    var value: Double = 0
    var name = "Temperature Sensor"
    
    func getRandomValue() throws {
        if Bool.random() {
            throw SensorError.disconnected
        }
        value = Double.random(in: -10.0...40.0)
    }
    
    func getInfo() throws -> String {
        if Bool.random() {
            throw SensorError.lowBattery
        }
        return "Named: \(self.name)\nValue: \(self.value)°C"
    }
    
    func calibrate() throws {
        if Bool.random() {
            throw SensorError.calibrationFailed
        }
        value = Double.random(in: 15.0...25.0)
    }
}

// MARK: - Generic Functions

func compareReading<S1: SensorReadable, S2: SensorReadable>(s1: S1, s2: S2) -> Bool
    where S1.Reading == S2.Reading, S1.Reading: Comparable {
    if s1.value > s2.value {
        print("Sensor1 (\(s1.value)) > Sensor2 (\(s2.value))")
        return true
    } else {
        print("Sensor2 (\(s2.value)) >= Sensor1 (\(s1.value))")
        return false
    }
}

// MARK: - Factory Functions

func createHeartSensor() -> some AdvancedSensor & Calibratable {
    return FakeHeartSensor()
}

func createTemperatureSensor() -> some AdvancedSensor & Calibratable {
    return TemperatureSensor()
}

// MARK: - Usage

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
        print("❌ Sensor is disconnected")
    } catch SensorError.lowBattery {
        print("❌ Sensor is low on battery")
    } catch SensorError.calibrationFailed {
        print("❌ Calibration failed")
    } catch SensorError.timeout {
        print("❌ Sensor timeout")
    }
}