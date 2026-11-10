# Day.io SDK for iOS

The Day.io SDK as a Swift package, for iOS 15 and later.

In Xcode: **File → Add Package Dependencies…**, enter

```
https://github.com/OiTchau/day-spm-sdk
```

and add the **`DaySDK`** product to your app target. SQLCipher and Google Maps come in as package
dependencies; SwiftPM keeps a single Google Maps copy shared with your app.

The SDK draws its maps with Google Maps **9.4 – 9.x**, the last line that runs on iOS 15. If your
app uses Google Maps itself, it must be on 9.x too.

The SDK binary, `DaySDK.xcframework`, is downloaded from `download.day.io` and checked against the
checksum in `Package.swift`.

For setup and usage, see the integration guide you received from Day.io. Use of the SDK is subject
to the [license terms](LICENSE).
