//
//  PeakMarker.swift
//  peakviewerar
//
//  Created by 전민정 on 2021/10/27.
//

import Foundation
import ARCL
import CoreLocation
import SceneKit

enum MarkerType {
    case marker
    case message
}

class PeakMarker : LocationNode {
    var title: String
    var markerNode: SCNNode
    var markerType: MarkerType
    
    init(location: CLLocation?, title: String) {
        self.markerNode = SCNNode()
        self.title = title
        self.markerType = MarkerType.marker
        super.init(location: location)
        initializeUI()
    }
    
    init(location: CLLocation?, title: String, markerType: MarkerType) {
        self.markerNode = SCNNode()
        self.title = title
        self.markerType = markerType
        super.init(location: location)
        switch self.markerType {
        case MarkerType.marker:
            initializeUI()
        case MarkerType.message:
            initializeMessage()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func center(node: SCNNode) {
        
        let (min,max) = node.boundingBox
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        node.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
    }
    
    private func initializeUI() {
        
        let text = SCNText(string: self.title, extrusionDepth: 0)
        text.containerFrame = CGRect(x: 0, y: 0, width: 10, height: 3)
        text.isWrapped = true
        text.font = UIFont(name: "ArialMT", size: 1.5)
        text.alignmentMode = (CATextLayerAlignmentMode.center).rawValue // kCAAlignmentCenter
        text.truncationMode = (CATextLayerTruncationMode.middle).rawValue // kCATruncationMiddle
        text.firstMaterial?.diffuse.contents = UIColor.darkText
        
        
        let plane = SCNPlane(width: text.containerFrame.width, height: text.containerFrame.height)
        plane.cornerRadius = 1
        plane.firstMaterial?.diffuse.contents = UIColor.lightText
        
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(0, 0, 0.2)
        // SCNVector4(0.0, 0.0, 1.0, ConvertDegreesToRadians(45.0)
        // textNode.localRotate(by: SCNVector4(0.0, 0.0, 0.3, ConvertDegreesToRadians(angle: 45.0)))
                             
        center(node: textNode)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(0, 5, 0)
        planeNode.localRotate(by: SCNVector4(0.0, 0.0, 0.3, ConvertDegreesToRadians(angle: 45.0)))
        planeNode.addChildNode(textNode)
        
        self.markerNode.scale = SCNVector3(100,100,50)
        self.markerNode.addChildNode(planeNode)
        
        // text 방향이 사용자를 향하도록 조정
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        self.addChildNode(self.markerNode)
    }
    
    public func ConvertDegreesToRadians(angle: Float) -> Float {
        return ((Float.pi / 180) * angle);
    }
    
    private func initializeMessage() {
        
        let text = SCNText(string: self.title, extrusionDepth: 0)
        text.containerFrame = CGRect(x: 0, y: 0, width: 15, height: 7)
        text.isWrapped = true
        text.font = UIFont(name: "HelveticaNeue-Medium", size: 1)
        text.alignmentMode = (CATextLayerAlignmentMode.center).rawValue // kCAAlignmentCenter
        text.truncationMode = (CATextLayerTruncationMode.middle).rawValue // kCATruncationMiddle
        text.firstMaterial?.diffuse.contents = UIColor.darkText
        
        let plane = SCNPlane(width: 17, height: 7)
        plane.cornerRadius = 1
        plane.firstMaterial?.diffuse.contents = UIColor.lightText
        
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(0, 0, 0.2)
        center(node: textNode)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(0, 25, -30)
        planeNode.addChildNode(textNode)
        
        self.markerNode.scale = SCNVector3(2,2,2)
        self.markerNode.addChildNode(planeNode)
        
        // text 방향이 사용자를 향하도록 조정
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        self.addChildNode(self.markerNode)
    }
}
