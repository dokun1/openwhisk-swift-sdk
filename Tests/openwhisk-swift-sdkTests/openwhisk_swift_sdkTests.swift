import XCTest
@testable import openwhisk_swift_sdk

final class openwhisk_swift_sdkTests: XCTestCase {
    var agent: Agent?
    
    struct Currency: Codable {
        var code: String
    }
    
    override func setUp() {
        let newAgent = Agent()
        newAgent.apiKey = "2fead91c-2ca8-481f-bd3e-4468821b4d5f"
        newAgent.secret = "YgP0ywUcAlhpJKD4UA9Uw1NPSmMPZZNPmtHz6U75yiSzS94MBnOLkJeYUUF8OmfO"
        newAgent.organization = "david.okun"
        newAgent.space = "dev"
        newAgent.host = "https://openwhisk.ng.bluemix.net"
        agent = newAgent
    }
    
    func testGetActions() {
        guard let agent = agent else {
            XCTFail("Set up method not working")
            return
        }
        let actionExpectation = expectation(description: "Should retrieve actions")
        agent.getActions { actions, error in
            XCTAssertNotNil(actions, "Should have received at least some actions")
            XCTAssertNil(error, "Should not have an error on successful request for all actions")
            actionExpectation.fulfill()
        }
        wait(for: [actionExpectation], timeout: 30)
    }
    
    func testAsyncInvoke() {
        guard let agent = agent else {
            XCTFail("Set up method not working")
            return
        }
        let actionInvokeExpectation = expectation(description: "Should invoke fetchForeignBitcoin action without blocking")
        agent.getActions { actions, error in
            guard let actions = actions else {
                XCTFail("Could not retrieve actions")
                actionInvokeExpectation.fulfill()
                return
            }
            for action in actions where action.name == "fetchForeignBitcoin" {
                agent.invoke(action: action, input: Currency(code: "USD"), completion: { response, error in
                    XCTAssertNotNil(response, "Response should not be nil during successful request")
                    XCTAssertNil(error, "Error should be nil during successful response")
                    XCTAssertNotNil(response?.activationId, "Async invocation should yield at least an activation ID")
                    actionInvokeExpectation.fulfill()
                })
            }
        }
        wait(for: [actionInvokeExpectation], timeout: 30)
    }
    
    func testBlockingInvoke() {
        guard let agent = agent else {
            XCTFail("Set up method not working")
            return
        }
        let actionInvokeExpectation = expectation(description: "Should invoke fetchForeignBitcoin action")
        agent.getActions { actions, error in
            guard let actions = actions else {
                XCTFail("Could not retrieve actions")
                actionInvokeExpectation.fulfill()
                return
            }
            for action in actions where action.name == "fetchForeignBitcoin" {
                agent.invoke(action: action, input: Currency(code: "USD"), blocking: true, resultOnly: false, completion: { response, error in
                    XCTAssertNotNil(response)
                    XCTAssertNil(error)
                    XCTAssertEqual(action.name, response?.name, "Action name should be equal to invocation name")

                    actionInvokeExpectation.fulfill()
                })
            }
        }
        wait(for: [actionInvokeExpectation], timeout: 30)
    }


    static var allTests = [
        ("testGetActions", testGetActions), ("testAsyncInvoke", testAsyncInvoke), ("testBlockingInvoke", testBlockingInvoke)
    ]
}
