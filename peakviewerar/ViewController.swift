//
//  ViewController.swift
//  peakviewerar
//
//  Created by 전민정 on 2021/10/23.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import ARCL

import MapKit


class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, CLLocationManagerDelegate { //}, CLLocationManagerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    lazy private var locationManager2 = CLLocationManager()
    //var locationManager: CLLocationManager?
    //var currentLocation: CLLocationCoordinate2D!
    
    // var currentLat: Double = 0.0
    // var currentLon: Double = 0.0
    
    var sceneLocationView = SceneLocationView()
    // var configuration = ARWorldTrackingConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 카메라 사용 동의
        // requestCameraAuthorization()
        // 위치 제공 정보 동의
        // requestLocationAuthorization()
        
        // camera displayed
        sceneLocationView.run()
        self.view.addSubview(sceneLocationView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        // let scene = SCNScene(named: "art.scnassets/ship.scn")!
        // let scene = SCNScene()
        // Set the scene to the view
        // sceneView.scene = scene
        
        self.locationManager2.delegate = self
        self.locationManager2.desiredAccuracy = kCLLocationAccuracyBest
        // self.locationManager2.requestAlwaysAuthorization()
        self.locationManager2.startUpdatingLocation()
        
        setUpButtons()
        // registerGestureRecognizers()
        
        /// 위치 정보 전달하여 api 호출
        // findLocalPlaces()
        // sendCurrentLatLong()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // whole screen
        sceneLocationView.frame = self.view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    /*
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("aaaaaaaaaaaaaaaaaaaaa")
        // Present an error message to the user
        /*
        print("Session failed. Changing worldAlignment property.")
        print(error.localizedDescription)

        if let arError = error as? ARError {
            switch arError.errorCode {
            case 102:
                configuration.worldAlignment = .gravity
                restartSessionWithoutDelete()
            default:
                // configuration.worldAlignment = .gravityAndHeading
                restartSessionWithoutDelete()
            }
        }*/
    }
    
    func restartSessionWithoutDelete() {
        // Restart session with a different worldAlignment - prevents bug from crashing app
        self.sceneView.session.pause()

        self.sceneView.session.run(configuration, options: [
            .resetTracking,
            .removeExistingAnchors])
    }
    */
    
