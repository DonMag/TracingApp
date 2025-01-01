//
//  ExplainViewController.swift
//  TracingApp
//
//  Created by Don Mag on 12/28/24.
//

import UIKit
import SwiftyDraw

class ExplainViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var st: String = ""
		var f: [CGFloat] = []
		
		st = "  moveto (57.3205, 33.8205)"
		f = UserPath().extractFloats(from: st)
		print(f)
		print()
		st = "quadto (57.4872, 33.6538) (57.8205, 33.6538)"
		f = UserPath().extractFloats(from: st)
		print(f)
		print()

		
		var path = MyBezierPath(svgPath: "m 27,30 H 100")
		
		var defaultTransform = CGAffineTransform(scaleX: 4, y: 4)
			.translatedBy(x: 10.0, y: -10.0)
		
		guard let pth1 = path.cgPath.copy(using: &defaultTransform) else { return }
		path1 = MyBezierPath(cgPath: pth1)
		
		print("p1 len:", path1.length)
		
		let c1 = CAShapeLayer()
		c1.strokeColor = dashColor
		c1.fillColor = UIColor.clear.cgColor
		c1.lineDashPattern = [8,8]
		c1.path = pth1
		
		dashLayers.append(c1)
		
		if let startPoint = path1.cgPath.points().first {
			let circulPath = UIBezierPath(arcCenter: CGPoint(x: startPoint.x , y: startPoint.y) , radius: 3.5, startAngle: 0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
			let circleLayer = CAShapeLayer()
			circleLayer.path = circulPath.cgPath
			circleLayer.fillColor = dashColor
			circleLayer.transform = CATransform3DMakeTranslation(0, 0, 0)
			c1.insertSublayer(circleLayer, at: 0)
		}
		
		var secondLastPoint =  path1.cgPath.points().count>2 ?  path1.cgPath.points()[path1.cgPath.points().count-2] : path1.cgPath.points()[0]
		if let lastPoint = path1.cgPath.points().last {
			let angle = atan2((lastPoint.y - secondLastPoint.y), (lastPoint.x - secondLastPoint.x))
			let distance: CGFloat = 4.0
			let path = UIBezierPath()
			path.move(to: lastPoint)
			path.addLine(to: calculatePoint(from: lastPoint, angle: angle + CGFloat.pi/2, distance: distance)) // to the right
			path.addLine(to: calculatePoint(from: lastPoint, angle: angle, distance: distance)) // straight ahead
			path.addLine(to: calculatePoint(from: lastPoint, angle: angle - CGFloat.pi/2, distance: distance)) // to the left
			path.close()
			let  arrowHeadLayer = CAShapeLayer()
			arrowHeadLayer.path = path.cgPath
			arrowHeadLayer.lineWidth = 1
			arrowHeadLayer.strokeColor = dashColor
			arrowHeadLayer.fillColor = dashColor
			c1.insertSublayer(arrowHeadLayer, at: 1)
		}
		
		view.layer.addSublayer(c1)
		
		for i in 0...numPercentagePoints {
			let pct = CGFloat(i) / CGFloat(numPercentagePoints)
			guard let p = pth1.point(at: pct) else {
				fatalError("could not get point at: \(i) / \(pct)")
			}
			percentagePoints1.append(p)
		}
		
		path = MyBezierPath(svgPath: "m 27.183494,30 c 1.799867,6.703167 5.73525,21.942548 19.10735,25.425821 C 62.18913,58.972955 71.676308,43.806518 56.324843,30 c 8.148778,-0.235038 16.297872,0.3043 24.444458,0")
		
		defaultTransform = CGAffineTransform(scaleX: 4, y: 4)
			.translatedBy(x: 10.0, y: 0.0)

		defaultTransform = .identity
		
		guard let pth2 = path.cgPath.copy(using: &defaultTransform) else { return }
		path2 = MyBezierPath(cgPath: pth2)
		
		print("p2 len:", path2.length)
		
		let c2 = CAShapeLayer()
		c2.strokeColor = dashColor
		c2.fillColor = UIColor.clear.cgColor
		c2.lineDashPattern = [8,8]
		c2.path = pth2
		
		dashLayers.append(c2)
		
		if let startPoint = path2.cgPath.points().first {
			let circulPath = UIBezierPath(arcCenter: CGPoint(x: startPoint.x , y: startPoint.y) , radius: 3.5, startAngle: 0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
			let circleLayer = CAShapeLayer()
			circleLayer.path = circulPath.cgPath
			circleLayer.fillColor = dashColor
			circleLayer.transform = CATransform3DMakeTranslation(0, 0, 0)
			c2.insertSublayer(circleLayer, at: 0)
		}
		
		secondLastPoint =  path2.cgPath.points().count>2 ?  path2.cgPath.points()[path2.cgPath.points().count-2] : path2.cgPath.points()[0]
		if let lastPoint = path2.cgPath.points().last {
			let angle = atan2((lastPoint.y - secondLastPoint.y), (lastPoint.x - secondLastPoint.x))
			let distance: CGFloat = 4.0
			let path = UIBezierPath()
			path.move(to: lastPoint)
			path.addLine(to: calculatePoint(from: lastPoint, angle: angle + CGFloat.pi/2, distance: distance)) // to the right
			path.addLine(to: calculatePoint(from: lastPoint, angle: angle, distance: distance)) // straight ahead
			path.addLine(to: calculatePoint(from: lastPoint, angle: angle - CGFloat.pi/2, distance: distance)) // to the left
			path.close()
			let  arrowHeadLayer = CAShapeLayer()
			arrowHeadLayer.path = path.cgPath
			arrowHeadLayer.lineWidth = 1
			arrowHeadLayer.strokeColor = dashColor
			arrowHeadLayer.fillColor = dashColor
			c2.insertSublayer(arrowHeadLayer, at: 1)
		}
		
		view.layer.addSublayer(c2)
		
		for i in 0...numPercentagePoints {
			let pct = CGFloat(i) / CGFloat(numPercentagePoints)
			guard let p = pth2.point(at: pct) else {
				fatalError("could not get point at: \(i) / \(pct)")
			}
			percentagePoints2.append(p)
		}
		
		defaultTransform = .identity
		var sp1 = path1.cgPath.copy(strokingWithWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: 0, transform: defaultTransform)
		var sp2 = path2.cgPath.copy(strokingWithWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: 0, transform: defaultTransform)
		if #available(iOS 16.0, *) {
			sp1 = path1.cgPath.copy(strokingWithWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: 0, transform: defaultTransform).normalized()
			sp2 = path2.cgPath.copy(strokingWithWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: 0, transform: defaultTransform).normalized()
		} else {
			// Fallback on earlier versions
		}
		
		if true {
			let c = CAShapeLayer()
			c.fillColor = hitColor
			c.strokeColor = c.fillColor
			c.path = sp1
			view.layer.insertSublayer(c, at: 0)
			stLayers.append(c)
		}
		if true {
			let c = CAShapeLayer()
			c.fillColor = hitColor
			c.strokeColor = c.fillColor
			c.path = sp2
			view.layer.insertSublayer(c, at: 0)
			stLayers.append(c)
		}
		
		
	}
	
	var percentagePoints1: [CGPoint] = []
	var percentagePoints2: [CGPoint] = []
	var numPercentagePoints: Int = 10
	
	var path1: MyBezierPath!
	var path2: MyBezierPath!
	
	let hitColor: CGColor = UIColor.darkGray.cgColor
	let dashColor: CGColor = UIColor.cyan.cgColor
	let userColor: CGColor = UIColor.systemGreen.withAlphaComponent(0.75).cgColor
	
	var step: Int = 0
	var pctEnd: CGFloat = 0.12
	var sqLayers1: [CAShapeLayer] = []
	var sqLayers2: [CAShapeLayer] = []
	var stLayers: [CAShapeLayer] = []
	var ptLayers: [CAShapeLayer] = []
	var dashLayers: [CAShapeLayer] = []
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		var c2: CAShapeLayer!
		var dPath: UIBezierPath!
		var r: CGRect!
		var d: CGFloat!
		
		print("step:", step)
		
		if step == 0 {
			
			c2 = CAShapeLayer()
			c2.fillColor = nil
			c2.strokeColor = userColor
			c2.lineWidth = 10
			c2.lineCap = .round
			c2.lineJoin = .round
			
			dPath = UserPath().path(1)
			c2.path = dPath.cgPath
			
			view.layer.addSublayer(c2)
			sqLayers1.append(c2)
			
			c2 = CAShapeLayer()
			c2.fillColor = nil
			c2.strokeColor = UIColor.green.cgColor
			c2.lineWidth = 1
			c2.lineCap = .round
			c2.lineJoin = .round
			c2.path = dPath.cgPath
			
			print("u1 len:", dPath.length)

			view.layer.addSublayer(c2)
			sqLayers2.append(c2)
			
			c2 = CAShapeLayer()
			c2.fillColor = nil
			c2.strokeColor = userColor
			c2.lineWidth = 10
			c2.lineCap = .round
			c2.lineJoin = .round
			
			dPath = UserPath().path(2)
			c2.path = dPath.cgPath
			
			print("u2 len:", dPath.length)
			
			view.layer.addSublayer(c2)
			sqLayers1.append(c2)
			
			c2 = CAShapeLayer()
			c2.fillColor = nil
			c2.strokeColor = UIColor.green.cgColor
			c2.lineWidth = 1
			c2.lineCap = .round
			c2.lineJoin = .round
			c2.path = dPath.cgPath
			
			view.layer.addSublayer(c2)
			sqLayers2.append(c2)
			
			for cc in sqLayers2 {
				cc.opacity = 0.0
			}
			
			step += 1
			return()
		}

		if step == 1 {
			for cc in sqLayers2 {
				cc.opacity = 1.0
			}
			
			step += 1
			return()
		}

