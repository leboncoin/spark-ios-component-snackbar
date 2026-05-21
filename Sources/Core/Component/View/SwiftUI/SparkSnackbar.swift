//
//  SparkSnackbar.swift
//  SparkComponentSnackbar
//
//  Created by robin.lemaire on 13/05/2026.
//  Copyright © 2026 Leboncoin. All rights reserved.
//

import SwiftUI
@_spi(SI_SPI) import SparkTheming
@_spi(SI_SPI) import SparkCommon
import SparkComponentButton

/// Spark Snackbars provide brief notifications at the bottom of the screen.
///
/// Snackbars inform users of a process that an app has performed or will perform.
/// They appear temporarily, towards the bottom of the screen. They shouldn't interrupt
/// the user experience, and they don't require user input to disappear.
///
/// ## Example of usage
///
/// ### Basic Snackbar with Title and Description
///
/// ```swift
/// struct MyView: View {
///     let theme: SparkTheming.Theme = MyTheme()
///     @State private var showSnackbar = false
///
///     var body: some View {
///         VStack {
///             Button("Show Snackbar") {
///                 self.showSnackbar = true
///             }
///         }
///         .snackbar(
///             isPresented: self.$showSnackbar,
///             autoDismissDelay: 3
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
/// ### Snackbar with Icon
///
/// ```swift
/// struct MyView: View {
///     let theme: SparkTheming.Theme = MyTheme()
///     @State private var showSnackbar = false
///
///     var body: some View {
///         VStack {
///             Button("Show Error") {
///                 self.showSnackbar = true
///             }
///         }
///         .snackbar(
///             isPresented: self.$showSnackbar,
///             autoDismissDelay: 5
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
/// struct MyView: View {
///     let theme: SparkTheming.Theme = MyTheme()
///     @State private var showSnackbar = false
///
///     var body: some View {
///         VStack {
///             Button("Delete Item") {
///                 self.deleteItem()
///                 self.showSnackbar = true
///             }
///         }
///         .snackbar(
///             isPresented: self.$showSnackbar,
///             autoDismissDelay: 5
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
/// ### Custom Content Snackbar
///
/// ```swift
/// struct MyView: View {
///     let theme: SparkTheming.Theme = MyTheme()
///     @State private var showSnackbar = false
///
///     var body: some View {
///         VStack {
///             Button("Show Custom") {
///                 self.showSnackbar = true
///             }
///         }
///         .snackbar(
///             isPresented: self.$showSnackbar,
///             autoDismissDelay: 4
///         ) {
///             SparkSnackbar(
///                 Image(systemName: "bell.fill"),
///                 titleLabel: {
///                     Text("New Message")
///                         .bold()
///                 },
///                 descriptionLabel: {
///                     VStack(alignment: .leading, spacing: 4) {
///                         Text("John Doe")
///                         Text("Hello, how are you?")
///                             .font(.caption)
///                     }
///                 }
///             )
///             .sparkTheme(self.theme)
///             .sparkSnackbarIntent(.info)
///         }
///     }
/// }
/// ```
///
/// ### Snackbar with Different Alignment
///
/// ```swift
/// struct MyView: View {
///     let theme: SparkTheming.Theme = MyTheme()
///     @State private var showSnackbar = false
///
///     var body: some View {
///         VStack {
///             Button("Show Vertical Snackbar") {
///                 self.showSnackbar = true
///             }
///         }
///         .snackbar(
///             isPresented: self.$showSnackbar,
///             autoDismissDelay: 3
///         ) {
///             SparkSnackbar(
///                 "Settings saved",
///                 description: "Your preferences have been updated"
///             )
///             .sparkTheme(self.theme)
///             .sparkSnackbarIntent(.success)
///             .sparkSnackbarAlignment(.vertical)
///         }
///     }
/// }
/// ```
///
/// ## EnvironmentValues
///
/// This component uses some EnvironmentValues:
/// - **theme**: ``sparkTheme(_:)`` (View extension)
/// - **intent**: ``sparkSnackbarIntent(_:)`` (View extension)
/// - **alignment**: ``sparkSnackbarAlignment(_:)`` (View extension)
///
/// > If these values are not set, default values will be applied.
///
/// > **YOU MUST PROVIDE ``sparkTheme(_:)``**
///
/// ## Accessibility
///
/// SparkSnackbar automatically supports:
/// - VoiceOver with proper accessibility traits
/// - Dynamic Type for text scaling
/// - Semantic grouping of title and description
///
/// The icon is automatically hidden from accessibility as it's decorative.
///
/// ## Rendering
///
/// ![Button rendering.](snackbar_full.png)
///
public struct SparkSnackbar<TitleLabel, DescriptionLabel, ActionButton>: View where TitleLabel: View, DescriptionLabel: View, ActionButton: View {

