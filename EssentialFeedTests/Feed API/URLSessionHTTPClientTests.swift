//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Matias Glessi on 17/12/2020.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    struct UnexpectedValuesRepresentation: Error {}
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
}


class URLSessionHTTPClientTests: XCTestCase {
    
    override class func setUp() {
        URLProtocolStub.startInterceptingRequests()
    }
    
    override class func tearDown() {
        URLProtocolStub.stopInterceptingRequests()
    }

    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")

        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = NSError(domain: "any error", code: 1)
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)
        XCTAssertNotNil(receivedError)
    }
    
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        let anyData = Data("any data".utf8)
        let anyError = NSError(domain: "any error", code: 0)
        let nonHTTPURLResponse = URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let anyHTTPURLResponse = HTTPURLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)

        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nil, error: anyError))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse, error: anyError))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse, error: anyError))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nonHTTPURLResponse, error: anyError))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: anyHTTPURLResponse, error: anyError))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nonHTTPURLResponse, error: nil))
    }
    
    // MARK: - Helpers
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        let sut = makeSUT(file: file, line: line)
        
        let exp = expectation(description: "Wait for completion")
        
        var recievedError: Error?
        sut.get(from: anyURL()) { result in
            switch result {
            case let .failure(error):
                recievedError = error
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return recievedError
    }
    
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub( data: Data?, response: URLResponse?, error: Error? = nil) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
