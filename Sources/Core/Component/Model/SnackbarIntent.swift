//
//  SnackbarIntent.swift
//  SparkComponentSnackbar
//
//  Created by louis.borlee on 03/09/2024.
//  Copyright © 2024 Leboncoin. All rights reserved.
//

import SparkTheming

/// The intent of the snackbar.
public enum SnackbarIntent: CaseIterable {
    case success
    case alert
    case error
    case info
    case neutral
    case main
    case basic
    case support
    case accent
    case surfaceInverse

    internal var getColorsUseCase: SnackbarGetColorsUseCasable {
        return SnackbarGetColorsUseCase()
    }

    internal func getColors(
        theme: any Theme,
        variant: SnackbarVariant,
        getColorsUseCase: SnackbarGetColorsUseCasable
    ) -> SnackbarColors {
        return getColorsUseCase.execute(
            colors: theme.colors,
            intent: self,
            variant: variant
        )
    }

    /// Get the colors to apply on snackbars from an intent
    /// - Parameters:
    ///   - theme: Spark theme
    ///   - variant: The variant of the snackbar
    /// - Returns: SnackbarColors
    public func getColors(
        theme: any Theme,
        variant: SnackbarVariant
    ) -> SnackbarColors {
        return self.getColors(
            theme: theme,
            variant: variant,
            getColorsUseCase: self.getColorsUseCase
        )
    }
}
