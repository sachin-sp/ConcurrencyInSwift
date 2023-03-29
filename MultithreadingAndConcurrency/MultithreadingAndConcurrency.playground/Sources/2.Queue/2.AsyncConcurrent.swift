import Foundation

public class AsyncConcurrent {
    public init() {}
    
    public func test() {
        let concurrentQueue = DispatchQueue(label: "concurrentQueue", qos: .background, attributes: .initiallyInactive, autoreleaseFrequency: .never, target: nil)
        concurrentQueue.async {
            for i in 1...3 {
                print("\(i) Task 1")
                sleep(1)
            }
        }
        concurrentQueue.async {
            for i in 4...7 {
                sleep(1)
                print("\(i) Task 2")
            }
        }
        concurrentQueue.async {
            for i in 8...10 {
                print("\(i) Task 3")
            }
        }
    }
    
    public func test1() {
        let serialQueue = DispatchQueue(label: "concurrentQueue", qos: .background, autoreleaseFrequency: .never, target: nil)
        
        serialQueue.async {
            for i in 1...3 {
                sleep(1)
                print("\(i) Task 1")
            }
        }
        serialQueue.async {
            for i in 4...7 {
                print("\(i) Task 2")
            }
        }
        serialQueue.async {
            for i in 8...10 {
                print("\(i) Task 3")
            }
        }
    }
}
