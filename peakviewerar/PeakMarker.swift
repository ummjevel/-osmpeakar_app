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

class PeakMarker : LocationNode {
    var title: String
    var markerNode: SCNNode
    
    init(location: CLLocation?, title: String) {
        self.markerNode = SCNNode()
        self.title = title
        super.init(location: location)
        initializeUI()
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
        
        let plane = SCNPlane(width: 10, height: 6)
        plane.cornerRadius = 0.2
        plane.firstMaterial?.diffuse.contents = UIColor.green
        
        let text = SCNText(string: self.title, extrusionDepth: 0)
        text.containerFrame = CGRect(x: 0, y: 0, width: 10, height: 6)
        text.isWrapped = true
        text.font = UIFont(name: "Futura", size: 2.0)
        text.alignmentMode = (CATextLayerAlignmentMode.center).rawValue // kCAAlignmentCenter
        text.truncationMode = (CATextLayerTruncationMode.middle).rawValue // kCATruncationMiddle
        text.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(0, 0, 0.2)
        center(node: textNode)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.addChildNode(textNode)
        
        self.markerNode.scale = SCNVector3(5,5,5)
        self.markerNode.addChildNode(planeNode)
        
        // text 방향이 사용자를 향하도록 조정
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        self.addChildNode(self.markerNode)
        
        
    }
}
