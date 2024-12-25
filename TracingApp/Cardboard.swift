//
//  Cardboard.swift
//  Tracer
//
//  Created by Abhishek Chandrashekar on 20/01/20.
//  Copyright © 2020 Abhishek Chandrashekar. All rights reserved.
//
import UIKit
import Foundation


protocol TouchResponder : class {
    func  touchedAt(point:CGPoint)
}


class Cardboard: UIView {
    
    var drawColor = UIColor.green
    var lineWidth: CGFloat = 30
    
    private var lastPoint: CGPoint!
    private var bezierPath: UIBezierPath!
    var trackPath: UIBezierPath!
    
    weak var delegate : TouchResponder?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initBezierPath()
        initializeTrackPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBezierPath()
        initializeTrackPath()
    }
    
    func initBezierPath() {
        bezierPath = UIBezierPath()
        bezierPath.lineCapStyle = CGLineCap.round
        bezierPath.lineJoinStyle = CGLineJoin.round
    }
    
    // MARK: - Touch handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        delegate?.touchedAt(point: touch!.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        let newPoint = touch!.location(in: self)
        setNeedsDisplay()
        delegate?.touchedAt(point: newPoint)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        touchesEnded(touches!, with: event)
    }
    
    
    func joinPoint(touchedPoint:CGPoint,lastPoint:CGPoint) {
        
        bezierPath.move(to: lastPoint)
        bezierPath.addLine(to: touchedPoint)
        setNeedsDisplay()
    }
    
    // MARK: - Render
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
        bezierPath.lineWidth = lineWidth
        UIColor.clear.setFill()
        UIColor.clear.setStroke()
        bezierPath.stroke()
        
        
        UIColor.blue.setFill()
        UIColor.white.setStroke()
        trackPath.lineWidth = lineWidth
        trackPath.stroke()
        
        let drawpath = UIBezierPath(cgPath:bezierPath.cgPath)
        UIColor.black.setFill()
        UIColor.black.setStroke()
        drawpath.lineJoinStyle = .round
        drawpath.lineCapStyle = .round
        drawpath.lineWidth = 10
        drawpath.stroke()
    }
    
    // MARK: - Clearing
    
    func clear() {
        bezierPath.removeAllPoints()
        setNeedsDisplay()
    }
    
    // MARK: - Other
    
    func setDrawColor(color:UIColor) {
        self.drawColor = color
    }
    
    func setPenSize(size:CGFloat) {
        self.lineWidth = size
    }
    
}

extension Cardboard {
    
    func initializeTrackPath() {
        trackPath = UIBezierPath()
        trackPath.lineJoinStyle = .round
        trackPath.lineCapStyle = .round
    }
    
    func drawLine(start:CGPoint,end:CGPoint) {
        trackPath.move(to: start)
        trackPath.addLine(to: end)
        setNeedsDisplay()
    }
    
}
