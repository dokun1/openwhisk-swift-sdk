import XCTest
@testable import openwhisk_swift_sdk

final class openwhisk_swift_sdkTests: XCTestCase {
    var agent: Agent?
    
    struct Currency: Codable {
        var code: String
    }
    
    struct CurrencyResponse: Codable {
        var currency: CurrencyResponseCurrency
        struct CurrencyResponseCurrency: Codable {
            var currencyCode: String
            var name: String
            var value: Double
        }
    }
    
    override func setUp() {
        let newAgent = Agent()
        guard let credentials = OWENV.fetchCredentials() else {
            return
        }
        newAgent.apiKey = credentials.apiKey
        newAgent.secret = credentials.secret
        newAgent.namespace = credentials.namespace
        newAgent.host = credentials.host
        agent = newAgent
    }
    
    func testGetActionWithCode() {
        guard let agent = agent else {
            XCTFail("Set up method not working")
            return
        }
        let actionExpectation = expectation(description: "Should retrieve actions with code included")
        agent.getActions() { actions, error in
            XCTAssertNotNil(actions, "Should have received at least some actions")
            XCTAssertNil(error, "Should not have an error on successful request for all actions")
            guard let firstAction = actions?.first else {
                XCTFail("Could not get first action from returned collection")
                actionExpectation.fulfill()
                return
            }
            agent.getActionDetail(firstAction) { details, error in
                XCTAssertEqual(details?.name, firstAction.name, "Action name should equal retrieved details name")
                XCTAssertNotNil(details?.exec?.code, "Should have code included as string for all actions")
                actionExpectation.fulfill()
            }
        }
        wait(for: [actionExpectation], timeout: 30)
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
                agent.invoke(action: action, input: Currency(code: "USD"), responseType: CurrencyResponse.self, blocking: false, resultOnly: false, completion: { response, error in
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
                agent.invoke(action: action, input: Currency(code: "USD"), responseType: CurrencyResponse.self, blocking: true, resultOnly: false, completion: { response, error in
                    XCTAssertNotNil(response, "Should have received a response")
                    XCTAssertNil(error, "Should not have received an error")
                    XCTAssertEqual(action.name, response?.name, "Action name should be equal to invocation name")
                    
                    actionInvokeExpectation.fulfill()
                })
            }
        }
        wait(for: [actionInvokeExpectation], timeout: 30)
    }
    
    func testResultOnlyInvoke() {
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
                agent.invoke(action: action, input: Currency(code: "USD"), responseType: CurrencyResponse.self, blocking: true, resultOnly: true, completion: { response, error in
                    XCTAssertNotNil(response, "Should have received a response")
                    XCTAssertNil(error, "Should not have received an error")
                    XCTAssertNotNil(response?.output, "The actual response output should not be nil")
                    XCTAssertNil(response?.activationId, "When specifying only the result, all other fields should be nil")
                    
                    actionInvokeExpectation.fulfill()
                })
            }
        }
        wait(for: [actionInvokeExpectation], timeout: 30)
    }


    static var allTests = [
        ("testGetActions", testGetActions), ("testAsyncInvoke", testAsyncInvoke), ("testBlockingInvoke", testBlockingInvoke), ("testGetActionsWithCode", testGetActionWithCode), ("testResultOnlyInvoke", testResultOnlyInvoke)
    ]
}
