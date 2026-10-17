# SwiftUI Examples

A collection of small iOS demos exploring SwiftUI layouts, navigation, and asynchronous image loading and caching.

## Demos

- **Lazy Photo Grid** — An adaptive photo grid with pagination, pull-to-refresh, and image caching.
- **Photo Carousel** — A paged photo carousel with loading indicators and retry controls.
- **Peeking Carousel View** — A carousel layout that reveals adjacent items.

The app uses a shared `NavigationStack` router to open each demo from the main list. Photo demos load images from [Lorem Picsum](https://picsum.photos).

## Requirements

- macOS with Xcode and an iOS SDK that supports the project's iOS 26.5 deployment target.
- An iOS 26.5 or later simulator or device.
- Internet access for the photo demos.

No third-party package dependencies are required.

## Run the app

1. Clone the repository:

   ```sh
   git clone https://github.com/kartikkotak/swiftui-examples.git
   cd swiftui-examples
   ```

2. Open `iOSDemos.xcodeproj` in Xcode.
3. Select the `iOSDemos` scheme and a supported iOS simulator or device. For a physical device, configure your signing team in **Signing & Capabilities**.
4. Run with **Command-R**, then choose a demo from **iOS Demo List**.

## Project structure

```text
iOSDemos/
├── App/               # App entry point
├── Demos/
│   ├── Layout/        # Main demo list and peeking carousel
│   ├── Navigation/    # Shared navigation router
│   ├── PhotoCarousel/ # Paged photo carousel
│   └── PhotoGridView/ # Photo grid, models, service, and view model
├── Resources/         # Asset catalog
└── Shared/Libraries/  # Image loading and caching
iOSDemosTests/         # Unit test target
iOSDemosUITests/       # UI test target
```

To run the test targets, select **Product > Test** in Xcode (**Command-U**).

## License

This project is available under the [MIT License](LICENSE).
