//
//  ExplainViewController.swift
//  TracingApp
//
//  Created by Don Mag on 12/28/24.
//

import UIKit
import SwiftyDraw

class ExplainViewController: UIViewController {
	
	var percentagePoints1: [CGPoint] = []
	var percentagePoints2: [CGPoint] = []
	var numPercentagePoints: Int = 10
	
	var path1: MyBezierPath!
	var path2: MyBezierPath!
	
	let hitColor: CGColor = UIColor.darkGray.cgColor
	let dashColor: CGColor = UIColor.cyan.cgColor
	let userColor: CGColor = UIColor.systemGreen.withAlphaComponent(0.75).cgColor
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var path = MyBezierPath(svgPath: "m 27,30 H 100")
		
		var defaultTransform = CGAffineTransform(scaleX: 4, y: 4)
			.translatedBy(x: 10.0, y: -10.0)
		
		guard let pth1 = path.cgPath.copy(using: &defaultTransform) else { return }
		path1 = MyBezierPath(cgPath: pth1)
		
		print(path1.length)
		
		let c1 = CAShapeLayer()
		c1.strokeColor = dashColor
		c1.fillColor = UIColor.clear.cgColor
		c1.lineDashPattern = [8,8]
		c1.path = pth1
		
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

		guard let pth2 = path.cgPath.copy(using: &defaultTransform) else { return }
		path2 = MyBezierPath(cgPath: pth2)
		
		let c2 = CAShapeLayer()
		c2.strokeColor = dashColor
		c2.fillColor = UIColor.clear.cgColor
		c2.lineDashPattern = [8,8]
		c2.path = pth2
		
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
	
	var step: Int = 0
	var pctEnd: CGFloat = 0.12
	var sqLayers1: [CAShapeLayer] = []
	var sqLayers2: [CAShapeLayer] = []
	var stLayers: [CAShapeLayer] = []
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		var c2: CAShapeLayer!
		var dPath: UIBezierPath!
		var r: CGRect!
		var d: CGFloat!
		
		if step == 0 {
			
			var b: Bool = true
			
			numPercentagePoints = 42
			
			percentagePoints1 = []
			for i in 0...numPercentagePoints {
				let pct = CGFloat(i) / (CGFloat(numPercentagePoints) * 2.0)
				guard let p = path1.point(at: pct) else {
					fatalError("could not get point at: \(i) / \(pct)")
				}
				percentagePoints1.append(p)
			}
			
			percentagePoints2 = []
			for i in 0...numPercentagePoints {
				let pct = CGFloat(i) / (CGFloat(numPercentagePoints) * 2.0)
				guard let p = path2.point(at: pct) else {
					fatalError("could not get point at: \(i) / \(pct)")
				}
				percentagePoints2.append(p)
			}
			
			c2 = CAShapeLayer()
			c2.fillColor = nil
			c2.strokeColor = userColor
			c2.lineWidth = 10
			c2.lineCap = .round
			c2.lineJoin = .round
			
			dPath = UIBezierPath()
			dPath.move(to: percentagePoints1.removeFirst())
			while percentagePoints1.count > 0 {
				let pt = percentagePoints1.removeFirst()
				dPath.addLine(to: .init(x: pt.x, y: pt.y + (3 * (b ? 1.0 : -1.0))))
				b.toggle()
			}
			c2.path = dPath.cgPath
			c2.path = UserPath().p1().cgPath
			
			view.layer.addSublayer(c2)
			sqLayers1.append(c2)
			
			c2 = CAShapeLayer()
			c2.fillColor = nil
			c2.strokeColor = UIColor.yellow.cgColor
			c2.lineWidth = 1
			c2.lineCap = .round
			c2.lineJoin = .round
			c2.path = dPath.cgPath
			
			print(dPath.length)
			
			view.layer.addSublayer(c2)
			sqLayers2.append(c2)
			
			c2 = CAShapeLayer()
			c2.fillColor = nil
			c2.strokeColor = userColor
			c2.lineWidth = 10
			c2.lineCap = .round
			c2.lineJoin = .round
			
			dPath = UIBezierPath()
			dPath.move(to: percentagePoints2.removeFirst())
			while percentagePoints2.count > 0 {
				let pt = percentagePoints2.removeFirst()
				dPath.addLine(to: .init(x: pt.x, y: pt.y + (3 * (b ? 1.0 : -1.0))))
				b.toggle()
			}
			c2.path = dPath.cgPath
			
			view.layer.addSublayer(c2)
			sqLayers1.append(c2)
			
			c2 = CAShapeLayer()
			c2.fillColor = nil
			c2.strokeColor = UIColor.yellow.cgColor
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
			c2.fillColor = c2.strokeColor
			
			dPath = UIBezierPath()
			r = .init(x: 0, y: 0, width: 2, height: 2)
			d = r.width * 0.5
			for pt in percentagePoints1 {
				r.origin = .init(x: pt.x - d, y: pt.y - d)
				dPath.append(UIBezierPath(ovalIn: r))
			}
			c2.path = dPath.cgPath
			
			view.layer.addSublayer(c2)
			
			c2 = CAShapeLayer()
			c2.strokeColor = UIColor.red.cgColor
			c2.fillColor = c2.strokeColor
			
			dPath = UIBezierPath()
			r = .init(x: 0, y: 0, width: 2, height: 2)
			d = r.width * 0.5
			for pt in percentagePoints2 {
				r.origin = .init(x: pt.x - d, y: pt.y - d)
				dPath.append(UIBezierPath(ovalIn: r))
			}
			c2.path = dPath.cgPath
			
			view.layer.addSublayer(c2)

			step += 1
			return()

		}
		
