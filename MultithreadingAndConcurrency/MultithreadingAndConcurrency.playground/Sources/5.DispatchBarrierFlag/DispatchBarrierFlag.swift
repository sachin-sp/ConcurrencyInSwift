import Foundation

public class DispatchBarrierFlag {
    public init() {}
    
    public func test() {
        //Block race condition by settin flags as barrier
        DispatchQueue.global().async(flags: .barrier) {
            for i in 1...5 {
                print(i)
            }
        }
    }
}
