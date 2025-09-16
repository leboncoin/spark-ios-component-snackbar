//
//  SnackbarViewModel.swift
//  SparkComponentSnackbar
//
//  Created by louis.borlee on 04/09/2024.
//  Copyright © 2024 Leboncoin. All rights reserved.
//

import Foundation
import Combine
import SparkTheming
import SparkComponentButton

final class SnackbarViewModel: ObservableObject {

    var theme: any Theme {
        didSet {
            self.refresh()
            self.textFont = self.theme.typography.body2
            self.cornerRadius = self.theme.border.radius.medium
        }
    }
    var variant: SnackbarVariant {
        didSet {
            guard self.variant != oldValue else { return }
            self.refresh()
        }
    }
    var intent: SnackbarIntent {
        didSet {
            guard self.intent != oldValue else { return }
            self.refresh()
        }
    }

    @Published private(set) var backgroundColor: any ColorToken
    @Published private(set) var foregroundColor: any ColorToken

    @Published private(set) var textFont: any TypographyFontToken

    @Published private(set) var buttonIntent: ButtonIntent
    @Published private(set) var buttonVariant: ButtonVariant

    @Published private(set) var cornerRadius: CGFloat

    private let getColorsUseCase: any SnackbarGetColorsUseCasable
    private let getButtonTypeUseCase: any SnackbarGetButtonTypeUseCasable

    init(
        theme: any Theme,
        variant: SnackbarVariant,
        intent: SnackbarIntent,
        getColorsUseCase: any SnackbarGetColorsUseCasable = SnackbarGetColorsUseCase(),
        getButtonTypeUseCase: any SnackbarGetButtonTypeUseCasable = SnackbarGetButtonTypeUseCase()
    ) {
        self.theme = theme

        self.variant = variant
        self.intent = intent

        self.getColorsUseCase = getColorsUseCase
        self.getButtonTypeUseCase = getButtonTypeUseCase

        self.textFont = theme.typography.body2

        let colors = getColorsUseCase.execute(
            colors: theme.colors,
            intent: intent,
            variant: variant
        )
        self.backgroundColor = colors.background
        self.foregroundColor = colors.foreground

        let buttonType = getButtonTypeUseCase.execute(
            intent: intent,
            variant: variant
        )
        self.buttonIntent = buttonType.intent
        self.buttonVariant = buttonType.variant

        self.cornerRadius = theme.border.radius.medium
    }

    private func refresh() {
        let colors = self.getColorsUseCase.execute(
            colors: self.theme.colors,
            intent: self.intent,
            variant: self.variant
        )
        self.backgroundColor = colors.background
        self.foregroundColor = colors.foreground

        let buttonType = self.getButtonTypeUseCase.execute(
            intent: self.intent,
            variant: self.variant
        )
        self.buttonIntent = buttonType.intent
        self.buttonVariant = buttonType.variant
    }
}
