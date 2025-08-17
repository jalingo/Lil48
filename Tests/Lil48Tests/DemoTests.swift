import Testing
@testable import Lil48

struct DemoTests {
    
    @Test("Grid demo runs without crashing")
    func demo_runs_withoutCrashing() {
        GridDemo.run()
    }
}