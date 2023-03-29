import Foundation

public class DispatchSemaphoreTest {
    public init() {}
    
    public func test() {
        //Avoid race condition by using wait and signal functions
        let semaphore: DispatchSemaphore  = DispatchSemaphore(value: 1)
        for i in 1...5 {
            semaphore.wait()
            print(i)
            semaphore.signal()
        }
    }
}
