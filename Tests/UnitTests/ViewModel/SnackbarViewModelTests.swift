//
//  SnackbarViewModelTests.swift
//  SparkSnackbar
//
//  Created by louis.borlee on 04/09/2024.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import XCTest
import Combine
import SparkTheming
import SparkButton
@testable import SparkSnackbar
@_spi(SI_SPI) @testable import SparkSnackbarTesting
@_spi(SI_SPI) import SparkThemingTesting
@_spi(SI_SPI) import SparkCommonTesting

final class SnackbarViewModelTests: XCTestCase {

    private let theme = ThemeGeneratedMock.mocked()
    private var publishers: SnackbarPublishers!

    override func setUp() {
        super.setUp()
        self.publishers = nil
    }

    func setupPublishers(viewModel: SnackbarViewModel) {
        self.publishers = .init(
            backgroundColor: PublisherMock(publisher: viewModel.$backgroundColor),
            foregroundColor: PublisherMock(publisher: viewModel.$foregroundColor),
            buttonIntent: PublisherMock(publisher: viewModel.$buttonIntent),
            buttonVariant: PublisherMock(publisher: viewModel.$buttonVariant)
        )
        self.publishers.load()
    }

    func test_init() throws {
        // GIVEN
        let expectedBackgroundColor = ColorTokenGeneratedMock.blue()
        let expectedForegroundColor = ColorTokenGeneratedMock.red()
        let getColorsUseCaseMock = SnackbarGetColorsUseCasableGeneratedMock()
        getColorsUseCaseMock.executeWithColorsAndIntentAndVariantReturnValue = .init(
            background: expectedBackgroundColor,
            foreground: expectedForegroundColor
        )

        let expectedButtonIntent = ButtonIntent.accent
        let expectedButtonVariant = ButtonVariant.outlined
        let getButtonTypeUseCaseMock = SnackbarGetButtonTypeUseCasableGeneratedMock()
        getButtonTypeUseCaseMock.executeWithIntentAndVariantReturnValue = .init(
            intent: expectedButtonIntent,
            variant: expectedButtonVariant
        )

        let expectedIntent = SnackbarIntent.basic
        let expectedVariant = SnackbarVariant.tinted

        // WHEN
        let viewModel = SnackbarViewModel(
            theme: self.theme,
            variant: expectedVariant,
            intent: expectedIntent,
            getColorsUseCase: getColorsUseCaseMock,
            getButtonTypeUseCase: getButtonTypeUseCaseMock
        )
        self.setupPublishers(viewModel: viewModel)

        // THEN - Values
        XCTAssertEqual(viewModel.intent, expectedIntent, "Wrong intent")
        XCTAssertEqual(viewModel.variant, expectedVariant, "Wrong variant")

        XCTAssertTrue(viewModel.backgroundColor.equals(expectedBackgroundColor), "Wrong background color")
        XCTAssertTrue(viewModel.foregroundColor.equals(expectedForegroundColor), "Wrong foreground color")

        XCTAssertEqual(viewModel.buttonIntent, expectedButtonIntent, "Wrong button intent")
        XCTAssertEqual(viewModel.buttonVariant, expectedButtonVariant, "Wrong button variant")

        // THEN - UseCases
        XCTAssertEqual(getColorsUseCaseMock.executeWithColorsAndIntentAndVariantCallsCount, 1, "getColorsUseCaseMock.executeWithColorsAndIntentAndVariant should have been called once")
        let getColorsUseCaseReceivedArguments = try XCTUnwrap(
            getColorsUseCaseMock.executeWithColorsAndIntentAndVariantReceivedArguments,
            "Couldn't unwrap getColorsUseCaseReceivedArguments"
        )
        let getColorsUseCaseReceivedArgumentsColors = try XCTUnwrap(getColorsUseCaseReceivedArguments.colors as? ColorsGeneratedMock, "Couldn't unwrap getColorsUseCaseReceivedArgumentsColors")
        XCTAssertIdentical(getColorsUseCaseReceivedArgumentsColors, self.theme.colors as? ColorsGeneratedMock, "Wrong received getColorsUseCase.colors")
        XCTAssertEqual(getColorsUseCaseReceivedArguments.intent, expectedIntent, "Wrong received getColorsUseCase.intent")
        XCTAssertEqual(getColorsUseCaseReceivedArguments.variant, expectedVariant, "Wrong received getColorsUseCase.variant")

        XCTAssertEqual(getButtonTypeUseCaseMock.executeWithIntentAndVariantCallsCount, 1, "getButtonTypeUseCaseMock.executeWithIntentAndVariant should have been called once")
        let getButtonTypeUseCaseReceivedArguments = try XCTUnwrap(
            getButtonTypeUseCaseMock.executeWithIntentAndVariantReceivedArguments,
            "Couldn't unwrap getButtonTypeUseCaseReceivedArguments"
        )
        XCTAssertEqual(getButtonTypeUseCaseReceivedArguments.intent, expectedIntent, "Wrong received getButtonTypeUseCase.intent")
        XCTAssertEqual(getButtonTypeUseCaseReceivedArguments.variant, expectedVariant, "Wrong received getButtonTypeUseCase.variant")

        // THEN - Publishers
        XCTAssertEqual(self.publishers.backgroundColor.sinkCount, 1, "$backgroundColor should have been called once")
        XCTAssertEqual(self.publishers.foregroundColor.sinkCount, 1, "$foregroundColor should have been called once")
        XCTAssertEqual(self.publishers.buttonIntent.sinkCount, 1, "$buttonIntent should have been called once")
        XCTAssertEqual(self.publishers.buttonVariant.sinkCount, 1, "$buttonVariant should have been called once")
    }

