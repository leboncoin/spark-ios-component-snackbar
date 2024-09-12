//
//  SnackbarUIView.swift
//  SparkSnackbar
//
//  Created by louis.borlee on 04/09/2024.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import UIKit
import Combine
import SparkTheming
import SparkButton
@_spi(SI_SPI) import SparkCommon

/// The UIKit version of the snacbkar.
public final class SnackbarUIView: UIView {

    /// The spark theme of the snackbar.
    public var theme: Theme {
        get {
            return self.viewModel.theme
        }
        set {
            self.viewModel.theme = newValue
        }
    }

    /// The intent of the snackbar.
    public var intent: SnackbarIntent {
        get {
            return self.viewModel.intent
        }
        set {
            self.viewModel.intent = newValue
        }
    }

    /// The type of the snackbar.
    public var type: SnackbarType = .horizontal {
        didSet {
            guard self.type != oldValue else { return }
            self.setNeedsLayout()
        }
    }

    /// The variant of the snackbar.
    public var variant: SnackbarVariant {
        get {
            return self.viewModel.variant
        } set {
            self.viewModel.variant = newValue
        }
    }

    public private(set) var imageView: UIImageView?
    public let label = UILabel()
    public private(set) var button: ButtonUIView?

    private var buttonContainer: UIView?
    private var imageContainer: UIView?
    private let labelContainer = UIView()

    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()

    private let viewModel: SnackbarViewModel
    private var cancellables = Set<AnyCancellable>()

    @ScaledUIMetric private var scaleFactor: CGFloat = 1.0

    private var imageViewWidthConstraint = NSLayoutConstraint()
    private var labelTrailingAnchorConstraint = NSLayoutConstraint()

