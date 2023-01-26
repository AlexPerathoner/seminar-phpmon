//
//  VersionExtractorTest.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 16/12/2021.
//  Copyright © 2023 Nico Verbruggen. All rights reserved.
//

import XCTest

class VersionExtractorTest: XCTestCase {

    func test_extract_version() {
        XCTAssertEqual(VersionExtractor.from("Laravel Valet 2.17.1"), "2.17.1")
        XCTAssertEqual(VersionExtractor.from("Laravel Valet 2.0"), "2.0")
    }

    func test_version_comparison() {
        XCTAssertEqual("2.0".versionCompare("2.1"), .orderedAscending)
        XCTAssertEqual("2.1".versionCompare("2.0"), .orderedDescending)
        XCTAssertEqual("2.0".versionCompare("2.0"), .orderedSame)
        XCTAssertEqual("2.17.0".versionCompare("2.17.1"), .orderedAscending)
    }

}
