//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Сергей Андреев on 29.10.2022.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        //given
        let array = [1, 1, 2, 3, 5]
        //when
        let value = array[safe: 2]
        //then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    func testGetValueOutOfRange() throws {
        //given
        let array = [1, 1, 2, 3, 5]
        //when
        let value = array[safe: 20]
        //then
        XCTAssertNil(value)
    }
}