    // MARK: - Properties

    private let icon: Image?
    private var titleLabel: () -> TitleLabel
    private var descriptionLabel: () -> DescriptionLabel
    private var button: () -> ActionButton

    @Environment(\.theme) private var theme
    @Environment(\.snackbarAlignment) private var alignment
    @Environment(\.snackbarIntent) private var intent

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @StateObject private var viewModel = SnackbarViewModel()

    // MARK: - Initialization

    /// Creates a snackbar with custom title, description, and button views.
    ///
    /// Use this initializer when you need complete control over all content areas.
    ///
    /// - Parameters:
    ///   - icon: An optional icon to display. Optional. Default is *nil*.
    ///   - titleLabel: A view builder that creates the title label.
    ///   - descriptionLabel: A view builder that creates the description label.
    ///   - button: A view builder that creates the action button.
    ///
    /// ## Example of usage
    ///
    /// ```swift
    /// SparkSnackbar(
    ///     Image(systemName: "envelope.fill"),
    ///     titleLabel: {
    ///         HStack {
    ///             Text("Email sent")
    ///             Image(systemName: "checkmark.circle.fill")
    ///         }
    ///     },
    ///     descriptionLabel: {
    ///         VStack(alignment: .leading) {
    ///             Text("To: john@example.com")
    ///             Text("Subject: Meeting reminder")
    ///         }
    ///     },
    ///     button: {
    ///         SparkButton("View") {
    ///             // View action
    ///         }
    ///         .sparkButtonVariant(.ghost)
    ///     }
    /// )
    /// .sparkTheme(self.theme)
    /// .sparkSnackbarIntent(.success)
    /// ```
    ///
    /// ## Rendering
    ///
    /// ![Button rendering.](snackbar_full.png)
    ///
    public init(
        _ icon: Image? = nil,
        titleLabel: @escaping () -> TitleLabel,
        descriptionLabel: @escaping () -> DescriptionLabel,
        button: @escaping () -> ActionButton
    ) {
        self.icon = icon
        self.titleLabel = titleLabel
        self.descriptionLabel = descriptionLabel
        self.button = button
    }

    // MARK: - View

    public var body: some View {
        self.contentStack {
            SparkHStack(spacing: self.viewModel.layout.horizontalSpacing) {
                // Icon
                self.icon?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .sparkFrame(size: SnackbarConstants.iconSize)
                    .foregroundStyle(self.viewModel.colors.tintColorToken.color)
                    .accessibilityHidden(true)

                // Content
                SparkVStack(
                    alignment: .leading,
                    spacing: self.viewModel.layout.verticalSubSpacing
                ) {
                    // Title
                    self.titleLabel()
                        .font(self.viewModel.typographies.titleFontToken)
                        .fixedSize(horizontal: false, vertical: true)

                    // Description
                    self.descriptionLabel()
                        .font(self.viewModel.typographies.descriptionFontToken)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundStyle(self.viewModel.colors.tintColorToken)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if !self.button().isEmptyView {
                HStack {
                    // Space (only on vertical snackbar)
                    if self.alignment == .vertical || self.dynamicTypeSize.isAccessibilitySize {
                        Spacer()
                    }

                    // Button
                    self.button()
                        .sparkButtonIntent(self.viewModel.intents.button)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sparkPadding(.init(
            top: self.viewModel.layout.verticalPadding,
            leading: self.viewModel.layout.leadingPadding,
            bottom: self.viewModel.layout.verticalPadding,
            trailing: self.viewModel.layout.trailingPadding
        ))
        .background(self.viewModel.colors.backgroundColorToken)
        .sparkBorder(
            width: self.viewModel.border.width,
            radius: self.viewModel.border.radius,
            colorToken: self.viewModel.colors.borderColorToken
        )
        .shadow(self.theme.value.elevation.dropShadow)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(SnackbarAccessibilityIdentifier.view)
        .onAppear {
            self.viewModel.setup(
                theme: self.theme.value,
                intent: self.intent
            )
        }
        .onChange(of: self.theme) { theme in
            self.viewModel.theme = theme.value
        }
        .onChange(of: self.intent) { intent in
            self.viewModel.intent = intent
        }
    }

    // MARK: - Private Modifier

    @ViewBuilder
    private func contentStack<Content>(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        switch self.alignment {
        case .horizontal:
            SparkAdaptiveStack(
                axis: .horizontal,
                spacing: self.viewModel.layout.horizontalSpacing,
                accessibilityAlignment: .leading,
                accessibilitySpacing: self.viewModel.layout.verticalSpacing,
                content: content
            )
        case .vertical:
            SparkVStack(
                alignment: .leading,
                spacing: self.viewModel.layout.verticalSpacing,
                content: content
            )
        }
    }
}