    func test_didSet_theme() throws {
        // GIVEN
        let expectedBackgroundColor = ColorTokenGeneratedMock.blue()
        let expectedForegroundColor = ColorTokenGeneratedMock.red()
        let getColorsUseCaseMock = SnackbarGetColorsUseCasableGeneratedMock()
        getColorsUseCaseMock.executeWithColorsAndIntentAndVariantReturnValue = .init(
            background: expectedBackgroundColor,
            foreground: expectedForegroundColor
        )

        let expectedButtonIntent = ButtonIntent.accent
        let expectedButtonVariant = ButtonVariant.outlined
        let getButtonTypeUseCaseMock = SnackbarGetButtonTypeUseCasableGeneratedMock()
        getButtonTypeUseCaseMock.executeWithIntentAndVariantReturnValue = .init(
            intent: expectedButtonIntent,
            variant: expectedButtonVariant
        )

        let expectedIntent = SnackbarIntent.basic
        let expectedVariant = SnackbarVariant.tinted

        let newTheme = ThemeGeneratedMock.mocked()

        let viewModel = SnackbarViewModel(
            theme: self.theme,
            variant: expectedVariant,
            intent: expectedIntent,
            getColorsUseCase: getColorsUseCaseMock,
            getButtonTypeUseCase: getButtonTypeUseCaseMock
        )
        self.setupPublishers(viewModel: viewModel)

        self.publishers.reset()
        getColorsUseCaseMock.reset()
        getButtonTypeUseCaseMock.reset()

        // WHEN
        viewModel.theme = newTheme

        // THEN - Values
        XCTAssertEqual(viewModel.intent, expectedIntent, "Wrong intent")
        XCTAssertEqual(viewModel.variant, expectedVariant, "Wrong variant")

        XCTAssertTrue(viewModel.backgroundColor.equals(expectedBackgroundColor), "Wrong background color")
        XCTAssertTrue(viewModel.foregroundColor.equals(expectedForegroundColor), "Wrong foreground color")

        XCTAssertEqual(viewModel.buttonIntent, expectedButtonIntent, "Wrong button intent")
        XCTAssertEqual(viewModel.buttonVariant, expectedButtonVariant, "Wrong button variant")

        // THEN - UseCases
        XCTAssertEqual(getColorsUseCaseMock.executeWithColorsAndIntentAndVariantCallsCount, 1, "getColorsUseCaseMock.executeWithColorsAndIntentAndVariant should have been called once")
        let getColorsUseCaseReceivedArguments = try XCTUnwrap(
            getColorsUseCaseMock.executeWithColorsAndIntentAndVariantReceivedArguments,
            "Couldn't unwrap getColorsUseCaseReceivedArguments"
        )
        let getColorsUseCaseReceivedArgumentsColors = try XCTUnwrap(getColorsUseCaseReceivedArguments.colors as? ColorsGeneratedMock, "Couldn't unwrap getColorsUseCaseReceivedArgumentsColors")
        XCTAssertIdentical(getColorsUseCaseReceivedArgumentsColors, newTheme.colors as? ColorsGeneratedMock, "Wrong received getColorsUseCase.colors")
        XCTAssertEqual(getColorsUseCaseReceivedArguments.intent, expectedIntent, "Wrong received getColorsUseCase.intent")
        XCTAssertEqual(getColorsUseCaseReceivedArguments.variant, expectedVariant, "Wrong received getColorsUseCase.variant")

        XCTAssertEqual(getButtonTypeUseCaseMock.executeWithIntentAndVariantCallsCount, 1, "getButtonTypeUseCaseMock.executeWithIntentAndVariant should have been called once")
        let getButtonTypeUseCaseReceivedArguments = try XCTUnwrap(
            getButtonTypeUseCaseMock.executeWithIntentAndVariantReceivedArguments,
            "Couldn't unwrap getButtonTypeUseCaseReceivedArguments"
        )
        XCTAssertEqual(getButtonTypeUseCaseReceivedArguments.intent, expectedIntent, "Wrong received getButtonTypeUseCase.intent")
        XCTAssertEqual(getButtonTypeUseCaseReceivedArguments.variant, expectedVariant, "Wrong received getButtonTypeUseCase.variant")

        // THEN - Publishers
        XCTAssertEqual(self.publishers.backgroundColor.sinkCount, 1, "$backgroundColor should have been called once")
        XCTAssertEqual(self.publishers.foregroundColor.sinkCount, 1, "$foregroundColor should have been called once")
        XCTAssertEqual(self.publishers.buttonIntent.sinkCount, 1, "$buttonIntent should have been called once")
        XCTAssertEqual(self.publishers.buttonVariant.sinkCount, 1, "$buttonVariant should have been called once")
    }

