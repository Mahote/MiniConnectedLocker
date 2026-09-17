protocol SensorReadable {
    func readValue() async -> Int
}

struct FakeHeartSensor: SensorReadable {
    func readValue() async -> Int {
        // Simulate reading a value from a sensor
        try? await Task.sleep(nanoseconds: 500_000_000) // Simulate delay
        return Int.random(in: 50...180)
    }
}

func run() async {
    let sensor = FakeHeartSensor()
    for _ in 1...5 {
        let bpm = await sensor.readValue()
        print("Heart Rate: \(bpm) BPM")
    }
}

await run()