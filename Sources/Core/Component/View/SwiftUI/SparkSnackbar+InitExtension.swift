//
//  SparkSnackbar+InitExtension.swift
//  SparkComponentSnackbar
//
//  Created by robin.lemaire on 18/05/2026.
//  Copyright © 2026 Leboncoin. All rights reserved.
//

import SwiftUI

public extension SparkSnackbar {

    // MARK: - Initialization

    /// Creates a snackbar with a text title and description.
    ///
    /// - Parameters:
    ///   - icon: An optional icon to display. Optional. Default is *nil*.
    ///   - title: The title text to display on the snackbar.
    ///   - description: The description text to display below the title.
    ///
    /// ## Example of usage
    ///
    /// ```swift
    /// SparkSnackbar(
    ///     "Upload complete",
    ///     description: "Your file has been uploaded successfully"
    /// )
    /// .sparkTheme(self.theme)
    /// .sparkSnackbarIntent(.success)
    /// ```
    ///
    /// ## Rendering
    ///
    /// ![Button rendering.](snackbar_full.png)
    ///
    init(
        _ icon: Image? = nil,
        title: String,
        description: String
    ) where TitleLabel == Text, DescriptionLabel == Text, ActionButton == EmptyView {
        self.init(
            icon,
            titleLabel: { Text(title) },
            descriptionLabel: { Text(description) },
            button: { EmptyView() }
        )
    }

    /// Creates a snackbar with a text title, description, and an action button.
    ///
    /// - Parameters:
    ///   - icon: An optional icon to display. Optional. Default is *nil*.
    ///   - title: The title text to display on the snackbar.
    ///   - description: The description text to display below the title.
    ///   - button: A view builder that creates the action button.
    ///
    /// ## Example of usage
    ///
    /// ```swift
    /// SparkSnackbar(
    ///     Image(systemName: "wifi.slash"),
    ///     "Connection lost",
    ///     description: "Unable to reach the server"
    /// ) {
    ///     SparkButton("Retry") {
    ///         // Retry action
    ///     }
    ///     .sparkButtonVariant(.ghost)
    /// }
    /// .sparkTheme(self.theme)
    /// .sparkSnackbarIntent(.error)
    /// ```
    ///
    /// ## Rendering
    ///
    /// ![Button rendering.](snackbar_full.png)
    ///
    init(
        _ icon: Image? = nil,
        title: String,
        description: String,
        @ViewBuilder button: @escaping () -> ActionButton
    ) where TitleLabel == Text, DescriptionLabel == Text {
        self.init(
            icon,
            titleLabel: { Text(title) },
            descriptionLabel: { Text(description) },
            button: button
        )
    }

    /// Creates a snackbar with a custom title label and description label.
    ///
    /// Use this initializer when you need custom content for both title and description.
    ///
    /// - Parameters:
    ///   - icon: An optional icon to display. Optional. Default is *nil*.
    ///   - titleLabel: A view builder that creates the title label.
    ///   - descriptionLabel: A view builder that creates the description label.
    ///
    /// ## Example of usage
    ///
    /// ```swift
    /// SparkSnackbar(
    ///     Image(systemName: "bell.fill"),
    ///     titleLabel: {
    ///         Text("New Message")
    ///             .bold()
    ///     },
    ///     descriptionLabel: {
    ///         VStack(alignment: .leading) {
    ///             Text("John Doe")
    ///             Text("Hello, how are you?")
    ///         }
    ///     }
    /// )
    /// .sparkTheme(self.theme)
    /// .sparkSnackbarIntent(.info)
    /// ```
    ///
    /// ## Rendering
    ///
    /// ![Button rendering.](snackbar_full.png)
    ///
    init(
        _ icon: Image? = nil,
        @ViewBuilder titleLabel: @escaping () -> TitleLabel,
        @ViewBuilder descriptionLabel: @escaping () -> DescriptionLabel
    ) where ActionButton == EmptyView {
        self.init(
            icon,
            titleLabel: titleLabel,
            descriptionLabel: descriptionLabel,
            button: { EmptyView() }
        )
    }

