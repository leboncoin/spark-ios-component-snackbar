//
//  SnackbarPresentationViewModifier.swift
//  SparkComponentSnackbar
//
//  Created by robin.lemaire on 13/05/2026.
//  Copyright © 2026 Leboncoin. All rights reserved.
//

import SwiftUI

private struct SnackbarPresentationViewModifier<Snackbar: View>: ViewModifier {

    // MARK: - Properties

    @Binding private var isPresented: Bool
    @State private var currentTask: Task<Void, Never>?

    private let snackbar: (() -> Snackbar)?
    private let autoDismissDelay: SnackbarAutoDismissDelay?
    private let dismissCompletion: (() -> Void)?

    // MARK: - Initialization

    init(
        isPresented: Binding<Bool>,
        autoDismissDelay: SnackbarAutoDismissDelay?,
        dismissCompletion: (() -> Void)?,
        snackbar: @escaping () -> Snackbar
    ) {
        self._isPresented = isPresented
        self.autoDismissDelay = autoDismissDelay
        self.dismissCompletion = dismissCompletion
        self.snackbar = snackbar
    }

    // MARK: - View

    func body(content: Content) -> some View {
        ZStack {
            content

            VStack {
                if self.isPresented {
                    Spacer()
                }

                self.snackbar?()
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .transaction { transaction in
                        transaction.disablesAnimations = true // Removes animation issues
                    }
                    .onAppear {
                        if let autoDismissDelay {
                            self.currentTask = Task(priority: .background, operation: {
                                do {
                                    try await Task.sleep(nanoseconds: UInt64(autoDismissDelay.seconds * powl(10, 9)))
                                    self.isPresented = false
                                } catch {}
                            })
                        }
                    }
                    .onDisappear {
                        self.dismissCompletion?()
                        self.currentTask?.cancel()
                        self.currentTask = nil
                    }
            }
            .optionalAnimation(
                self.isPresented ? .easeOut(duration: SnackbarConstants.presentationDuration) : .easeIn(duration: SnackbarConstants.presentationDuration),
                value: self.isPresented
            )
        }
    }
}

// MARK: - View Extension

public extension View {

    /// Presents a Spark ``SparkSnackbar`` when a given condition is true.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the snackbar.
    ///   - autoDismissDelay: The delay after which the snackbar will be dismissed automatically. Default is ``.fast``.
    ///   - dismissCompletion: The completion to run after dismiss. Default is ``nil``.
    ///   - snackbar: The ``SparkSnackbar`` to show.
    func sparkSnackbar<Snackbar: View>(
        isPresented: Binding<Bool>,
        autoDismissDelay: SnackbarAutoDismissDelay? = .default,
        dismissCompletion: (() -> Void)? = nil,
        snackbar: @escaping () -> Snackbar
    ) -> some View {
        self.modifier(
            SnackbarPresentationViewModifier(
                isPresented: isPresented,
                autoDismissDelay: autoDismissDelay,
                dismissCompletion: dismissCompletion,
                snackbar: snackbar
            )
        )
    }
}
