# GraphQLGithub
Demo iOS app to fetch GraphQL Repositories

## Notes:

- In order to to run the app please add your github token to `AppConstants` File
- The app is using SwiftUI for View Rendering, as the main view is just a List with pagination I found SwiftUI suitable for this.
- GraphQL requests are handle via `URLSession`.
- It doesn't use any external library so after setting your github token you are good to go.
- It uses `MVVM` architecture, it help us to isolate View Logic, and it make it easier to test.
- `GraphQLProvider` protocol is included to help us Mock GraphQL Requests.
- Unit tests are included, also View Models are created with dependency Injection so they are easy testable, if further tests are needed.
- The user can add Items to favorites, favorites items are persisted in the app.
- Selecting a cell will show the website for the repository, Using `WKWebview` as `UIViewRepresentable`.
- Localization is included for english and spanish (Latin american).
- iOS target is 14.1