    func test_didSet_intent() throws {
        // GIVEN
        let expectedBackgroundColor = ColorTokenGeneratedMock.blue()
        let expectedForegroundColor = ColorTokenGeneratedMock.red()
        let getColorsUseCaseMock = SnackbarGetColorsUseCasableGeneratedMock()
        getColorsUseCaseMock.executeWithColorsAndIntentAndVariantReturnValue = .init(
            background: expectedBackgroundColor,
            foreground: expectedForegroundColor
        )

        let expectedButtonIntent = ButtonIntent.accent
        let expectedButtonVariant = ButtonVariant.outlined
        let getButtonTypeUseCaseMock = SnackbarGetButtonTypeUseCasableGeneratedMock()
        getButtonTypeUseCaseMock.executeWithIntentAndVariantReturnValue = .init(
            intent: expectedButtonIntent,
            variant: expectedButtonVariant
        )

        let oldIntent = SnackbarIntent.basic
        let expectedVariant = SnackbarVariant.tinted

        let viewModel = SnackbarViewModel(
            theme: self.theme,
            variant: expectedVariant,
            intent: oldIntent,
            getColorsUseCase: getColorsUseCaseMock,
            getButtonTypeUseCase: getButtonTypeUseCaseMock
        )
        self.setupPublishers(viewModel: viewModel)

        self.publishers.reset()
        getColorsUseCaseMock.reset()
        getButtonTypeUseCaseMock.reset()

        let newIntent = SnackbarIntent.error

        // WHEN
        viewModel.intent = newIntent

        // THEN - Values
        XCTAssertEqual(viewModel.intent, newIntent, "Wrong intent")
        XCTAssertEqual(viewModel.variant, expectedVariant, "Wrong variant")

        XCTAssertTrue(viewModel.backgroundColor.equals(expectedBackgroundColor), "Wrong background color")
        XCTAssertTrue(viewModel.foregroundColor.equals(expectedForegroundColor), "Wrong foreground color")

        XCTAssertEqual(viewModel.buttonIntent, expectedButtonIntent, "Wrong button intent")
        XCTAssertEqual(viewModel.buttonVariant, expectedButtonVariant, "Wrong button variant")

        // THEN - UseCases
        XCTAssertEqual(getColorsUseCaseMock.executeWithColorsAndIntentAndVariantCallsCount, 1, "getColorsUseCaseMock.executeWithColorsAndIntentAndVariant should have been called once")
        let getColorsUseCaseReceivedArguments = try XCTUnwrap(
            getColorsUseCaseMock.executeWithColorsAndIntentAndVariantReceivedArguments,
            "Couldn't unwrap getColorsUseCaseReceivedArguments"
        )
        let getColorsUseCaseReceivedArgumentsColors = try XCTUnwrap(getColorsUseCaseReceivedArguments.colors as? ColorsGeneratedMock, "Couldn't unwrap getColorsUseCaseReceivedArgumentsColors")
        XCTAssertIdentical(getColorsUseCaseReceivedArgumentsColors, self.theme.colors as? ColorsGeneratedMock, "Wrong received getColorsUseCase.colors")
        XCTAssertEqual(getColorsUseCaseReceivedArguments.intent, newIntent, "Wrong received getColorsUseCase.intent")
        XCTAssertEqual(getColorsUseCaseReceivedArguments.variant, expectedVariant, "Wrong received getColorsUseCase.variant")

        XCTAssertEqual(getButtonTypeUseCaseMock.executeWithIntentAndVariantCallsCount, 1, "getButtonTypeUseCaseMock.executeWithIntentAndVariant should have been called once")
        let getButtonTypeUseCaseReceivedArguments = try XCTUnwrap(
            getButtonTypeUseCaseMock.executeWithIntentAndVariantReceivedArguments,
            "Couldn't unwrap getButtonTypeUseCaseReceivedArguments"
        )
        XCTAssertEqual(getButtonTypeUseCaseReceivedArguments.intent, newIntent, "Wrong received getButtonTypeUseCase.intent")
        XCTAssertEqual(getButtonTypeUseCaseReceivedArguments.variant, expectedVariant, "Wrong received getButtonTypeUseCase.variant")

        // THEN - Publishers
        XCTAssertEqual(self.publishers.backgroundColor.sinkCount, 1, "$backgroundColor should have been called once")
        XCTAssertEqual(self.publishers.foregroundColor.sinkCount, 1, "$foregroundColor should have been called once")
        XCTAssertEqual(self.publishers.buttonIntent.sinkCount, 1, "$buttonIntent should have been called once")
        XCTAssertEqual(self.publishers.buttonVariant.sinkCount, 1, "$buttonVariant should have been called once")
    }

