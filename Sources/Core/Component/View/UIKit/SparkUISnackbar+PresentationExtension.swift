//
//  SparkUISnackbar+PresentationExtension.swift
//  SparkComponentSnackbar
//
//  Created by robin.lemaire on 13/05/2026.
//  Copyright © 2026 Leboncoin. All rights reserved.
//

import UIKit
@_spi(SI_SPI) import SparkCommon

extension SparkUISnackbar {

    // MARK: - Public Properties

    /// This method displays the Snackbar in a specified view.
    /// - Parameters:
    ///   - view: The UIView in which to display the Snackbar.
    ///   - animated: Boolean to determine if the presentation should be animated. Default is ``true``.
    ///   - insets: UIEdgeInsets to apply additional spacing around the Snackbar. Default is ``.zero``.
    ///   - useSafeAreaLayoutGuide: Boolean to determine if the Snackbar should respect the safe area. Default is ``false``.
    public func show(
        in view: UIView,
        animated: Bool = true,
        insets: UIEdgeInsets = .zero,
        useSafeAreaLayoutGuide: Bool = false
    ) {
        self.autoDismissWorkItem?.cancel()
        self.removeFromSuperview()
        view.addSubview(self)

        let defaultSpacing = self.theme.layout.spacing.large

        self.setupConstraints(
            in: view,
            insets: insets,
            useSafeAreaLayoutGuide: useSafeAreaLayoutGuide,
            defaultSpacing: defaultSpacing
        )

        self.setNeedsLayout()
        self.layoutIfNeeded()

        self.startPresentation()
    }

    /// This method displays the Snackbar and automatically dismisses it after a specified delay.
    /// - Parameters:
    ///   - view: The UIView in which to display the Snackbar.
    ///   - animated: Boolean to determine if the presentation should be animated. Default is ``true``.
    ///   - insets: UIEdgeInsets to apply additional spacing around the Snackbar. Default is ``.zero``.
    ///   - useSafeAreaLayoutGuide: Boolean to determine if the Snackbar should respect the safe area. Default is ``false``.
    ///   - autoDismissDelay: A SnackbarAutoDismissDelay value determining how long the Snackbar should be displayed before auto-dismissing. Default is ``.fast``.
    ///   - dismissCompletion: An optional closure to be called when the Snackbar is dismissed.
    public func showAndDismiss(
        in view: UIView,
        animated: Bool = true,
        insets: UIEdgeInsets = .zero,
        useSafeAreaLayoutGuide: Bool = false,
        autoDismissDelay: SnackbarAutoDismissDelay = .fast,
        dismissCompletion: ((Bool) -> Void)? = nil
    ) {
        self.show(
            in: view,
            animated: animated,
            insets: insets,
            useSafeAreaLayoutGuide: useSafeAreaLayoutGuide
        )

        self.queueDismiss(
            delay: autoDismissDelay.seconds,
            completion: dismissCompletion
        )
    }

    /// This method dismisses the Snackbar.
    /// - Parameter completion: An optional closure to be called when the dismissal animation is complete.
    public func dismiss(completion: ((Bool) -> Void)?) {
        self.autoDismissWorkItem?.cancel()
        UIView.optionalAnimate(
            withDuration: SnackbarConstants.presentationDuration,
            delay: .zero,
            options: [.curveEaseIn],
            animations: {
                self.transform = self.presentationTransformation
                self.alpha = 0
            },
            completion: { [weak self] isFinished in
                guard let self else { return }
                self.removeFromSuperview()
                completion?(isFinished)
            }
        )
    }

    /// This method cancels any scheduled auto-dismissal of the Snackbar.
    public func cancelAutoDismiss() {
        self.autoDismissWorkItem?.cancel()
    }

    // MARK: - Private Properties

    private func setupConstraints(
        in view: UIView,
        insets: UIEdgeInsets,
        useSafeAreaLayoutGuide: Bool,
        defaultSpacing: CGFloat
    ) {
        self.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = self.leadingAnchor.constraint(
            equalTo: useSafeAreaLayoutGuide ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor,
            constant: defaultSpacing + insets.left
        )
        leadingConstraint.priority = .required - 1
        let trailingConstraint = self.trailingAnchor.constraint(
            equalTo: useSafeAreaLayoutGuide ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor,
            constant: -defaultSpacing + insets.right
        )
        trailingConstraint.priority = .required - 1

        let centerXConstraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        centerXConstraint.priority = .defaultHigh

        let topConstraint = self.topAnchor.constraint(
            greaterThanOrEqualTo: useSafeAreaLayoutGuide ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor,
            constant: defaultSpacing + insets.top
        )

        let bottomConstraint = self.bottomAnchor.constraint(
            equalTo: useSafeAreaLayoutGuide ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor,
            constant: -defaultSpacing + insets.bottom
        )

        self.presentationVerticalConstraint = bottomConstraint

        NSLayoutConstraint.activate([
            leadingConstraint,
            trailingConstraint,
            topConstraint,
            bottomConstraint,
            centerXConstraint
        ])
    }

    private func startPresentation() {
        let yTranslation = -self.presentationVerticalConstraint.constant + self.frame.height
        self.alpha = 0
        self.presentationTransformation = .init(translationX: 0, y: yTranslation)
        self.transform = self.presentationTransformation

        UIView.optionalAnimate(
            withDuration: SnackbarConstants.presentationDuration,
            delay: .zero,
            options: [.curveEaseOut],
            animations: {
                self.alpha = 1
                self.transform = .identity
            },
            completion: nil
        )
    }

    private func queueDismiss(
        delay: Double,
        completion: ((Bool) -> Void)?
    ) {
        self.autoDismissWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.dismiss(completion: completion)
        }
        self.autoDismissWorkItem = workItem
        let duration = UIAccessibility.isReduceMotionEnabled ? .zero : SnackbarConstants.presentationDuration
        let deadline: DispatchTime = .now() + duration + delay
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: workItem)
    }
}
