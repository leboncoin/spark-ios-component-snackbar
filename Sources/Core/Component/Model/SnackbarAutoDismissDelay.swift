//
//  SnackbarAutoDismissDelay.swift
//  SparkSnackbar
//
//  Created by louis.borlee on 23/10/2024.
//  Copyright © 2024 Leboncoin. All rights reserved.
//

import Foundation

public enum SnackbarAutoDismissDelay: CaseIterable, Equatable {
    case fast
    case long

    internal var seconds: Double {
        switch self {
        case .fast: return 4
        case .long: return 10
        }
    }
}