    func test_didSet_intent_equal() throws {
        // GIVEN
        let expectedBackgroundColor = ColorTokenGeneratedMock.blue()
        let expectedForegroundColor = ColorTokenGeneratedMock.red()
        let getColorsUseCaseMock = SnackbarGetColorsUseCasableGeneratedMock()
        getColorsUseCaseMock.executeWithColorsAndIntentAndVariantReturnValue = .init(
            background: expectedBackgroundColor,
            foreground: expectedForegroundColor
        )

        let expectedButtonIntent = ButtonIntent.accent
        let expectedButtonVariant = ButtonVariant.outlined
        let getButtonTypeUseCaseMock = SnackbarGetButtonTypeUseCasableGeneratedMock()
        getButtonTypeUseCaseMock.executeWithIntentAndVariantReturnValue = .init(
            intent: expectedButtonIntent,
            variant: expectedButtonVariant
        )

        let intent = SnackbarIntent.basic

        let viewModel = SnackbarViewModel(
            theme: self.theme,
            variant: .tinted,
            intent: intent,
            getColorsUseCase: getColorsUseCaseMock,
            getButtonTypeUseCase: getButtonTypeUseCaseMock
        )
        self.setupPublishers(viewModel: viewModel)

        self.publishers.reset()
        getColorsUseCaseMock.reset()
        getButtonTypeUseCaseMock.reset()

        // WHEN
        viewModel.intent = intent

        // THEN - UseCases
        XCTAssertFalse(getColorsUseCaseMock.executeWithColorsAndIntentAndVariantCalled, "getColorsUseCaseMock.executeWithColorsAndIntentAndVariant should not have been called")
        XCTAssertFalse(getButtonTypeUseCaseMock.executeWithIntentAndVariantCalled, "getButtonTypeUseCaseMock.executeWithIntentAndVariant should not have been called")

        // THEN - Publishers
        XCTAssertFalse(self.publishers.backgroundColor.sinkCalled, "$backgroundColor should not have been called")
        XCTAssertFalse(self.publishers.foregroundColor.sinkCalled, "$foregroundColor should not have been called")
        XCTAssertFalse(self.publishers.buttonIntent.sinkCalled, "$buttonIntent should not have been called")
        XCTAssertFalse(self.publishers.buttonVariant.sinkCalled, "$buttonVariant should not have been called")
    }

