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
    ///
    /// The snackbar is presented at the bottom of the screen with a slide-up animation
    /// and can be automatically dismissed after a specified delay.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the snackbar.
    ///   - autoDismissDelay: The delay after which the snackbar will be dismissed automatically. Default is ``.fast``.
    ///   - dismissCompletion: The completion to run after dismiss. Default is ``nil``.
    ///   - snackbar: The ``SparkSnackbar`` to show.
    ///
    /// ## Example of usage
    ///
    /// ### Basic Snackbar with Auto-Dismiss
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     let theme: any Theme = MyTheme()
    ///     @State private var showSnackbar = false
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Button("Show Success Message") {
    ///                 self.showSnackbar = true
    ///             }
    ///         }
    ///         .sparkSnackbar(
    ///             isPresented: self.$showSnackbar,
    ///             autoDismissDelay: .fast
    ///         ) {
    ///             SparkSnackbar(
    ///                 "Upload complete",
    ///                 description: "Your file has been uploaded successfully"
    ///             )
    ///             .sparkTheme(self.theme)
    ///             .sparkSnackbarIntent(.success)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### Snackbar with Custom Dismiss Delay
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     let theme: any Theme = MyTheme()
    ///     @State private var showError = false
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Button("Trigger Error") {
    ///                 self.showError = true
    ///             }
    ///         }
    ///         .sparkSnackbar(
    ///             isPresented: self.$showError,
    ///             autoDismissDelay: .slow
    ///         ) {
    ///             SparkSnackbar(
    ///                 Image(systemName: "wifi.slash"),
    ///                 "Connection lost",
    ///                 description: "Unable to reach the server"
    ///             )
    ///             .sparkTheme(self.theme)
    ///             .sparkSnackbarIntent(.error)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### Snackbar with Action Button
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     let theme: any Theme = MyTheme()
    ///     @State private var showDeleteConfirm = false
    ///     @State private var deletedItems: [String] = []
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Button("Delete Item") {
    ///                 self.deleteItem()
    ///                 self.showDeleteConfirm = true
    ///             }
    ///         }
    ///         .sparkSnackbar(
    ///             isPresented: self.$showDeleteConfirm,
    ///             autoDismissDelay: .medium
    ///         ) {
    ///             SparkSnackbar(
    ///                 Image(systemName: "trash"),
    ///                 "Item deleted",
    ///                 description: "The item has been removed"
    ///             ) {
    ///                 SparkButton("Undo") {
    ///                     self.undoDelete()
    ///                 }
    ///                 .sparkButtonVariant(.ghost)
    ///             }
    ///             .sparkTheme(self.theme)
    ///             .sparkSnackbarIntent(.alert)
    ///         }
    ///     }
    ///
    ///     private func deleteItem() {
    ///         // Delete logic
    ///     }
    ///
    ///     private func undoDelete() {
    ///         // Undo logic
    ///     }
    /// }
    /// ```
    ///
    /// ### Snackbar with Dismiss Completion
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     let theme: any Theme = MyTheme()
    ///     @State private var showSnackbar = false
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Button("Save Changes") {
    ///                 self.saveChanges()
    ///                 self.showSnackbar = true
    ///             }
    ///         }
    ///         .sparkSnackbar(
    ///             isPresented: self.$showSnackbar,
    ///             autoDismissDelay: .fast,
    ///             dismissCompletion: {
    ///                 // Perform additional actions after dismiss
    ///                 self.logDismissEvent()
    ///             }
    ///         ) {
    ///             SparkSnackbar(
    ///                 "Changes saved",
    ///                 description: "Your changes have been saved successfully"
    ///             )
    ///             .sparkTheme(self.theme)
    ///             .sparkSnackbarIntent(.success)
    ///         }
    ///     }
    ///
    ///     private func saveChanges() {
    ///         // Save logic
    ///     }
    ///
    ///     private func logDismissEvent() {
    ///         // Log event logic
    ///     }
    /// }
    /// ```
    ///
    /// ### Snackbar without Auto-Dismiss
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     let theme: any Theme = MyTheme()
    ///     @State private var showWarning = false
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Button("Show Warning") {
    ///                 self.showWarning = true
    ///             }
    ///         }
    ///         .sparkSnackbar(
    ///             isPresented: self.$showWarning,
    ///             autoDismissDelay: nil
    ///         ) {
    ///             SparkSnackbar(
    ///                 "Important Notice",
    ///                 description: "This message will stay until you dismiss it"
    ///             ) {
    ///                 SparkButton("Dismiss") {
    ///                     self.showWarning = false
    ///                 }
    ///                 .sparkButtonVariant(.ghost)
    ///             }
    ///             .sparkTheme(self.theme)
    ///             .sparkSnackbarIntent(.alert)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### Multiple Snackbars
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     let theme: any Theme = MyTheme()
    ///     @State private var showSuccess = false
    ///     @State private var showError = false
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Button("Success Action") {
    ///                 self.showSuccess = true
    ///             }
    ///
    ///             Button("Error Action") {
    ///                 self.showError = true
    ///             }
    ///         }
    ///         .sparkSnackbar(
    ///             isPresented: self.$showSuccess,
    ///             autoDismissDelay: .fast
    ///         ) {
    ///             SparkSnackbar(
    ///                 "Success!",
    ///                 description: "Operation completed"
    ///             )
    ///             .sparkTheme(self.theme)
    ///             .sparkSnackbarIntent(.success)
    ///         }
    ///         .sparkSnackbar(
    ///             isPresented: self.$showError,
    ///             autoDismissDelay: .slow
    ///         ) {
    ///             SparkSnackbar(
    ///                 "Error",
    ///                 description: "Something went wrong"
    ///             )
    ///             .sparkTheme(self.theme)
    ///             .sparkSnackbarIntent(.error)
    ///         }
    ///     }
    /// }
    /// ```
    ///
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