    /// Creates a snackbar with only a description text (no title).
    ///
    /// - Parameters:
    ///   - icon: An optional icon to display. Optional. Default is *nil*.
    ///   - description: The description text to display.
    ///
    /// ## Example of usage
    ///
    /// ```swift
    /// SparkSnackbar(
    ///     Image(systemName: "checkmark.circle"),
    ///     description: "File saved successfully"
    /// )
    /// .sparkTheme(self.theme)
    /// .sparkSnackbarIntent(.success)
    /// ```
    ///
    /// ## Rendering
    ///
    /// ![Button rendering.](snackbar_full.png)
    ///
    init(
        _ icon: Image? = nil,
        description: String
    ) where TitleLabel == EmptyView, DescriptionLabel == Text, ActionButton == EmptyView {
        self.init(
            icon,
            titleLabel: { EmptyView() },
            descriptionLabel: { Text(description) },
            button: { EmptyView() }
        )
    }

    /// Creates a snackbar with description text and an action button (no title).
    ///
    /// - Parameters:
    ///   - icon: An optional icon to display. Optional. Default is *nil*.
    ///   - description: The description text to display.
    ///   - button: A view builder that creates the action button.
    ///
    /// ## Example of usage
    ///
    /// ```swift
    /// SparkSnackbar(
    ///     Image(systemName: "trash"),
    ///     description: "Item deleted"
    /// ) {
    ///     SparkButton("Undo") {
    ///         // Undo action
    ///     }
    ///     .sparkButtonVariant(.ghost)
    /// }
    /// .sparkTheme(self.theme)
    /// .sparkSnackbarIntent(.alert)
    /// ```
    ///
    /// ## Rendering
    ///
    /// ![Button rendering.](snackbar_full.png)
    ///
    init(
        _ icon: Image? = nil,
        description: String,
        @ViewBuilder button: @escaping () -> ActionButton
    ) where TitleLabel == EmptyView, DescriptionLabel == Text {
        self.init(
            icon,
            titleLabel: { EmptyView() },
            descriptionLabel: { Text(description) },
            button: button
        )
    }

    /// Creates a snackbar with a custom description label (no title).
    ///
    /// Use this initializer when you need custom description content without a title.
    ///
    /// - Parameters:
    ///   - icon: An optional icon to display. Optional. Default is *nil*.
    ///   - descriptionLabel: A view builder that creates the description label.
    ///
    /// ## Example of usage
    ///
    /// ```swift
    /// SparkSnackbar(
    ///     Image(systemName: "info.circle"),
    ///     descriptionLabel: {
    ///         VStack(alignment: .leading, spacing: 4) {
    ///             Text("System update available")
    ///             Text("Version 2.0.1")
    ///                 .font(.caption)
    ///         }
    ///     }
    /// )
    /// .sparkTheme(self.theme)
    /// .sparkSnackbarIntent(.info)
    /// ```
    ///
    /// ## Rendering
    ///
    /// ![Button rendering.](snackbar_full.png)
    ///
    init(
        _ icon: Image? = nil,
        @ViewBuilder descriptionLabel: @escaping () -> DescriptionLabel
    ) where TitleLabel == EmptyView, ActionButton == EmptyView {
        self.init(
            icon,
            titleLabel: { EmptyView() },
            descriptionLabel: descriptionLabel,
            button: { EmptyView() }
        )
    }

    /// Creates a snackbar with a custom description label and an action button (no title).
    ///
    /// Use this initializer when you need custom description content with an action button but no title.
    ///
    /// - Parameters:
    ///   - icon: An optional icon to display. Optional. Default is *nil*.
    ///   - descriptionLabel: A view builder that creates the description label.
    ///   - button: A view builder that creates the action button.
    ///
    /// ## Example of usage
    ///
    /// ```swift
    /// SparkSnackbar(
    ///     Image(systemName: "photo"),
    ///     descriptionLabel: {
    ///         HStack {
    ///             Text("Photo uploaded")
    ///             Image(systemName: "checkmark")
    ///                 .foregroundColor(.green)
    ///         }
    ///     }
    /// ) {
    ///     SparkButton("View") {
    ///         // View action
    ///     }
    ///     .sparkButtonVariant(.ghost)
    /// }
    /// .sparkTheme(self.theme)
    /// .sparkSnackbarIntent(.success)
    /// ```
    ///
    /// ## Rendering
    ///
    /// ![Button rendering.](snackbar_full.png)
    ///
    init(
        _ icon: Image? = nil,
        @ViewBuilder descriptionLabel: @escaping () -> DescriptionLabel,
        @ViewBuilder button: @escaping () -> ActionButton
    ) where TitleLabel == EmptyView {
        self.init(
            icon,
            titleLabel: { EmptyView() },
            descriptionLabel: descriptionLabel,
            button: button
        )
    }
}
