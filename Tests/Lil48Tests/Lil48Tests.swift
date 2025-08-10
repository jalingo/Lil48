import Testing
@testable import Lil48

/// Basic tests to verify package structure
struct Lil48Tests {
    
    @Test("Library initializes successfully")
    func initialization_succeeds() {
        let game = Lil48()
        // Test passes if no exception is thrown during initialization
    }
    
    @Test("Version is accessible")
    func version_isAccessible() {
        #expect(Lil48.version == "1.0.0")
    }
}