//
//  DecomposeSpinner.swift
//  SpinKit
//
//  Created by Fernando Moya de Rivas on 17/01/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import UIKit

class CubeGridSpinner: Spinner {

    private var squareLayer = CAShapeLayer()
    private var rowReplicatorLayer = CAReplicatorLayer()
    private var replicatorLayer = CAReplicatorLayer()
    
    private var squareRect: CGRect {
        return bounds.applying(CGAffineTransform(scaleX: 1 / 3, y: 1 / 3))
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        rowReplicatorLayer.instanceCount = 3
        replicatorLayer.instanceCount = 3
        
        rowReplicatorLayer.addSublayer(squareLayer)
        replicatorLayer.addSublayer(rowReplicatorLayer)
        layer.addSublayer(replicatorLayer)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        squareLayer.fillColor = primaryColor.cgColor
        squareLayer.strokeColor = squareLayer.fillColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        squareLayer.path = UIBezierPath(rect: squareRect).cgPath
        rowReplicatorLayer.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, squareRect.width, 0, 0)
        replicatorLayer.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, squareRect.height, 0)
        replicatorLayer.frame = bounds
    }
    
    override func startLoading() {
        super.startLoading()
        
        let transform = NSValue(caTransform3D: CATransform3DConcat(CATransform3DScale(CATransform3DIdentity, 0, 0, 1),
                                                                   CATransform3DTranslate(CATransform3DIdentity,
                                                                                          squareRect.width / 2,
                                                                                          squareRect.width / 2, 0)))
        
        let scaleAnim = CABasicAnimation(keyPath: "transform")
        scaleAnim.fromValue = CATransform3DIdentity
        scaleAnim.toValue = transform
        scaleAnim.repeatCount = .infinity
        scaleAnim.autoreverses = true
        scaleAnim.fillMode = .backwards
        scaleAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.83, 0, 0.26, 1.05)
        scaleAnim.duration = 1
        
        rowReplicatorLayer.instanceDelay = scaleAnim.duration / Double(rowReplicatorLayer.instanceCount) / 2
        replicatorLayer.instanceDelay = scaleAnim.duration / Double(replicatorLayer.instanceCount) / 2
        
        squareLayer.add(scaleAnim, forKey: nil)
    }

}