//		if step == 2 {
//			dPath = UserPath().path(3)
//			sqLayers1[0].path = dPath.cgPath
//			sqLayers2[0].path = dPath.cgPath
//			return()
//		}
		
		if step == 2 {
			
			numPercentagePoints = 10
			
			percentagePoints1 = []
			for i in 0...numPercentagePoints {
				let pct = CGFloat(i) / CGFloat(numPercentagePoints)
				guard let p = path1.point(at: pct) else {
					fatalError("could not get point at: \(i) / \(pct)")
				}
				percentagePoints1.append(p)
			}
			
			percentagePoints2 = []
			for i in 0...numPercentagePoints {
				let pct = CGFloat(i) / CGFloat(numPercentagePoints)
				guard let p = path2.point(at: pct) else {
					fatalError("could not get point at: \(i) / \(pct)")
				}
				percentagePoints2.append(p)
			}
			
			c2 = CAShapeLayer()
			c2.strokeColor = UIColor.red.cgColor
			c2.fillColor = UIColor.yellow.cgColor
			c2.lineWidth = 2
			
			dPath = UIBezierPath()
			r = .init(x: 0, y: 0, width: 4, height: 4)
			d = r.width * 0.5
			for pt in percentagePoints1 {
				r.origin = .init(x: pt.x - d, y: pt.y - d)
				dPath.append(UIBezierPath(ovalIn: r))
			}
			c2.path = dPath.cgPath
			
			view.layer.addSublayer(c2)
			ptLayers.append(c2)

			c2 = CAShapeLayer()
			c2.strokeColor = UIColor.red.cgColor
			c2.fillColor = UIColor.yellow.cgColor
			c2.lineWidth = 2

			dPath = UIBezierPath()
			r = .init(x: 0, y: 0, width: 2, height: 2)
			d = r.width * 0.5
			for pt in percentagePoints2 {
				r.origin = .init(x: pt.x - d, y: pt.y - d)
				dPath.append(UIBezierPath(ovalIn: r))
			}
			c2.path = dPath.cgPath
			
			view.layer.addSublayer(c2)
			ptLayers.append(c2)

			for cc in sqLayers1 {
				cc.opacity = 0.0
				cc.strokeEnd = 0.0
			}
			for cc in sqLayers2 {
				cc.opacity = 0.0
				cc.strokeEnd = 0.0
			}

			step += 1
			
			pctEnd = 0.07
			
			return()

		}
		
		if step == 3 {
			for cc in sqLayers1 {
				cc.opacity = 1.0
				cc.strokeEnd = pctEnd
			}
			for cc in sqLayers2 {
				cc.opacity = 1.0
				cc.strokeEnd = pctEnd
			}
			pctEnd += 0.08

			if pctEnd >= 1.0 {
				print("start")
				step += 1
			}
			
			return()
		}
		
		if step == 4 {
			for cc in ptLayers {
				cc.opacity = 0.0
			}
			dragPoints = []
			let tmp: [(CGFloat, CGFloat)] = UserPath().pts1
			for i in 0..<(tmp.count / 2) {
				dragPoints.append(.init(x: tmp[i].0, y: tmp[i].1))
			}
			guard let t = touches.first else { return }
			var pt = t.location(in: self.view)
			pt.x = floor(pt.x)
			pt.y = floor(pt.y)
			dragPoints.append(pt)
			isDragging = true
			sqLayers1[0].strokeEnd = 1.0
			sqLayers2[0].strokeEnd = 1.0
			dragPath = UIBezierPath()
			dragPath.move(to: dragPoints.first!)
			for pt in dragPoints {
				dragPath.addLine(to: pt)
			}
		}

		if step == 44 {
			dragPoints = []
			guard let t = touches.first else { return }
			var pt = t.location(in: self.view)
			pt.x = floor(pt.x)
			pt.y = floor(pt.y)
			dragPoints.append(pt)
			isDragging = true
			sqLayers1[0].strokeEnd = 1.0
			sqLayers2[0].strokeEnd = 1.0
			dragPath = UIBezierPath()
			dragPath.move(to: dragPoints.first!)
		}
		
		if step == 5 {
			
			numPercentagePoints = 100
			
			percentagePoints1 = []
			for i in 0...numPercentagePoints {
				let pct = CGFloat(i) / CGFloat(numPercentagePoints)
				guard let p = path1.point(at: pct) else {
					fatalError("could not get point at: \(i) / \(pct)")
				}
				percentagePoints1.append(p)
			}
			
			percentagePoints2 = []
			for i in 0...numPercentagePoints {
				let pct = CGFloat(i) / CGFloat(numPercentagePoints)
				guard let p = path2.point(at: pct) else {
					fatalError("could not get point at: \(i) / \(pct)")
				}
				percentagePoints2.append(p)
			}
			
			dPath = UIBezierPath()
			r = .init(x: 0, y: 0, width: 2, height: 2)
			d = r.width * 0.5
			for pt in percentagePoints1 {
				r.origin = .init(x: pt.x - d, y: pt.y - d)
				dPath.append(UIBezierPath(ovalIn: r))
			}
			ptLayers[0].path = dPath.cgPath
			
			dPath = UIBezierPath()
			r = .init(x: 0, y: 0, width: 2, height: 2)
			d = r.width * 0.5
			for pt in percentagePoints2 {
				r.origin = .init(x: pt.x - d, y: pt.y - d)
				dPath.append(UIBezierPath(ovalIn: r))
			}
			ptLayers[1].path = dPath.cgPath

			for cc in dashLayers {
				cc.opacity = 0.0
			}
			for cc in sqLayers1 {
				cc.opacity = 0.0
			}
			for cc in sqLayers2 {
				cc.opacity = 0.0
			}
			for cc in ptLayers {
				cc.opacity = 1.0
				cc.lineWidth = 0
			}

			step += 1
			return()
			
		}
		

	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !isDragging { return }
		guard let t = touches.first else { return }
		var pt = t.location(in: self.view)
		pt.x = floor(pt.x)
		pt.y = floor(pt.y)
		dragPoints.append(pt)
		dragPath.addLine(to: dragPoints.last!)
		sqLayers1[0].path = dragPath.cgPath
		sqLayers2[0].path = dragPath.cgPath
		print("dp:", dragPath.length)
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !isDragging { return }
		guard let t = touches.first else { return }
		print(dragPoints)
		isDragging = false
		step += 1
	}
	
	var dragPath: UIBezierPath = UIBezierPath()
	var isDragging: Bool = false
	var dragPoints: [CGPoint] = []
	
	func calculatePoint(from point: CGPoint, angle: CGFloat, distance: CGFloat) -> CGPoint {
		return CGPoint(x: point.x + CGFloat(cosf(Float(angle))) * distance, y: point.y + CGFloat(sinf(Float(angle))) * distance)
	}
	
}