    /*
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("세션이 interrupted...")
        
        // configuration.worldAlignment = .gravity
        // restartSessionWithoutDelete()
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("세션이 interrupted end...")
        // sendCurrentLatLong()
    }
    
    private func requestCameraAuthorization() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("카메라 권한 허용")
            } else {
                print("카메라 권한 비허용!!")
            }
        })
    }
   
    private func requestLocationAuthorization() {
        if locationManager == nil {
            // print("locationmanager is nil...")
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
            // locationManagerDidChangeAuthorization(locationManager!)
        } else {
            // locationManager!.startMonitoringSignificantLocationChanges()
        }
        
        // LocationService.shared.longitude = locationManager!.location?.coordinate.longitude
        // LocationService.shared.latitude = locationManager!.location?.coordinate.latitude
        
        //sendCurrentLatLong()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
            LocationService.shared.longitude = currentLocation.longitude
            LocationService.shared.latitude = currentLocation.latitude
            // print("현재 위치 경도: \(String(describing: LocationService.shared.longitude)), 위도: \(String(describing: LocationService.shared.latitude))\n")
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
            case .notAvailable:
                print("Tracking: not available: \(camera.trackingState)")
            case .limited(let reason):
                print("Tracking limited: \(reason)")
            case .normal:
                print("tracking normal: \(camera.trackingState)")
                sendCurrentLatLong()
            }
    }
     
    func session(_ session: ARSession, didChange geoTrackingStatus: ARGeoTrackingStatus) {
        print("안녕 geoTrackingStatus")
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        print("안녕 didUpdate")
    }
   
    func session(_ session: ARSession, didOutputCollaborationData data: ARSession.CollaborationData) {
        
        print("안녕 didOutputCollaborationData")
    }
    */
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus.rawValue > 2 {
            sendCurrentLatLong()
        }
    }
    
    private func setUpButtons() {
        let refreshButton = UIButton(frame: CGRect(x: self.sceneView.frame.width - 120, y: 60, width: 100, height: 30))
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        sceneLocationView.addSubview(refreshButton)
        
    }
    
    @objc func sendRequest() {
        sendCurrentLatLong()
    }
    
    func sendCurrentLatLong() {
        
        print("!!!!!!!!!!!!")
        print("\(locationManager2.authorizationStatus.rawValue)")
        print("\(AVCaptureDevice.authorizationStatus(for: AVMediaType.video).rawValue)")
        
        if locationManager2.authorizationStatus == .denied || AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .authorized {
            print("DENIED.... ")
            return
        }
        
        guard let currentLat = locationManager2.location?.coordinate.latitude else {
            print("currentLat is empty.")
            return
        }
        guard let currentLon = locationManager2.location?.coordinate.longitude else {
            print("currentLon is empty.")
            return
        }
        //currentLat = 38.1191725
        // currentLon = -128.4653076
        print("\(currentLat), \(currentLon)")
        // locationManager = CLLocationManager()
        // locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        // locationManager!.delegate = self
        
        // print("안녕?")
        
        /*
        guard let lat = LocationService.shared.latitude else {
            print("[sendCurrentLatLong] LocationService.shared.latitude 값 없음")
            return
        }
        
        guard let lon = LocationService.shared.longitude else {
            print("[sendCurrentLatLong] LocationService.shared.longitude 값 없음")
            return
        }
        
        
        let locaMgr = CLLocationManager()
        locaMgr.desiredAccuracy = kCLLocationAccuracyBest
        locaMgr.delegate = self
        locaMgr.startMonitoringSignificantLocationChanges()
        
        //if locaMgr.authorizationStatus == .authorizedAlways || locaMgr.authorizationStatus == .authorizedWhenInUse {
            
            LocationService.shared.longitude = locaMgr.location?.coordinate.longitude
            LocationService.shared.latitude = locaMgr.location?.coordinate.latitude
        // }
        
        guard let lat = LocationService.shared.latitude else {
            print("[sendCurrentLatLong] LocationService.shared.latitude 값 없음")
            return
        }
        
        guard let lon = LocationService.shared.longitude else {
            print("[sendCurrentLatLong] LocationService.shared.longitude 값 없음")
            return
        }
         */
        // let lat = locationManager!.location?.coordinate.latitude as Double?
        // let lon = locationManager!.location?.coordinate.longitude as Double?
        // let lat = LocationService.shared.latitude
        // let lon = LocationService.shared.longitude
        
        // print("현재 위치: \(lat), \(lon) ")
        
        // 전달
        // 38.1191725/128.4653076
        // \(lat)/\(lon)
        // lat = 38.1191725
        // lon = -128.4653076
        request("http://3.145.25.38:9000/api/osm/\(currentLat)/\(currentLon)", "GET") { (success, data) in
            // print(data)
            if success {
                let mirror = Mirror(reflecting: data)
                var resultValue : String = ""
                var bodyValue : [Osm] = []
                var messageValue : String = ""
                for child in mirror.children  {
                    // print("child.label: \(child.label) , child.value: \(child.value)")
                    if child.label == "result" {
                        resultValue = child.value as? String ?? ""
                    } else if child.label == "body" {
                        bodyValue = child.value as? [Osm] ?? []
                    } else if child.label == "message" {
                        messageValue = child.value as? String ?? ""
                    }
                    // print("\(child.value)")
                }
                
                let responseResult2 = Response(result: resultValue, message: messageValue, body: bodyValue)
                
                if responseResult2.result == "OK" {
                    
                    for child in responseResult2.body {
                        // ar text 표시
                        let placeLocation = CLLocation(latitude: child.lat, longitude: child.lon)
                        
                        let placeAnnotationNode = PeakMarker(location: placeLocation, title: child.name_en!)
                        
                        DispatchQueue.main.async {
                            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode)
                        }
                    }
                    print("내가 그림!")
                } else if responseResult2.result == "CREATED" {
                    // not found... show message
                    //print("httpstatuscode is 201(CREATED...) nothing in here.")
                    /*
                    let text = SCNText(string: "Nothing in here...", extrusionDepth: 1.0)
                    text.firstMaterial?.diffuse.contents = UIColor.blue
                    let textNode = SCNNode(geometry: text)
                    textNode.position = SCNVector3(0, 0, -0.5)
                    textNode.scale =  SCNVector3(0.02, 0.02, 0.02)
                    self.sceneView.scene.rootNode.addChildNode(textNode)*/
                } else {
                    // error... show message
                    /*
                    let text = SCNText(string: "ERROR... sorry", extrusionDepth: 1.0)
                    text.firstMaterial?.diffuse.contents = UIColor.blue
                    let textNode = SCNNode(geometry: text)
                    textNode.position = SCNVector3(0, 0, -0.5)
                    textNode.scale =  SCNVector3(0.02, 0.02, 0.02)
                    self.sceneView.scene.rootNode.addChildNode(textNode)*/
                }
                
            } else {
                // request error
            }
        }
 
    }
    
    /*
    private func findLocalPlaces() {
        
        guard let location = self.locationManager!.location else {
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Coffee"
        
        var region = MKCoordinateRegion()
        // region.center = CLLocationCoordinate2D(latitude: 37.6481865, longitude: 127.0357375)
        region.center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            
            if error != nil {
                return
            }
            
            guard let response = response else {
                return
            }
            
            for item in response.mapItems {
                
                print((item.placemark))
                
                let placeLocation = (item.placemark.location)!
                
                let placeAnnotationNode = PeakMarker(location: placeLocation, title: item.placemark.name!)
                
                DispatchQueue.main.async {
                     self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode)
                   
                    
                }
                
            }
        }
        
    }*/
    
}
