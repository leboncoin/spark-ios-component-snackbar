//
//  SnackbarGetColorsUseCaseTests.swift
//  SparkSnackbar
//
//  Created by louis.borlee on 03/09/2024.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import XCTest
@testable import SparkSnackbar
@_spi(SI_SPI) @testable import SparkSnackbarTesting
@_spi(SI_SPI) import SparkThemingTesting

final class SnackbarGetColorsUseCaseTests: XCTestCase {

    private let colors = ThemeGeneratedMock.mocked().colors
    private let useCase = SnackbarGetColorsUseCase()

    // MARK: - Variant Filled
    func test_filled_success() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .success,
            variant: .filled
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.feedback.success))
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.feedback.onSuccess))
    }

    func test_filled_alert() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .alert,
            variant: .filled
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.feedback.alert), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.feedback.onAlert), "Wrong foreground color")
    }

    func test_filled_error() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .error,
            variant: .filled
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.feedback.error), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.feedback.onError), "Wrong foreground color")
    }

    func test_filled_info() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .info,
            variant: .filled
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.feedback.info), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.feedback.onInfo), "Wrong foreground color")
    }

    func test_filled_neutral() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .neutral,
            variant: .filled
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.feedback.neutral), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.feedback.onNeutral), "Wrong foreground color")
    }

    func test_filled_main() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .main,
            variant: .filled
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.main.main), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.main.onMain), "Wrong foreground color")
    }

    func test_filled_basic() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .basic,
            variant: .filled
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.basic.basic), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.basic.onBasic), "Wrong foreground color")
    }

    func test_filled_support() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .support,
            variant: .filled
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.support.support), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.support.onSupport), "Wrong foreground color")
    }

    func test_filled_accent() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .accent,
            variant: .filled
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.accent.accent), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.accent.onAccent), "Wrong foreground color")
    }

    func test_filled_surfaceInverse() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .surfaceInverse,
            variant: .filled
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.base.surfaceInverse), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.base.onSurfaceInverse), "Wrong foreground color")
    }

    // MARK: - Variant Tinted
    func test_tinted_success() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .success,
            variant: .tinted
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.feedback.successContainer), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.feedback.onSuccessContainer), "Wrong foreground color")
    }

    func test_tinted_alert() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .alert,
            variant: .tinted
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.feedback.alertContainer), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.feedback.onAlertContainer), "Wrong foreground color")
    }

    func test_tinted_error() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .error,
            variant: .tinted
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.feedback.errorContainer), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.feedback.onErrorContainer), "Wrong foreground color")
    }

    func test_tinted_info() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .info,
            variant: .tinted
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.feedback.infoContainer), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.feedback.onInfoContainer), "Wrong foreground color")
    }

    func test_tinted_neutral() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .neutral,
            variant: .tinted
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.feedback.neutralContainer), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.feedback.onNeutralContainer), "Wrong foreground color")
    }

    func test_tinted_main() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .main,
            variant: .tinted
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.main.mainContainer), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.main.onMainContainer), "Wrong foreground color")
    }

    func test_tinted_basic() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .basic,
            variant: .tinted
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.basic.basicContainer), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.basic.onBasicContainer), "Wrong foreground color")
    }

    func test_tinted_support() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .support,
            variant: .tinted
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.support.supportContainer), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.support.onSupportContainer), "Wrong foreground color")
    }

    func test_tinted_accent() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .accent,
            variant: .tinted
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.accent.accentContainer), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.accent.onAccentContainer), "Wrong foreground color")
    }

    func test_tinted_surfaceInverse() {
        // GIVEN - WHEN
        let snackbarColors = self.useCase.execute(
            colors: self.colors,
            intent: .surfaceInverse,
            variant: .tinted
        )

        // THEN
        XCTAssertTrue(snackbarColors.background.equals(self.colors.base.surfaceInverse), "Wrong background color")
        XCTAssertTrue(snackbarColors.foreground.equals(self.colors.base.onSurfaceInverse), "Wrong foreground color")
    }
}
