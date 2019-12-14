//
//  TestServerPerfomance.swift
//  image-editorUnitTests
//
//  Created by yenz0redd on 13.12.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import XCTest

class TestServerPerfomance: XCTestCase {
    private func configurePath(for base: String, with keys: [String]) -> String {
        var result = base

        guard !keys.isEmpty else { return result }

        keys.forEach { result.append("/\($0)") }

        return "\(result)/"
    }

    func testServer() {
        let numberOfUsers = 30
        let rampUp: UInt32 = 1
        let loopCount = 10

        let base = "https://source.unsplash.com/?featured"
        let keys = ["canada"]

        let path = self.configurePath(for: base, with: keys)

        guard let url = URL(string: path) else { XCTFail("server test: incorrect url"); return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        var resultResponsesCount = 0
        for _ in (0..<loopCount) {
            let session = URLSession(configuration: .default)
            let loopDispatchGroup = DispatchGroup()
            var numberOfResponses = 0
            for _ in (0..<numberOfUsers) {
                loopDispatchGroup.enter()
                session.dataTask(with: request) { data, response, err in
                    guard data != nil, err == nil else {
                        XCTFail("server test: incorrect data/ err")
                        return
                    }
                    guard let response = response as? HTTPURLResponse else {
                        XCTFail("server test: incorrect response")
                        return
                    }
                    guard response.statusCode == 200 else {
                        XCTFail("server test: incorrect response code")
                        return
                    }
                    print(numberOfResponses)
                    numberOfResponses += 1
                    loopDispatchGroup.leave()
                }.resume()
            }
            while numberOfResponses != numberOfUsers {
                loopDispatchGroup.notify(queue: .main) {
                    print("lived")
                }
            }
            resultResponsesCount += numberOfResponses
            sleep(rampUp)
        }

        XCTAssert(resultResponsesCount == numberOfUsers * loopCount, "server test: perfomance faild")
    }
}