    /// Initialize a new snackbar view.
    /// - Parameters:
    ///   - theme: The spark theme of the snackbar.
    ///   - intent: The intent of the snackbar.
    public init(
        theme: any Theme,
        intent: SnackbarIntent
    ) {
        self.viewModel = .init(
            theme: theme,
            variant: .filled,
            intent: intent
        )

        super.init(frame: .zero)
        self.setupView()
        self.setupSubscriptions()
        self.setupLayout()
        self.setupAccessibility()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View
    private func setupView() {
        self.setupLabel()
        self.setupHorizontalStackView()
        self.setupVerticalStackView()

        self.layer.cornerRadius = self.theme.border.radius.medium * self.scaleFactor

        self.addSubview(self.verticalStackView)

        self.applyShadow(self.theme.elevation.dropShadow)
    }

    private func setupVerticalStackView() {
        self.verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.verticalStackView.axis = .vertical
        self.verticalStackView.distribution = .fillProportionally
        self.verticalStackView.addArrangedSubview(self.horizontalStackView)
    }

    private func setupHorizontalStackView() {
        self.horizontalStackView.spacing = self.theme.layout.spacing.medium
        self.horizontalStackView.alignment = .center
        self.horizontalStackView.axis = .horizontal
        self.horizontalStackView.addArrangedSubview(self.labelContainer)
    }

    private func setupLabel() {
        self.label.textColor = self.viewModel.foregroundColor.uiColor
        self.label.font = self.viewModel.textFont.uiFont
        self.label.adjustsFontForContentSizeCategory = true
        self.label.setContentCompressionResistancePriority(.required, for: .vertical)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.labelContainer.addSubview(self.label)
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.theme.layout.spacing.large),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.theme.layout.spacing.medium),
            self.verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.theme.layout.spacing.medium),
            self.verticalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])

        self.labelTrailingAnchorConstraint = self.label.trailingAnchor.constraint(equalTo: self.labelContainer.trailingAnchor)
        self.labelTrailingAnchorConstraint.priority = .required - 1

        let labelTopAnchorConstraint = self.label.topAnchor.constraint(
            greaterThanOrEqualTo: self.topAnchor,
            constant: self.theme.layout.spacing.large
        )
        labelTopAnchorConstraint.priority = .required - 1

        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.labelContainer.leadingAnchor),
            self.label.topAnchor.constraint(greaterThanOrEqualTo: self.labelContainer.topAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.labelContainer.centerYAnchor),
            labelTopAnchorConstraint,
            self.labelTrailingAnchorConstraint
        ])
    }

    // MARK: - Setup Subscriptions
    private func setupSubscriptions() {
        self.viewModel.$backgroundColor.removeDuplicates(by: { lhs, rhs in
            lhs.equals(rhs)
        })
        .subscribe(in: &self.cancellables) { [weak self] backgroundColor in
            guard let self else { return }
            self.backgroundColor = backgroundColor.uiColor
        }

        self.viewModel.$foregroundColor.removeDuplicates(by: { lhs, rhs in
            lhs.equals(rhs)
        })
        .subscribe(in: &self.cancellables) { [weak self] foregroundColor in
            guard let self else { return }
            self.label.textColor = foregroundColor.uiColor
            self.imageView?.tintColor = foregroundColor.uiColor
        }

        self.viewModel.$buttonIntent.removeDuplicates().subscribe(in: &self.cancellables) { [weak self] buttonIntent in
            guard let self else { return }
            self.button?.intent = buttonIntent
        }
        self.viewModel.$buttonVariant.removeDuplicates().subscribe(in: &self.cancellables) { [weak self] buttonVariant in
            guard let self else { return }
            self.button?.variant = buttonVariant
        }
    }

    // MARK: - Setup accessibility
    private func setupAccessibility() {
        self.accessibilityIdentifier = SnackbarAccessibilityIdentifier.view
        self.accessibilityContainerType = .semanticGroup
        self.setupLabelAccessibility()
    }

    private func setupLabelAccessibility() {
        self.label.accessibilityIdentifier = SnackbarAccessibilityIdentifier.label
    }

    private func setupButtonAccessibility(_ button: ButtonUIView) {
        button.accessibilityIdentifier = SnackbarAccessibilityIdentifier.button
    }

    // MARK: - Reload
    public override func layoutSubviews() {
        if self.shouldReloadStackViews() {
            self.horizontalStackView.removeArrangedSubviews()
            self.getHorizontalContent().forEach { self.horizontalStackView.addArrangedSubview($0) }
            self.verticalStackView.removeArrangedSubviews()
            self.getVerticalContent().forEach { self.verticalStackView.addArrangedSubview($0) }

            self.updateLabelTrailingConstraint()
        }
        super.layoutSubviews()
    }

    private func shouldReloadStackViews() -> Bool {
        return self.horizontalStackView.arrangedSubviews != self.getHorizontalContent() ||
        self.verticalStackView.arrangedSubviews != self.getVerticalContent()
    }

    private func getHorizontalContent() -> [UIView] {
        return [
            self.imageContainer,
            self.labelContainer,
            self.type == .horizontal ? self.buttonContainer : nil,
        ].compactMap { $0 }
    }

    private func getVerticalContent() -> [UIView] {
        return [
            self.horizontalStackView,
            self.type == .vertical ? self.buttonContainer : nil
        ].compactMap { $0 }
    }

    /// Label trailing space management.
    /// Spacing will be `0` if `button` exists and is in the `horizontalStackView`.
    /// Spacing will be `(spacing.large - spacing.medium)` otherwise to be further away from the borders.
    private func updateLabelTrailingConstraint() {
        var trailingConstant = -(self.theme.layout.spacing.large - self.theme.layout.spacing.medium)
        if let button, button.isDescendant(of: self.horizontalStackView) {
            trailingConstant = 0
        }
        self.labelTrailingAnchorConstraint.constant = trailingConstant
    }

    // MARK: - Set Image
    public func setImage(_ image: UIImage?) {
        if let image {
            let imageView = UIImageView(image: image)
            self.setupImageView(imageView)
        } else {
            self.imageViewWidthConstraint.isActive = false
            self.imageViewWidthConstraint = NSLayoutConstraint()
            self.imageContainer = nil
            self.imageView = nil
        }
    }

    private func setupImageView(_ imageView: UIImageView) {
        imageView.tintColor = self.viewModel.foregroundColor.uiColor
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.required, for: .horizontal)

        let imageContainer = UIView()
        imageContainer.addSubview(imageView)

        self.imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: SnackbarConstants.iconSize * self.scaleFactor)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            imageViewWidthConstraint,
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])

        self.imageContainer = imageContainer
        self.imageView = imageView
    }

    // MARK: - Set Button
    @discardableResult
    /// Adds a ButtonUIView to the snackbar (if it doesn't already exist).
    /// This button can be accessed using the snackbar's public property `.button`.
    /// - Returns: the snackbar's button.
    public func addButton() -> ButtonUIView {
        if let button {
            return button
        }
        let button = ButtonUIView(
            theme: self.theme,
            intent: self.viewModel.buttonIntent,
            variant: self.viewModel.buttonVariant,
            size: SnackbarConstants.buttonSize,
            shape: SnackbarConstants.buttonShape,
            alignment: .leadingImage
        )
        self.setupButtonAccessibility(button)
        let buttonContainer = UIView()
        buttonContainer.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
            button.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor),
            button.leadingAnchor.constraint(greaterThanOrEqualTo: buttonContainer.leadingAnchor)
        ])

        self.buttonContainer = buttonContainer
        self.button = button
        return button
    }

    /// Removes the snackbar's button.
    public func removeButton() {
        self.buttonContainer = nil
        self.button = nil
    }

    // MARK: - Trait Collection
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.hasDifferentSizeCategory(comparedTo: previousTraitCollection) {
            self.imageViewWidthConstraint.constant = SnackbarConstants.iconSize * self.scaleFactor
            self.layer.cornerRadius = self.theme.border.radius.medium * self.scaleFactor
        }
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.applyShadow(self.theme.elevation.dropShadow)
        }
    }
}
