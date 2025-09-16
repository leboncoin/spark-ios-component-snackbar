//
//  SnackbarGetColorsUseCase.swift
//  SparkComponentSnackbar
//
//  Created by louis.borlee on 03/09/2024.
//  Copyright © 2024 Leboncoin. All rights reserved.
//

import SparkTheming

// sourcery: AutoMockable
protocol SnackbarGetColorsUseCasable {
    func execute(
        colors: any Colors,
        intent: SnackbarIntent,
        variant: SnackbarVariant
    ) -> SnackbarColors
}

final class SnackbarGetColorsUseCase: SnackbarGetColorsUseCasable {
    func execute(
        colors: any Colors,
        intent: SnackbarIntent,
        variant: SnackbarVariant
    ) -> SnackbarColors {
        switch intent {
        case .success:
            return self.getSuccessColors(colors: colors, variant: variant)
        case .alert:
            return self.getAlertColors(colors: colors, variant: variant)
        case .error:
            return self.getErrorColors(colors: colors, variant: variant)
        case .info:
            return self.getInfoColors(colors: colors, variant: variant)
        case .neutral:
            return self.getNeutralColors(colors: colors, variant: variant)
        case .main:
            return self.getMainColors(colors: colors, variant: variant)
        case .basic:
            return self.getBasicColors(colors: colors, variant: variant)
        case .support:
            return self.getSupportColors(colors: colors, variant: variant)
        case .accent:
            return self.getAccentColors(colors: colors, variant: variant)
        case .surfaceInverse:
            return self.getSurfaceInverseColors(colors: colors, variant: variant)
        }
    }

    private func getSuccessColors(colors: any Colors, variant: SnackbarVariant) -> SnackbarColors {
        let backgroundColor: any ColorToken
        let foregroundColor: any ColorToken
        switch variant {
        case .filled:
            backgroundColor = colors.feedback.success
            foregroundColor = colors.feedback.onSuccess
        case .tinted:
            backgroundColor = colors.feedback.successContainer
            foregroundColor = colors.feedback.onSuccessContainer
        }
        return .init(
            background: backgroundColor,
            foreground: foregroundColor
        )
    }

    private func getAlertColors(colors: any Colors, variant: SnackbarVariant) -> SnackbarColors {
        let backgroundColor: any ColorToken
        let foregroundColor: any ColorToken
        switch variant {
        case .filled:
            backgroundColor = colors.feedback.alert
            foregroundColor = colors.feedback.onAlert
        case .tinted:
            backgroundColor = colors.feedback.alertContainer
            foregroundColor = colors.feedback.onAlertContainer
        }
        return .init(
            background: backgroundColor,
            foreground: foregroundColor
        )
    }

    private func getErrorColors(colors: any Colors, variant: SnackbarVariant) -> SnackbarColors {
        let backgroundColor: any ColorToken
        let foregroundColor: any ColorToken
        switch variant {
        case .filled:
            backgroundColor = colors.feedback.error
            foregroundColor = colors.feedback.onError
        case .tinted:
            backgroundColor = colors.feedback.errorContainer
            foregroundColor = colors.feedback.onErrorContainer
        }
        return .init(
            background: backgroundColor,
            foreground: foregroundColor
        )
    }

    private func getInfoColors(colors: any Colors, variant: SnackbarVariant) -> SnackbarColors {
        let backgroundColor: any ColorToken
        let foregroundColor: any ColorToken
        switch variant {
        case .filled:
            backgroundColor = colors.feedback.info
            foregroundColor = colors.feedback.onInfo
        case .tinted:
            backgroundColor = colors.feedback.infoContainer
            foregroundColor = colors.feedback.onInfoContainer
        }
        return .init(
            background: backgroundColor,
            foreground: foregroundColor
        )
    }

    private func getNeutralColors(colors: any Colors, variant: SnackbarVariant) -> SnackbarColors {
        let backgroundColor: any ColorToken
        let foregroundColor: any ColorToken
        switch variant {
        case .filled:
            backgroundColor = colors.feedback.neutral
            foregroundColor = colors.feedback.onNeutral
        case .tinted:
            backgroundColor = colors.feedback.neutralContainer
            foregroundColor = colors.feedback.onNeutralContainer
        }
        return .init(
            background: backgroundColor,
            foreground: foregroundColor
        )
    }

    private func getMainColors(colors: any Colors, variant: SnackbarVariant) -> SnackbarColors {
        let backgroundColor: any ColorToken
        let foregroundColor: any ColorToken
        switch variant {
        case .filled:
            backgroundColor = colors.main.main
            foregroundColor = colors.main.onMain
        case .tinted:
            backgroundColor = colors.main.mainContainer
            foregroundColor = colors.main.onMainContainer
        }
        return .init(
            background: backgroundColor,
            foreground: foregroundColor
        )
    }

    private func getBasicColors(colors: any Colors, variant: SnackbarVariant) -> SnackbarColors {
        let backgroundColor: any ColorToken
        let foregroundColor: any ColorToken
        switch variant {
        case .filled:
            backgroundColor = colors.basic.basic
            foregroundColor = colors.basic.onBasic
        case .tinted:
            backgroundColor = colors.basic.basicContainer
            foregroundColor = colors.basic.onBasicContainer
        }
        return .init(
            background: backgroundColor,
            foreground: foregroundColor
        )
    }

    private func getSupportColors(colors: any Colors, variant: SnackbarVariant) -> SnackbarColors {
        let backgroundColor: any ColorToken
        let foregroundColor: any ColorToken
        switch variant {
        case .filled:
            backgroundColor = colors.support.support
            foregroundColor = colors.support.onSupport
        case .tinted:
            backgroundColor = colors.support.supportContainer
            foregroundColor = colors.support.onSupportContainer
        }
        return .init(
            background: backgroundColor,
            foreground: foregroundColor
        )
    }

    private func getAccentColors(colors: any Colors, variant: SnackbarVariant) -> SnackbarColors {
        let backgroundColor: any ColorToken
        let foregroundColor: any ColorToken
        switch variant {
        case .filled:
            backgroundColor = colors.accent.accent
            foregroundColor = colors.accent.onAccent
        case .tinted:
            backgroundColor = colors.accent.accentContainer
            foregroundColor = colors.accent.onAccentContainer
        }
        return .init(
            background: backgroundColor,
            foreground: foregroundColor
        )
    }

    private func getSurfaceInverseColors(colors: any Colors, variant _: SnackbarVariant) -> SnackbarColors {
        // Note: variant has no impact on here
        return .init(
            background: colors.base.surfaceInverse,
            foreground: colors.base.onSurfaceInverse
        )
    }
}
