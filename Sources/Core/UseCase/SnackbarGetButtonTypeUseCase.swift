//
//  SnackbarGetButtonTypeUseCase.swift
//  SparkSnackbar
//
//  Created by louis.borlee on 03/09/2024.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import SparkButton

// sourcery: AutoMockable
protocol SnackbarGetButtonTypeUseCasable {
    func execute(
        intent: SnackbarIntent,
        variant: SnackbarVariant
    ) -> SnackbarButtonType
}

final class SnackbarGetButtonTypeUseCase: SnackbarGetButtonTypeUseCasable {
    func execute(
        intent: SnackbarIntent,
        variant: SnackbarVariant
    ) -> SnackbarButtonType {
        switch intent {
        case .success:
            return self.getSuccessButtonType(variant: variant)
        case .alert:
            return self.getAlertButtonType(variant: variant)
        case .error:
            return self.getErrorButtonType(variant: variant)
        case .info:
            return self.getInfoButtonType(variant: variant)
        case .neutral:
            return self.getNeutralButtonType(variant: variant)
        case .main:
            return self.getMainButtonType(variant: variant)
        case .basic:
            return self.getBasicButtonType(variant: variant)
        case .support:
            return self.getSupportButtonType(variant: variant)
        case .accent:
            return self.getAccentButtonType(variant: variant)
        case .surfaceInverse:
            return self.getSurfaceInverseButtonType(variant: variant)
        }
    }

    private func getSuccessButtonType(variant: SnackbarVariant) -> SnackbarButtonType {
        let buttonIntent = ButtonIntent.success
        let buttonVariant: ButtonVariant = switch variant {
        case .filled: .filled
        case .tinted: .tinted
        }
        return .init(
            intent: buttonIntent,
            variant: buttonVariant
        )
    }

    private func getAlertButtonType(variant: SnackbarVariant) -> SnackbarButtonType {
        let buttonIntent = ButtonIntent.alert
        let buttonVariant: ButtonVariant = switch variant {
        case .filled: .filled
        case .tinted: .tinted
        }
        return .init(
            intent: buttonIntent,
            variant: buttonVariant
        )
    }

    private func getErrorButtonType(variant: SnackbarVariant) -> SnackbarButtonType {
        let buttonIntent = ButtonIntent.danger
        let buttonVariant: ButtonVariant = switch variant {
        case .filled: .filled
        case .tinted: .tinted
        }
        return .init(
            intent: buttonIntent,
            variant: buttonVariant
        )
    }

    private func getInfoButtonType(variant: SnackbarVariant) -> SnackbarButtonType {
        let buttonIntent = ButtonIntent.info
        let buttonVariant: ButtonVariant = switch variant {
        case .filled: .filled
        case .tinted: .tinted
        }
        return .init(
            intent: buttonIntent,
            variant: buttonVariant
        )
    }

    private func getNeutralButtonType(variant: SnackbarVariant) -> SnackbarButtonType {
        let buttonIntent = ButtonIntent.neutral
        let buttonVariant: ButtonVariant = switch variant {
        case .filled: .filled
        case .tinted: .tinted
        }
        return .init(
            intent: buttonIntent,
            variant: buttonVariant
        )
    }

    private func getMainButtonType(variant: SnackbarVariant) -> SnackbarButtonType {
        let buttonIntent = ButtonIntent.main
        let buttonVariant: ButtonVariant = switch variant {
        case .filled: .filled
        case .tinted: .tinted
        }
        return .init(
            intent: buttonIntent,
            variant: buttonVariant
        )
    }

    private func getBasicButtonType(variant: SnackbarVariant) -> SnackbarButtonType {
        let buttonIntent = ButtonIntent.basic
        let buttonVariant: ButtonVariant = switch variant {
        case .filled: .filled
        case .tinted: .tinted
        }
        return .init(
            intent: buttonIntent,
            variant: buttonVariant
        )
    }

    private func getSupportButtonType(variant: SnackbarVariant) -> SnackbarButtonType {
        let buttonIntent = ButtonIntent.support
        let buttonVariant: ButtonVariant = switch variant {
        case .filled: .filled
        case .tinted: .tinted
        }
        return .init(
            intent: buttonIntent,
            variant: buttonVariant
        )
    }

    private func getAccentButtonType(variant: SnackbarVariant) -> SnackbarButtonType {
        let buttonIntent = ButtonIntent.accent
        let buttonVariant: ButtonVariant = switch variant {
        case .filled: .filled
        case .tinted: .tinted
        }
        return .init(
            intent: buttonIntent,
            variant: buttonVariant
        )
    }

    private func getSurfaceInverseButtonType(variant _: SnackbarVariant) -> SnackbarButtonType {
        // Note: variant has no impact on here
        return .init(
            intent: ButtonIntent.surface,
            variant: ButtonVariant.ghost
        )
    }
}
