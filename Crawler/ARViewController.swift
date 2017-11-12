//
//  ARViewController.swift
//  Crawler
//
//  Created by Jack Chorley on 12/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var scene = ARScene()
    var configuration = ARWorldTrackingConfiguration()  //ARWorldTrackingSessionConfiguration()
    
    var planeNode: SCNNode!
    
//    var planeIdentifiers = [UUID]()
    var anchors = [ARAnchor]()
//    var nodes = [SCNNode]()
    var planeNodesCount = 0
    var planeHeight: CGFloat = 0.01
    var disableTracking = false
//    var isPlaneSelected = false
    
    var arrowNode: SCNNode!
    
//    var lampNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set the scene to the view
        self.sceneView.scene = scene
        
        self.sceneView.autoenablesDefaultLighting = true
        
        self.sceneView.debugOptions  = [.showConstraints, .showLightExtents, ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        //shows fps rate
        self.sceneView.showsStatistics = true
        
        self.sceneView.automaticallyUpdatesLighting = true
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setSessionConfiguration(pd: .horizontal, runOPtions: .resetTracking)
    }
    
    func setSessionConfiguration(pd : ARWorldTrackingConfiguration.PlaneDetection,
                                 runOPtions: ARSession.RunOptions) {
        //currenly only planeDetection available is horizontal.
        configuration.planeDetection = pd
        sceneView.session.run(configuration, options: runOPtions)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*Implement this to provide a custom node for the given anchor.
     
     @discussion This node will automatically be added to the scene graph.
     If this method is not implemented, a node will be automatically created.
     If nil is returned the anchor will be ignored.
     @param renderer The renderer that will render the scene.
     @param anchor The added anchor.
     @return Node that will be mapped to the anchor or nil.
     */
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if disableTracking {
            return nil
        }
        var node:  SCNNode?
        if let planeAnchor = anchor as? ARPlaneAnchor {
            node = SCNNode()
            //            let planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeGeometry = SCNBox(width: CGFloat(planeAnchor.extent.x), height: planeHeight, length: CGFloat(planeAnchor.extent.z), chamferRadius: 0.0)
            planeGeometry.firstMaterial?.diffuse.contents = UIColor.green
            planeGeometry.firstMaterial?.specular.contents = UIColor.white
            let planeNode = SCNNode(geometry: planeGeometry)
            planeNode.position = SCNVector3Make(planeAnchor.center.x, Float(planeHeight / 2), planeAnchor.center.z)
            //            since SCNPlane is vertical, needs to be rotated -90 degress on X axis to make a plane
            //            planeNode.transform = SCNMatr
            node?.addChildNode(planeNode)
            
            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 0.1, height: 0.3))
            let shape = SCNShape(path: path, extrusionDepth: 0.01)
            shape.firstMaterial?.diffuse.contents = UIColor.blue
            shape.firstMaterial?.specular.contents = UIColor.white
            
            arrowNode = SCNNode(geometry: shape)
            arrowNode.transform = SCNMatrix4MakeRotation(Float(-CGFloat.pi/2), 1, 0, 0)
            
            arrowNode.transform = SCNMatrix4Translate(arrowNode.transform, 0, 0.01, 0)
            
            planeNode.addChildNode(arrowNode)
            
            anchors.append(planeAnchor)
            
        } else {
            // haven't encountered this scenario yet
            print("not plane anchor \(anchor)")
        }
        return node
    }
    
    
    // Called when a new node has been mapped to the given anchor
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        planeNodesCount += 1
        if node.childNodes.count > 0 && planeNodesCount % 2 == 0 {
            node.childNodes[0].geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        }
    }
    
    // Called when a node has been updated with data from the given anchor
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if disableTracking {
            return
        }
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if anchors.contains(planeAnchor) {
                if node.childNodes.count > 0 {
                    let planeNode = node.childNodes.first!
                    planeNode.orientation = SCNQuaternion(0, 0, 0, 0)
                    planeNode.position = SCNVector3Make(planeAnchor.center.x, Float(planeHeight / 2), planeAnchor.center.z)
                    if let plane = planeNode.geometry as? SCNBox {
//                        let transformVector = arrowNode.convertPosition(arrowNode.position, to: sceneView.pointOfView!)
//                        arrowNode.transform = SCNMatrix4Translate(arrowNode.transform, transformVector.x, 0, transformVector.z)
                        
                        plane.width = CGFloat(planeAnchor.extent.x)
                        plane.length = CGFloat(planeAnchor.extent.z)
                        plane.height = planeHeight
                    }
                }
            }
        }
    }
    
    /* Called when a mapped node has been removed from the scene graph for the given anchor.
     This delegate did not got called for every node removal in this app. Still need to rearch on what I am missing.
     */
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("remove node delegate called")
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            print("Done")
        case .notAvailable: break
        case .limited(let reason):
            switch reason {
            case .excessiveMotion: break
            case .insufficientFeatures: break
            case .initializing:
                break
            }
            
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if arrowNode == nil || sceneView == nil {
            return
        }
        
        let dx = arrowNode.worldPosition.x - sceneView.pointOfView!.worldPosition.x
        let dz = arrowNode.worldPosition.z - sceneView.pointOfView!.worldPosition.z
        
        print(dx)
        print(dz)
        
        
        arrowNode.setWorldTransform(SCNMatrix4Translate(arrowNode.worldTransform, -dx, 0, -dz))
        
        let dTheta = arrowNode.worldOrientation.y - 0
        print(dTheta)
        
        arrowNode.orientation = SCNQuaternion(arrowNode.orientation.x, arrowNode.orientation.y - dTheta, arrowNode.orientation.z, arrowNode.orientation.w)
        
        
    }
}
