import Foundation

public class DispatchGroupTest{
    public init() {}
    public func test() {
        let queue = DispatchQueue(label: "queue")
        let dispatchGroup = DispatchGroup()
        var count = 0
        
        dispatchGroup.enter()
        queue.async {
            for i in 1...3 {
                count += i
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        queue.async {
            for i in 4...6 {
                sleep(1)
                count += i
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        queue.async {
            for i in 7...10 {
                count += i
            }
            dispatchGroup.leave()
        }
        // dispatchGroup.wait()
        let waitResult = dispatchGroup.wait(timeout: .now() + 10)
//        dispatchGroup.notify(queue: queue) {
//            print("Count = \(count)")
//        }
        switch waitResult {
        case .success:
            print("got response before timeout")
        case .timedOut:
            print("got response after timeout")
        }
        print("Count = \(count)")
    }
}