		if step == 3 {
			for cc in sqLayers1 {
				cc.strokeEnd = pctEnd
			}
			for cc in sqLayers2 {
				cc.strokeEnd = pctEnd
			}
			pctEnd += 0.15

			step += 1
			return()
		}
		
		if step == 4 {
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
//		var pt = dragPoints.removeFirst()
//		print("thisPath.move(to: .init(x: \(pt.x), y: \(pt.y)))")
//		while !dragPoints.isEmpty {
//			pt = dragPoints.removeFirst()
//			print("thisPath.addLine(to: .init(x: \(pt.x), y: \(pt.y)))")
//		}
		isDragging = false
	}
	
	var dragPath: UIBezierPath = UIBezierPath()
	var isDragging: Bool = false
	var dragPoints: [CGPoint] = []
	
	func calculatePoint(from point: CGPoint, angle: CGFloat, distance: CGFloat) -> CGPoint {
		return CGPoint(x: point.x + CGFloat(cosf(Float(angle))) * distance, y: point.y + CGFloat(sinf(Float(angle))) * distance)
	}
	
}

class UserPath: NSObject {
	func p1() -> UIBezierPath {

		var x: CGFloat!
		var y: CGFloat!
		
		var pts: [(CGFloat, CGFloat)] = [(146.0, 79.0), (147.0, 79.0), (147.0, 79.0), (147.0, 78.0), (148.0, 78.0), (148.0, 78.0), (148.0, 78.0), (148.0, 78.0), (148.0, 77.0), (149.0, 77.0), (149.0, 77.0), (149.0, 77.0), (150.0, 77.0), (150.0, 77.0), (150.0, 77.0), (151.0, 77.0), (151.0, 77.0), (151.0, 77.0), (152.0, 77.0), (152.0, 77.0), (153.0, 77.0), (153.0, 77.0), (154.0, 77.0), (154.0, 77.0), (155.0, 77.0), (155.0, 77.0), (155.0, 77.0), (155.0, 77.0), (156.0, 77.0), (156.0, 78.0), (156.0, 78.0), (156.0, 78.0), (156.0, 78.0), (156.0, 78.0), (157.0, 79.0), (157.0, 79.0), (157.0, 79.0), (157.0, 80.0), (157.0, 80.0), (157.0, 80.0), (158.0, 80.0), (158.0, 80.0), (158.0, 80.0), (158.0, 81.0), (159.0, 81.0), (159.0, 81.0), (159.0, 81.0), (160.0, 81.0), (160.0, 81.0), (161.0, 81.0), (161.0, 81.0), (162.0, 81.0), (163.0, 81.0), (164.0, 80.0), (164.0, 80.0), (164.0, 80.0), (165.0, 80.0), (165.0, 80.0), (165.0, 80.0), (166.0, 79.0), (166.0, 79.0), (166.0, 79.0), (167.0, 79.0), (167.0, 78.0), (167.0, 78.0), (168.0, 78.0), (168.0, 78.0), (168.0, 78.0), (169.0, 78.0), (169.0, 78.0), (169.0, 78.0), (170.0, 78.0), (170.0, 78.0), (170.0, 78.0), (170.0, 78.0), (171.0, 78.0), (171.0, 79.0), (171.0, 79.0), (172.0, 79.0), (172.0, 80.0), (172.0, 80.0), (172.0, 80.0), (172.0, 80.0), (172.0, 81.0), (173.0, 81.0), (173.0, 81.0), (173.0, 81.0), (173.0, 82.0), (173.0, 82.0), (174.0, 82.0), (174.0, 82.0), (174.0, 82.0), (175.0, 82.0), (175.0, 82.0), (176.0, 81.0), (176.0, 81.0), (176.0, 81.0), (177.0, 81.0), (177.0, 81.0), (178.0, 81.0), (178.0, 80.0), (178.0, 80.0), (179.0, 80.0), (179.0, 80.0), (179.0, 79.0), (180.0, 79.0), (180.0, 79.0), (180.0, 79.0), (181.0, 78.0), (181.0, 78.0), (181.0, 78.0), (182.0, 78.0), (182.0, 78.0), (183.0, 78.0), (184.0, 79.0), (185.0, 79.0), (186.0, 79.0), (187.0, 79.0), (187.0, 79.0), (188.0, 79.0), (188.0, 79.0), (189.0, 79.0), (189.0, 80.0), (189.0, 80.0), (190.0, 80.0), (190.0, 80.0), (190.0, 81.0), (190.0, 81.0), (191.0, 81.0), (191.0, 81.0), (192.0, 81.0), (192.0, 82.0), (192.0, 82.0), (193.0, 82.0), (193.0, 82.0), (194.0, 82.0), (194.0, 82.0), (195.0, 82.0), (195.0, 82.0), (196.0, 82.0), (196.0, 82.0), (197.0, 82.0), (197.0, 82.0), (198.0, 82.0), (198.0, 82.0), (198.0, 81.0), (199.0, 81.0), (199.0, 81.0), (200.0, 81.0), (200.0, 80.0), (201.0, 80.0), (201.0, 79.0), (201.0, 79.0), (202.0, 79.0), (202.0, 79.0), (202.0, 79.0), (203.0, 79.0), (203.0, 78.0), (203.0, 78.0), (204.0, 78.0), (204.0, 78.0), (204.0, 78.0), (205.0, 78.0), (205.0, 78.0), (205.0, 78.0), (206.0, 78.0), (206.0, 79.0), (206.0, 79.0), (206.0, 79.0), (206.0, 79.0), (207.0, 79.0), (207.0, 79.0), (207.0, 80.0), (207.0, 80.0), (207.0, 80.0), (207.0, 81.0), (208.0, 81.0), (208.0, 81.0), (208.0, 81.0), (208.0, 82.0), (208.0, 82.0), (208.0, 82.0), (209.0, 82.0), (209.0, 82.0), (209.0, 82.0), (210.0, 82.0), (210.0, 82.0), (210.0, 82.0), (211.0, 82.0), (211.0, 82.0), (211.0, 82.0), (212.0, 82.0), (212.0, 82.0), (213.0, 82.0), (213.0, 82.0), (214.0, 82.0), (215.0, 82.0), (215.0, 81.0), (216.0, 81.0), (216.0, 81.0), (217.0, 81.0), (217.0, 80.0), (218.0, 80.0), (218.0, 80.0), (219.0, 80.0), (219.0, 79.0), (219.0, 79.0), (220.0, 79.0), (220.0, 79.0), (220.0, 79.0), (220.0, 79.0), (221.0, 79.0), (221.0, 78.0), (221.0, 78.0), (221.0, 78.0), (222.0, 78.0), (222.0, 78.0), (222.0, 78.0), (223.0, 78.0), (223.0, 79.0), (224.0, 79.0), (224.0, 79.0), (225.0, 79.0), (225.0, 80.0), (225.0, 80.0), (226.0, 80.0), (226.0, 80.0), (226.0, 80.0), (226.0, 81.0), (226.0, 81.0), (226.0, 81.0), (227.0, 81.0), (227.0, 82.0), (227.0, 82.0), (227.0, 82.0), (227.0, 82.0), (228.0, 82.0), (228.0, 82.0), (228.0, 83.0), (229.0, 83.0), (229.0, 83.0), (230.0, 83.0), (230.0, 83.0), (231.0, 83.0), (232.0, 83.0), (232.0, 83.0), (233.0, 83.0), (233.0, 83.0), (234.0, 82.0), (234.0, 82.0), (234.0, 82.0), (235.0, 82.0), (235.0, 81.0), (235.0, 81.0), (235.0, 81.0), (236.0, 81.0), (236.0, 80.0), (236.0, 80.0), (237.0, 80.0), (237.0, 79.0), (237.0, 79.0), (238.0, 79.0), (238.0, 78.0), (239.0, 78.0), (239.0, 78.0), (239.0, 78.0), (239.0, 78.0), (240.0, 78.0), (240.0, 78.0), (240.0, 78.0), (241.0, 78.0), (242.0, 78.0), (242.0, 78.0), (243.0, 78.0), (244.0, 78.0), (245.0, 78.0), (245.0, 78.0), (246.0, 78.0), (246.0, 79.0), (246.0, 79.0), (246.0, 79.0), (247.0, 79.0), (247.0, 80.0), (247.0, 80.0), (247.0, 80.0), (248.0, 81.0), (248.0, 81.0), (248.0, 81.0), (249.0, 81.0), (249.0, 82.0), (249.0, 82.0), (250.0, 82.0), (251.0, 82.0), (251.0, 82.0), (252.0, 82.0), (253.0, 82.0), (255.0, 82.0), (256.0, 82.0), (257.0, 82.0), (258.0, 82.0), (258.0, 82.0), (259.0, 82.0), (259.0, 82.0), (259.0, 81.0), (259.0, 81.0), (260.0, 81.0), (260.0, 81.0), (260.0, 80.0), (261.0, 80.0), (261.0, 79.0), (261.0, 79.0), (261.0, 79.0), (262.0, 79.0), (262.0, 79.0), (262.0, 79.0), (263.0, 79.0), (263.0, 79.0), (263.0, 79.0), (264.0, 79.0), (264.0, 79.0), (264.0, 79.0), (265.0, 79.0), (265.0, 79.0), (265.0, 79.0), (266.0, 79.0), (266.0, 79.0), (267.0, 79.0), (267.0, 79.0), (268.0, 79.0), (268.0, 79.0), (268.0, 79.0), (269.0, 79.0), (269.0, 80.0), (269.0, 80.0), (270.0, 80.0), (270.0, 81.0), (270.0, 81.0), (270.0, 81.0), (270.0, 82.0), (271.0, 82.0), (271.0, 82.0), (271.0, 83.0), (271.0, 83.0), (272.0, 83.0), (272.0, 83.0), (272.0, 83.0), (272.0, 83.0), (273.0, 83.0), (273.0, 83.0), (273.0, 83.0), (274.0, 83.0), (274.0, 83.0), (274.0, 83.0), (275.0, 83.0), (275.0, 83.0), (275.0, 83.0), (275.0, 83.0), (276.0, 83.0), (276.0, 83.0), (277.0, 82.0), (277.0, 82.0), (278.0, 82.0), (278.0, 82.0), (278.0, 81.0), (279.0, 81.0), (279.0, 81.0), (279.0, 81.0), (280.0, 80.0), (280.0, 80.0), (280.0, 80.0), (280.0, 80.0), (281.0, 79.0), (281.0, 79.0), (281.0, 79.0), (282.0, 79.0), (282.0, 79.0), (282.0, 79.0), (282.0, 79.0), (283.0, 79.0), (283.0, 78.0), (283.0, 78.0), (283.0, 78.0), (283.0, 78.0), (283.0, 77.0), (284.0, 77.0), (284.0, 77.0), (284.0, 77.0), (284.0, 77.0), (285.0, 77.0), (285.0, 77.0), (285.0, 77.0), (286.0, 77.0), (286.0, 77.0), (286.0, 77.0), (287.0, 77.0), (287.0, 77.0), (287.0, 77.0), (288.0, 77.0), (288.0, 77.0), (288.0, 77.0), (288.0, 77.0), (289.0, 77.0), (289.0, 77.0), (289.0, 77.0), (289.0, 77.0), (290.0, 77.0), (290.0, 78.0), (290.0, 78.0), (290.0, 78.0), (290.0, 78.0), (290.0, 79.0), (290.0, 79.0), (290.0, 79.0), (290.0, 79.0), (291.0, 80.0), (291.0, 80.0), (291.0, 80.0), (291.0, 80.0), (292.0, 80.0), (292.0, 80.0), (292.0, 80.0), (292.0, 80.0), (292.0, 81.0), (293.0, 81.0), (293.0, 81.0), (293.0, 81.0), (294.0, 81.0), (294.0, 81.0), (294.0, 81.0), (294.0, 81.0), (295.0, 81.0), (295.0, 81.0), (295.0, 81.0), (296.0, 81.0), (296.0, 81.0), (296.0, 81.0), (296.0, 81.0), (297.0, 80.0), (297.0, 80.0), (297.0, 80.0), (298.0, 80.0), (298.0, 79.0), (298.0, 79.0), (298.0, 79.0), (299.0, 78.0), (299.0, 78.0), (300.0, 78.0), (300.0, 78.0), (300.0, 78.0), (300.0, 77.0), (301.0, 77.0), (301.0, 77.0), (301.0, 77.0), (302.0, 77.0), (302.0, 77.0), (302.0, 77.0), (302.0, 78.0), (303.0, 78.0), (303.0, 78.0), (303.0, 78.0), (304.0, 78.0), (304.0, 78.0), (304.0, 78.0), (304.0, 79.0), (304.0, 79.0), (305.0, 79.0), (305.0, 80.0), (305.0, 80.0), (305.0, 80.0), (305.0, 80.0), (305.0, 80.0), (305.0, 81.0), (306.0, 81.0), (306.0, 81.0), (306.0, 81.0), (306.0, 82.0), (306.0, 82.0), (306.0, 82.0), (307.0, 82.0), (307.0, 82.0), (307.0, 82.0), (308.0, 82.0), (308.0, 82.0), (308.0, 82.0), (309.0, 82.0), (309.0, 82.0), (309.0, 82.0), (310.0, 82.0), (310.0, 82.0), (310.0, 82.0), (311.0, 82.0), (311.0, 82.0), (311.0, 82.0), (312.0, 82.0), (312.0, 82.0), (312.0, 81.0), (312.0, 81.0), (312.0, 81.0), (313.0, 81.0), (313.0, 81.0), (313.0, 81.0), (313.0, 80.0), (313.0, 80.0), (313.0, 80.0), (314.0, 80.0), (314.0, 79.0), (314.0, 79.0), (314.0, 79.0), (314.0, 79.0), (314.0, 78.0), (315.0, 78.0), (315.0, 78.0), (315.0, 78.0), (315.0, 78.0), (316.0, 78.0), (316.0, 78.0), (316.0, 78.0), (317.0, 78.0), (317.0, 77.0), (317.0, 77.0), (317.0, 77.0), (318.0, 77.0), (318.0, 77.0), (318.0, 77.0), (319.0, 78.0), (319.0, 78.0), (319.0, 78.0), (319.0, 78.0), (320.0, 78.0), (320.0, 78.0), (320.0, 78.0), (320.0, 79.0), (320.0, 79.0), (320.0, 79.0), (320.0, 80.0), (321.0, 80.0), (321.0, 80.0), (321.0, 80.0), (321.0, 81.0), (321.0, 81.0), (321.0, 81.0), (322.0, 81.0), (322.0, 81.0), (322.0, 81.0), (322.0, 82.0), (323.0, 82.0), (323.0, 82.0), (323.0, 82.0), (324.0, 82.0), (324.0, 82.0), (324.0, 82.0), (325.0, 82.0), (325.0, 82.0), (325.0, 82.0), (326.0, 82.0), (326.0, 82.0), (326.0, 81.0), (326.0, 81.0), (326.0, 81.0), (327.0, 81.0), (327.0, 81.0), (327.0, 81.0), (327.0, 80.0), (327.0, 80.0), (327.0, 80.0), (328.0, 80.0), (328.0, 79.0), (328.0, 79.0), (329.0, 79.0), (329.0, 79.0), (329.0, 79.0), (329.0, 79.0), (330.0, 78.0), (330.0, 78.0), (330.0, 78.0), (331.0, 78.0), (331.0, 78.0), (331.0, 78.0), (331.0, 78.0), (332.0, 78.0), (332.0, 78.0), (332.0, 78.0), (332.0, 78.0), (333.0, 78.0), (333.0, 78.0), (333.0, 78.0), (333.0, 77.0), (334.0, 77.0), (334.0, 78.0), (334.0, 78.0), (334.0, 78.0), (334.0, 78.0), (334.0, 78.0), (335.0, 79.0), (335.0, 79.0), (335.0, 79.0), (335.0, 79.0), (335.0, 80.0), (335.0, 80.0), (335.0, 80.0), (336.0, 80.0), (336.0, 81.0), (336.0, 81.0), (336.0, 81.0), (336.0, 81.0), (336.0, 81.0), (336.0, 82.0), (337.0, 82.0), (337.0, 82.0), (337.0, 82.0), (337.0, 82.0), (338.0, 82.0), (338.0, 82.0), (338.0, 82.0), (338.0, 82.0), (339.0, 82.0), (339.0, 82.0), (339.0, 82.0), (340.0, 82.0), (340.0, 82.0), (340.0, 82.0), (340.0, 82.0), (340.0, 81.0), (341.0, 81.0), (341.0, 81.0), (341.0, 81.0), (341.0, 81.0), (341.0, 80.0), (342.0, 80.0), (342.0, 80.0), (342.0, 80.0), (342.0, 79.0), (342.0, 79.0), (343.0, 79.0), (343.0, 79.0), (343.0, 79.0), (344.0, 79.0), (344.0, 78.0), (345.0, 78.0), (345.0, 78.0), (345.0, 78.0), (346.0, 78.0), (346.0, 78.0), (346.0, 78.0), (347.0, 78.0), (347.0, 78.0), (347.0, 79.0), (347.0, 79.0), (347.0, 79.0), (348.0, 79.0), (348.0, 80.0)]
		
		let thisPath = UIBezierPath()

		(x, y) = pts.removeFirst()
		thisPath.move(to: .init(x: x, y: y))
		while !pts.isEmpty {
			(x, y) = pts.removeFirst()
			thisPath.addLine(to: .init(x: x, y: y))
		}
		return thisPath
	}
}
