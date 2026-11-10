import DaySDK
import GoogleMaps
import UIKit

/// Draws the SDK's maps with Google Maps - the version SwiftPM resolved for the whole app, so an app
/// that uses Google Maps itself shares one copy with the SDK. DaySDK.framework finds this class by its
/// Objective-C name (DaySdkMap.ios.kt) and hands it what to draw - markers, circle and camera are worked
/// out in the SDK, only the Google Maps calls live here. Uses only API that is the same in 9.x, 10.x and 11.x.
@objc(DaySDKGoogleMapsRenderer)
final class GoogleMapsRenderer: NSObject, DaySdkMapRenderer {

    /// Google Maps takes one key per app and the first one given wins: a host that uses Google Maps
    /// itself and sets its key at launch keeps it, and the SDK's maps use it too.
    private static var keyProvided = false

    func createMapView(apiKey: String, interactive: Bool) -> UIView {
        if !Self.keyProvided {
            GMSServices.provideAPIKey(apiKey)
            Self.keyProvided = true
        }
        let map = GMSMapView()
        map.settings.compassButton = false
        map.settings.myLocationButton = false
        map.settings.setAllGesturesEnabled(interactive)
        return map
    }

    func render(mapView: UIView, scene: DaySdkMapScene) {
        guard let map = mapView as? GMSMapView else { return }
        map.isMyLocationEnabled = scene.showsMyLocation
        map.padding = UIEdgeInsets(
            top: scene.paddingTop,
            left: scene.paddingLeft,
            bottom: scene.paddingBottom,
            right: scene.paddingRight
        )

        map.clear()
        for marker in scene.markers {
            let gmsMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: marker.latitude, longitude: marker.longitude))
            gmsMarker.icon = marker.icon
            gmsMarker.groundAnchor = CGPoint(x: marker.anchorX, y: marker.anchorY)
            gmsMarker.zIndex = marker.zIndex
            gmsMarker.map = map
        }
        if let circle = scene.circle {
            let gmsCircle = GMSCircle(
                position: CLLocationCoordinate2D(latitude: circle.latitude, longitude: circle.longitude),
                radius: circle.radiusMeters
            )
            gmsCircle.fillColor = circle.fillColor
            gmsCircle.strokeColor = circle.strokeColor
            gmsCircle.strokeWidth = circle.strokeWidth
            gmsCircle.map = map
        }

        guard let camera = scene.camera else { return }
        let southWest = CLLocationCoordinate2D(latitude: camera.south, longitude: camera.west)
        if camera.isSinglePoint {
            map.moveCamera(GMSCameraUpdate.setTarget(southWest, zoom: camera.singlePointZoom))
        } else {
            let northEast = CLLocationCoordinate2D(latitude: camera.north, longitude: camera.east)
            let bounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
            map.moveCamera(GMSCameraUpdate.fit(bounds, withPadding: camera.edgePadding))
        }
    }
}
