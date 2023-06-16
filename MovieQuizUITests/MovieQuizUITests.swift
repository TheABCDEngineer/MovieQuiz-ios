//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Avtor_103 on 15.06.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testLoadIndicatorOnLaunch() throws {
        let loadIndicator = app
            .descendants(matching: .activityIndicator)
            .matching(identifier: "loadIndicator")
            .element
        print(loadIndicator)
      
        XCTAssertNotNil(loadIndicator)
        XCTAssertFalse(loadIndicator.accessibilityElementsHidden)
    }
    
    func testChangePosterOnYesButtonClick() throws {
        sleep(3)
        let button = app.buttons["Yes"]
        
        XCTAssert(button.exists)
        XCTAssertTrue(button.isEnabled)
        
        let firstPoster = app
            .images["Poster"]
            .screenshot()
            .pngRepresentation
        
        button.tap()
        sleep(3)
        
        let secondPoster = app
            .images["Poster"]
            .screenshot()
            .pngRepresentation
    
        XCTAssertNotEqual(firstPoster, secondPoster)
        XCTAssertEqual(app.staticTexts["QuestionIndex"].label, "2/10")
    }
    
    func testChangePosterOnNoButtonClick() throws {
        sleep(3)
        let button = app.buttons["No"]
        
        XCTAssert(button.exists)
        XCTAssertTrue(button.isEnabled)
        
        let firstPoster = app
            .images["Poster"]
            .screenshot()
            .pngRepresentation
        
        button.tap()
        sleep(3)
        
        let secondPoster = app
            .images["Poster"]
            .screenshot()
            .pngRepresentation
        
        XCTAssertNotEqual(firstPoster, secondPoster)
        XCTAssertEqual(app.staticTexts["QuestionIndex"].label, "2/10")
    }
    
    func testQuestionIndexChangeOnYesButtonClick() throws {
        sleep(3)
        
        for i in 1...10 {
            let index = String(i) + "/10"
            XCTAssertEqual(app.staticTexts["QuestionIndex"].label, index)
            
            app.buttons["Yes"].tap()
            sleep(3)
        }
    }
    
    func testQuestionIndexChangeOnNoButtonClick() throws {
        sleep(3)
        
        for i in 1...10 {
            let index = String(i) + "/10"
            XCTAssertEqual(app.staticTexts["QuestionIndex"].label, index)
            
            app.buttons["No"].tap()
            sleep(3)
        }
    }
    
    func testFinishQuizAlertApear() throws {
        sleep(3)
        
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        
        let alert = app
            .descendants(matching: .alert)
            .matching(identifier: "Alert")
            .element
        
        XCTAssert(alert.exists)
        XCTAssertEqual(alert.label, "Этот радунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }
    
    func testFinishQuizAlertDismiss() throws {
        sleep(3)

        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        
        let alert = app
            .descendants(matching: .alert)
            .matching(identifier: "Alert")
            .element
        
        XCTAssert(alert.exists)
        
        alert.buttons.firstMatch.tap()
        sleep(3)
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(app.staticTexts["QuestionIndex"].label, "1/10")
    }
    
    func testShowUserResponse() throws {
        sleep(5)
        let originalPoster = app.images["Poster"].screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        let posterWithResponseUIChanges = app.images["Poster"].screenshot().pngRepresentation
        
        XCTAssertNotEqual(originalPoster, posterWithResponseUIChanges)
    }
}
