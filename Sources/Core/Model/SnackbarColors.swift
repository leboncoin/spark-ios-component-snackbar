//
//  SnackbarColors.swift
//  SparkSnackbar
//
//  Created by louis.borlee on 03/09/2024.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import SparkTheming

/// Snackbar colors
public struct SnackbarColors {
    /// Snackbar background color
    let background: any ColorToken
    /// Snackbar foreground color
    let foreground: any ColorToken

    /// Snackbar init
    /// - Parameters:
    ///   - background: Snackbar background color
    ///   - foreground: Snackbar foreground color
    public init(
        background: any ColorToken,
        foreground: any ColorToken
    ) {
        self.background = background
        self.foreground = foreground
    }
}