    func test_didSet_variant() throws {
        // GIVEN
        let expectedBackgroundColor = ColorTokenGeneratedMock.blue()
        let expectedForegroundColor = ColorTokenGeneratedMock.red()
        let getColorsUseCaseMock = SnackbarGetColorsUseCasableGeneratedMock()
        getColorsUseCaseMock.executeWithColorsAndIntentAndVariantReturnValue = .init(
            background: expectedBackgroundColor,
            foreground: expectedForegroundColor
        )

        let expectedButtonIntent = ButtonIntent.accent
        let expectedButtonVariant = ButtonVariant.outlined
        let getButtonTypeUseCaseMock = SnackbarGetButtonTypeUseCasableGeneratedMock()
        getButtonTypeUseCaseMock.executeWithIntentAndVariantReturnValue = .init(
            intent: expectedButtonIntent,
            variant: expectedButtonVariant
        )

        let expectedIntent = SnackbarIntent.basic
        let oldVariant = SnackbarVariant.tinted

        let viewModel = SnackbarViewModel(
            theme: self.theme,
            variant: oldVariant,
            intent: expectedIntent,
            getColorsUseCase: getColorsUseCaseMock,
            getButtonTypeUseCase: getButtonTypeUseCaseMock
        )
        self.setupPublishers(viewModel: viewModel)

        self.publishers.reset()
        getColorsUseCaseMock.reset()
        getButtonTypeUseCaseMock.reset()

        let newVariant = SnackbarVariant.filled

        // WHEN
        viewModel.variant = newVariant

        // THEN - Values
        XCTAssertEqual(viewModel.intent, expectedIntent, "Wrong intent")
        XCTAssertEqual(viewModel.variant, newVariant, "Wrong variant")

        XCTAssertTrue(viewModel.backgroundColor.equals(expectedBackgroundColor), "Wrong background color")
        XCTAssertTrue(viewModel.foregroundColor.equals(expectedForegroundColor), "Wrong foreground color")

        XCTAssertEqual(viewModel.buttonIntent, expectedButtonIntent, "Wrong button intent")
        XCTAssertEqual(viewModel.buttonVariant, expectedButtonVariant, "Wrong button variant")

        // THEN - UseCases
        XCTAssertEqual(getColorsUseCaseMock.executeWithColorsAndIntentAndVariantCallsCount, 1, "getColorsUseCaseMock.executeWithColorsAndIntentAndVariant should have been called once")
        let getColorsUseCaseReceivedArguments = try XCTUnwrap(
            getColorsUseCaseMock.executeWithColorsAndIntentAndVariantReceivedArguments,
            "Couldn't unwrap getColorsUseCaseReceivedArguments"
        )
        let getColorsUseCaseReceivedArgumentsColors = try XCTUnwrap(getColorsUseCaseReceivedArguments.colors as? ColorsGeneratedMock, "Couldn't unwrap getColorsUseCaseReceivedArgumentsColors")
        XCTAssertIdentical(getColorsUseCaseReceivedArgumentsColors, self.theme.colors as? ColorsGeneratedMock, "Wrong received getColorsUseCase.colors")
        XCTAssertEqual(getColorsUseCaseReceivedArguments.intent, expectedIntent, "Wrong received getColorsUseCase.intent")
        XCTAssertEqual(getColorsUseCaseReceivedArguments.variant, newVariant, "Wrong received getColorsUseCase.variant")

        XCTAssertEqual(getButtonTypeUseCaseMock.executeWithIntentAndVariantCallsCount, 1, "getButtonTypeUseCaseMock.executeWithIntentAndVariant should have been called once")
        let getButtonTypeUseCaseReceivedArguments = try XCTUnwrap(
            getButtonTypeUseCaseMock.executeWithIntentAndVariantReceivedArguments,
            "Couldn't unwrap getButtonTypeUseCaseReceivedArguments"
        )
        XCTAssertEqual(getButtonTypeUseCaseReceivedArguments.intent, expectedIntent, "Wrong received getButtonTypeUseCase.intent")
        XCTAssertEqual(getButtonTypeUseCaseReceivedArguments.variant, newVariant, "Wrong received getButtonTypeUseCase.variant")

        // THEN - Publishers
        XCTAssertEqual(self.publishers.backgroundColor.sinkCount, 1, "$backgroundColor should have been called once")
        XCTAssertEqual(self.publishers.foregroundColor.sinkCount, 1, "$foregroundColor should have been called once")
        XCTAssertEqual(self.publishers.buttonIntent.sinkCount, 1, "$buttonIntent should have been called once")
        XCTAssertEqual(self.publishers.buttonVariant.sinkCount, 1, "$buttonVariant should have been called once")
    }

