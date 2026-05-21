---
name: spark-snackbar-refactoring
description: Make a refactoring for the Snackbar component
---
### Snackbar refactoring

This skill will refactor the Snackbar component.

Use the skill *spark-component-view*

## Steps

- [ ] Add a new *SparkSnackbar* (SwiftUI) and *SparkUISnackbar* (UIKit) :
    - The UIKit view inherits from UIView.
    - Use the **anatomy.png** in *template* folder to create the views.
    - The init of SwiftUI must manage the optional title and the description in 
      - String
      - Label (dynamic view)
    - For SwiftUI view, the button must the a dynamic view.
    - For UIKit, the button must be a public optional SparkUIButton
    - For SwiftUI view, use the environment properties 
      - sparkTheme
      - snackbarAlignment
      - snackbarIntent

### Code Conventions
- [ ] Write the unit tests in Swift Testing. Only the snapshots testing must be in XCTests
