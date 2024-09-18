//
//  SnackbarView.swift
//  SparkSnackbar
//
//  Created by louis.borlee on 13/09/2024.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import SwiftUI
import Combine
import SparkTheming
import SparkButton
@_spi(SI_SPI) import SparkCommon

public struct SnackbarView<SnackbarButton> : View where SnackbarButton : View  {

    public struct ButtonConfiguration {
        public let intent: ButtonIntent
        public let variant: ButtonVariant
        public let size: ButtonSize
        public let shape: ButtonShape
    }

    private let image: Image?
    private let text: () -> Text

    private var type: SnackbarType
    private var variant: SnackbarVariant

    @ViewBuilder private var button: () -> SnackbarButton?

    @ObservedObject private var viewModel: SnackbarViewModel

    @ScaledMetric var scaleFactor = 1.0

    private init(
        theme: any Theme,
        intent: SnackbarIntent,
        type: SnackbarType,
        variant: SnackbarVariant,
        image: Image?,
        text: @escaping () -> Text,
        button: ((ButtonView) -> SnackbarButton)? = nil,
        action: (() -> Void)? = nil,
        buttonConfiguration: ((SnackbarView.ButtonConfiguration) -> SnackbarButton)? = nil
    ) {
        self.type = type
        self.variant = variant

        let viewModel = SnackbarViewModel(
            theme: theme,
            variant: variant,
            intent: intent
        )
        self.viewModel = viewModel

        self.image = image
        self.text = text

        if let buttonConfiguration {
            self.button = {
                buttonConfiguration(
                    .init(
                        intent: viewModel.buttonIntent,
                        variant: viewModel.buttonVariant,
                        size: SnackbarConstants.buttonSize,
                        shape: SnackbarConstants.buttonShape
                    )
                )
            }
        } else if let button, let action {
            self.button = {
               button(
                   ButtonView(
                       theme: viewModel.theme,
                       intent: viewModel.buttonIntent,
                       variant: viewModel.buttonVariant,
                       size: SnackbarConstants.buttonSize,
                       shape: SnackbarConstants.buttonShape,
                       alignment: .leadingImage,
                       action: action ?? {}
                   )
               )
           }
        } else {
            self.button = { nil }
        }
    }

    public init(
        theme: any Theme,
        intent: SnackbarIntent,
        image: Image? = nil,
        text: @escaping () -> Text
    ) where SnackbarButton == EmptyView {
        self.init(
            theme: theme,
            intent: intent,
            type: .horizontal,
            variant: .filled,
            image: image,
            text: text
        )
    }

    public init(
        theme: any Theme,
        intent: SnackbarIntent,
        image: Image? = nil,
        text: @escaping () -> Text,
        button: @escaping (SnackbarView.ButtonConfiguration) -> SnackbarButton
    ) {
        self.init(
            theme: theme,
            intent: intent,
            type: .horizontal,
            variant: .filled,
            image: image,
            text: text,
            buttonConfiguration: button
        )
    }

    public init(
        theme: any Theme,
        intent: SnackbarIntent,
        image: Image? = nil,
        text: @escaping () -> Text,
        button: @escaping (ButtonView) -> SnackbarButton,
        action: @escaping () -> Void
    ) {
        self.init(
            theme: theme,
            intent: intent,
            type: .horizontal,
            variant: .filled,
            image: image,
            text: text,
            button: button,
            action: action
        )
    }

    public var body: some View {
        ZStack {
            self.viewModel.backgroundColor.color
            VStack {
                self.content()
            }
            .padding(.leading, self.viewModel.theme.layout.spacing.large)
            .padding(.trailing, self.viewModel.theme.layout.spacing.medium)
        }
        .clipShape(.rect(cornerRadius: self.viewModel.theme.border.radius.medium * self.scaleFactor))
        .shadow(self.viewModel.theme.elevation.dropShadow)
        .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private func content() -> some View {
        switch self.type {
        case .horizontal:
            self.horizontalContent()
        case .vertical:
            self.verticalContent()
        }
    }

    @ViewBuilder
    private func horizontalContent() -> some View {
        HStack(alignment: .center, spacing: self.viewModel.theme.layout.spacing.medium) {
            if let image {
                self.styledImage(image)
            }
            if let button = self.button() {
                self.styledText()
                button
                    .fixedSize()
                    .padding([.top, .bottom], self.viewModel.theme.layout.spacing.medium)
            } else {
                self.styledText()
                    .padding(.trailing, self.viewModel.theme.layout.spacing.large - self.viewModel.theme.layout.spacing.medium)
            }
        }
    }

    @ViewBuilder
    private func verticalContent() -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: self.viewModel.theme.layout.spacing.medium) {
                if let image {
                    self.styledImage(image)
                }
                self.styledText()
                    .padding(.trailing, (self.viewModel.theme.layout.spacing.large - self.viewModel.theme.layout.spacing.medium))
            }
            if let button = self.button() {
                HStack(spacing: 0) {
                    Spacer()
                    button
                        .fixedSize()
                        .padding(.bottom, self.viewModel.theme.layout.spacing.medium)
                }
                .padding(.top, -(self.viewModel.theme.layout.spacing.large - self.viewModel.theme.layout.spacing.medium))
            }
        }
    }

    @ViewBuilder
    private func styledImage(_ image: Image) -> some View {
        let iconSize = SnackbarConstants.iconSize * self.scaleFactor
        image
            .resizable()
            .frame(width: iconSize, height: iconSize)
            .foregroundColor(self.viewModel.foregroundColor.color)
    }

    @ViewBuilder
    private func styledText() -> some View {
        self.text()
            .font(self.viewModel.textFont.font)
            .foregroundStyle(self.viewModel.foregroundColor.color)
            .padding([.top, .bottom], self.viewModel.theme.layout.spacing.large)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    public func theme(_ theme: any Theme) -> Self {
        self.viewModel.theme = theme
        return self
    }

    public func intent(_ intent: SnackbarIntent) -> Self {
        guard intent != self.viewModel.intent else { return self }
        self.viewModel.intent = intent
        return self
    }

    public func variant(_ variant: SnackbarVariant) -> Self {
        guard variant != self.viewModel.variant else { return self }
        self.viewModel.variant = variant
        return self
    }

    public func type(_ type: SnackbarType) -> Self {
        guard type != self.type else { return self }
        var copy = self
        copy.type = type
        return copy
    }
}