    func test_didSet_variant_equal() throws {
        // GIVEN
        let expectedBackgroundColor = ColorTokenGeneratedMock.blue()
        let expectedForegroundColor = ColorTokenGeneratedMock.red()
        let getColorsUseCaseMock = SnackbarGetColorsUseCasableGeneratedMock()
        getColorsUseCaseMock.executeWithColorsAndIntentAndVariantReturnValue = .init(
            background: expectedBackgroundColor,
            foreground: expectedForegroundColor
        )

        let expectedButtonIntent = ButtonIntent.accent
        let expectedButtonVariant = ButtonVariant.outlined
        let getButtonTypeUseCaseMock = SnackbarGetButtonTypeUseCasableGeneratedMock()
        getButtonTypeUseCaseMock.executeWithIntentAndVariantReturnValue = .init(
            intent: expectedButtonIntent,
            variant: expectedButtonVariant
        )

        let variant = SnackbarVariant.tinted

        let viewModel = SnackbarViewModel(
            theme: self.theme,
            variant: variant,
            intent: .accent,
            getColorsUseCase: getColorsUseCaseMock,
            getButtonTypeUseCase: getButtonTypeUseCaseMock
        )
        self.setupPublishers(viewModel: viewModel)

        self.publishers.reset()
        getColorsUseCaseMock.reset()
        getButtonTypeUseCaseMock.reset()

        // WHEN
        viewModel.variant = variant

        // THEN - UseCases
        XCTAssertFalse(getColorsUseCaseMock.executeWithColorsAndIntentAndVariantCalled, "getColorsUseCaseMock.executeWithColorsAndIntentAndVariant should not have been called")
        XCTAssertFalse(getButtonTypeUseCaseMock.executeWithIntentAndVariantCalled, "getButtonTypeUseCaseMock.executeWithIntentAndVariant should not have been called")

        // THEN - Publishers
        XCTAssertFalse(self.publishers.backgroundColor.sinkCalled, "$backgroundColor should not have been called")
        XCTAssertFalse(self.publishers.foregroundColor.sinkCalled, "$foregroundColor should not have been called")
        XCTAssertFalse(self.publishers.buttonIntent.sinkCalled, "$buttonIntent should not have been called")
        XCTAssertFalse(self.publishers.buttonVariant.sinkCalled, "$buttonVariant should not have been called")
    }
}

final class SnackbarPublishers {
    var cancellables = Set<AnyCancellable>()

    var backgroundColor: PublisherMock<Published<any ColorToken>.Publisher>
    var foregroundColor: PublisherMock<Published<any ColorToken>.Publisher>
    var buttonIntent: PublisherMock<Published<ButtonIntent>.Publisher>
    var buttonVariant: PublisherMock<Published<ButtonVariant>.Publisher>

    init(
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        backgroundColor: PublisherMock<Published<any ColorToken>.Publisher>,
        foregroundColor: PublisherMock<Published<any ColorToken>.Publisher>,
        buttonIntent: PublisherMock<Published<ButtonIntent>.Publisher>,
        buttonVariant: PublisherMock<Published<ButtonVariant>.Publisher>
    ) {
        self.cancellables = cancellables
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.buttonIntent = buttonIntent
        self.buttonVariant = buttonVariant
    }

    func load() {
        self.cancellables = Set<AnyCancellable>()

        self.foregroundColor.loadTesting(on: &self.cancellables)
        self.backgroundColor.loadTesting(on: &self.cancellables)
        self.buttonIntent.loadTesting(on: &self.cancellables)
        self.buttonVariant.loadTesting(on: &self.cancellables)
    }

    func reset() {
        self.foregroundColor.reset()
        self.backgroundColor.reset()
        self.buttonIntent.reset()
        self.buttonVariant.reset()
    }
}
