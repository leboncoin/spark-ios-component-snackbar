//
//  SnackbarIntentTests.swift
//  SparkSnackbar
//
//  Created by louis.borlee on 03/09/2024.
//  Copyright © 2024 Leboncoin. All rights reserved.
//

import XCTest
@testable import SparkSnackbar
@_spi(SI_SPI) @testable import SparkSnackbarTesting
@_spi(SI_SPI) import SparkThemingTesting

final class SnackbarIntentTests: XCTestCase {

    private let theme = ThemeGeneratedMock.mocked()

    func test_internal_getColors() throws {
        // GIVEN
        let useCaseMock = SnackbarGetColorsUseCasableGeneratedMock()
        useCaseMock.executeWithColorsAndIntentAndVariantReturnValue = .init(
            background: self.theme.colors.feedback.alert,
            foreground: self.theme.colors.main.onMain
        )

        // WHEN
        let colors = SnackbarIntent.alert.getColors(theme: self.theme, variant: .filled, getColorsUseCase: useCaseMock)

        // THEN - Values
        XCTAssertTrue(colors.background.equals(self.theme.colors.feedback.alert), "Wrong background color")
        XCTAssertTrue(colors.foreground.equals(self.theme.colors.main.onMain), "Wrong foreground color")

        // THEN - UseCase
        XCTAssertEqual(useCaseMock.executeWithColorsAndIntentAndVariantCallsCount, 1, "useCaseMock.executeWithColorsAndIntentAndVariant should have been called once")
        let receivedArguments = try XCTUnwrap(useCaseMock.executeWithColorsAndIntentAndVariantReceivedArguments, "Couldn't unwrap receivedArguments")
        XCTAssertIdentical(
            receivedArguments.colors as? ColorsGeneratedMock,
            self.theme.colors as? ColorsGeneratedMock,
            "Wrong receivedArguments.colors"
        )
        XCTAssertEqual(receivedArguments.variant, .filled, "Wrong receivedArguments.variant")
        XCTAssertEqual(receivedArguments.intent, .alert, "Wrong receivedArguments.intent")
    }

    func test_used_getColorsUseCase() {
        for intent in SnackbarIntent.allCases {
            XCTAssertTrue(intent.getColorsUseCase is SnackbarGetColorsUseCase, "Wrong getColorsUseCase type for intent \(intent)")
        }
    }

}
