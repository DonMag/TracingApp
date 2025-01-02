//
//  TMPViewController.swift
//  TracingApp
//
//  Created by Don Mag on 1/2/25.
//

import UIKit

class TMPViewController: UIViewController {
/*
	var accentColor = UIColor(hex: "00acc1").withAlphaComponent(0.75)
	let canvasView = UIView()
	var strokePathsArray = [MyBezierPath]()
	var strokeIndex: Int = 0
	var currentPathToTrace : CGPath!
	var defaultTransform  = CGAffineTransform()
	
	let hitColor: CGColor = UIColor.darkGray.cgColor
	let dashColor: CGColor = UIColor.cyan.cgColor
	let userColor: CGColor = UIColor.systemGreen.withAlphaComponent(0.75).cgColor
	let userLineColor: CGColor = UIColor.yellow.cgColor
	
	var step: Int = 0
	var pctEnd: CGFloat = 0.12
	var sqLayers1: [CAShapeLayer] = []
	var sqLayers2: [CAShapeLayer] = []
	var stLayers: [CAShapeLayer] = []
	var ptLayers: [CAShapeLayer] = []
	var shapeLayers: [CAShapeLayer] = []
	var dashLayers: [CAShapeLayer] = []
	var assitedLayers: [CAShapeLayer] = []
	var userPaths: [MyBezierPath] = []
	var dPath: MyBezierPath!
	var traceLength: CGFloat = 0
	
	var numPointsOnPath: Int = 10
	var nextNum: Int = 10
	var pointsAlongPath: [[CGPoint]] = []
	
	var drawLayers: [CAShapeLayer]!
	var traceLayer: CAShapeLayer!
	var closeLayer: CAShapeLayer!
	let imgView: UIImageView = UIImageView()
	var isDrawing: Int = 0
	var isTracing: Bool = false
	var showClosest: Bool = false
	var showAssist: Bool = false
	var tracingIDX: Int = -1
	var maxIDX: Int = 0
	let infoLabel: UILabel = UILabel()
	
	var pathToShow: Int = 0
	var isShowingPaths: Bool = false
	
	lazy var targetView: UIView = {
		let sTargetView =  UIView(frame: CGRect(x: 0,
												y: 0,
												width: self.view.frame.height/1.3,
												height: self.view.frame.height/1.3))
		sTargetView.center = CGPoint(x: UIScreen.main.bounds.size.width/2,
									 y: UIScreen.main.bounds.size.height/2)
		sTargetView.backgroundColor = .clear
		sTargetView.isUserInteractionEnabled = true
		
		
		canvasView.isUserInteractionEnabled = true
		canvasView.backgroundColor = .clear
		sTargetView.addSubview(canvasView)
		canvasView.frame = sTargetView.bounds
		
		return sTargetView
	}()
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print("touch")
		//canvasView.undo()
		
		var r: CGRect!
		var d: CGFloat!
		
		print("step:", step)
		
		maxIDX = 0
		
		guard let t = touches.first else { return }
		let p: CGPoint = t.location(in: self.view)
		let dp: CGPoint = p
		
		if step == 0 {
			dPath = MyBezierPath()
			dPath.move(to: p)
			
			traceLength = userPaths[0].length
			infoLabel.text = "Trace Len: \(Int(traceLength))  User Len: 0"
			infoLabel.isHidden = false
			isDrawing = 1
			
			imgView.frame.origin = dp
		}
		
		if step == 1 {
			dPath = MyBezierPath()
			dPath.move(to: p)
			
			for cc in drawLayers {
				cc.path = dPath.cgPath
			}
			
			infoLabel.text = "Trace Len: \(Int(traceLength))  User Len: 0"
			
			imgView.frame.origin = dp
		}
		
		if step == 2 {
			
			dPath = MyBezierPath()
			dPath.move(to: p)
			
			for cc in drawLayers {
				cc.path = dPath.cgPath
			}
			drawLayers[0].opacity = 0.0
			
			//tracingIDX = 0
			closeLayer.opacity = 1.0
			
			infoLabel.text = "Trace Len: \(Int(traceLength))  User Len: 0"
			
			imgView.frame.origin = dp
			
			assitedLayers[0].opacity = 1.0
			assitedLayers[0].strokeEnd = 0.0
			
			showAssist = true
			
			print("2")
			return()
		}
		
		if step == 3 {
			for cc in drawLayers {
				cc.path = nil
				cc.opacity = 0.0
			}
			for cc in assitedLayers {
				cc.strokeEnd = 0.0
				cc.opacity = 0.0
			}
			
			infoLabel.text = "calculate 10 points"
			
			pointsAlongPath = []
			
			numPointsOnPath = 10
			
			for (i, pth) in strokePathsArray.enumerated() {
				let cpth = pth.cgPath.copy(using: &defaultTransform)!
				var pctPoints: [CGPoint] = []
				for i in 0...numPointsOnPath {
					let pct = CGFloat(i) / CGFloat(numPointsOnPath)
					guard let p = cpth.point(at: pct) else {
						fatalError("could not get point at: \(i) / \(pct)")
					}
					pctPoints.append(p)
				}
				pointsAlongPath.append(pctPoints)
				
				let dPath = UIBezierPath()
				r = .init(x: 0, y: 0, width: 4, height: 4)
				d = r.width * 0.5
				for pt in pctPoints {
					r.origin = .init(x: pt.x - d, y: pt.y - d)
					dPath.append(UIBezierPath(ovalIn: r))
				}
				ptLayers[i].path = dPath.cgPath
				ptLayers[i].opacity = i == 0 ? 1.0 : 0.0
			}
			
			tracingIDX = 0
			//assitedLayers[tracingIDX].opacity = 1.0
			closeLayer.opacity = 1.0
			showClosest = true
			print("3")
			return()
		}
		
		if step == 4 {
			infoLabel.text = "Closest: 0  Pct: 0%"
			infoLabel.isHidden = false
			print("start")
			isTracing = true
			closeLayer.opacity = 1.0
			
			dPath = MyBezierPath()
			dPath.move(to: p)
			
			for cc in drawLayers {
				cc.opacity = 0.0
				cc.path = dPath.cgPath
			}
			
			tracingIDX = 0
			//assitedLayers[tracingIDX].opacity = 1.0
			closeLayer.opacity = 1.0
			
			return()
		}
		
		if step == 5 {
			infoLabel.text = "Closest: 0  Pct: 0%"
			infoLabel.isHidden = false
			print("start")
			isTracing = true
			
			CATransaction.begin()
			CATransaction.setDisableActions(true)
			
			dPath = MyBezierPath()
			dPath.move(to: p)
			
			for cc in drawLayers {
				cc.opacity = 0.0
				cc.path = dPath.cgPath
			}
			tracingIDX = 0
			assitedLayers[tracingIDX].strokeEnd = 0.0
			assitedLayers[tracingIDX].opacity = 1.0
			closeLayer.opacity = 1.0
			CATransaction.commit()
			
			return()
		}
		if step == 6 {
			print("using Max")
			return()
		}
		
		if step == 7 {
			infoLabel.text = "calculate 100 points"
			
			numPointsOnPath = 100
			pointsAlongPath = []
			
			CATransaction.begin()
			CATransaction.setDisableActions(true)
			
			for (i, pth) in strokePathsArray.enumerated() {
				let cpth = pth.cgPath.copy(using: &defaultTransform)!
				var pctPoints: [CGPoint] = []
				for i in 0...numPointsOnPath {
					let pct = CGFloat(i) / CGFloat(numPointsOnPath)
					guard let p = cpth.point(at: pct) else {
						fatalError("could not get point at: \(i) / \(pct)")
					}
					pctPoints.append(p)
				}
				pointsAlongPath.append(pctPoints)
				
				let dPath = UIBezierPath()
				r = .init(x: 0, y: 0, width: 2, height: 2)
				d = r.width * 0.5
				for pt in pctPoints {
					r.origin = .init(x: pt.x - d, y: pt.y - d)
					dPath.append(UIBezierPath(ovalIn: r))
				}
				ptLayers[i].path = dPath.cgPath
				ptLayers[i].lineWidth = 0
			}
			
			for cc in assitedLayers {
				cc.strokeEnd = 0.0
				cc.opacity = 1.0
			}
			CATransaction.commit()
			
			return()
		}
		
		if step == 8 {
			print("assited with 100")
			return()
		}
		
		
		if step == 9 {
			isDrawing = 0
			isTracing = false
			
			for cc in ptLayers {
				cc.opacity = 0.0
			}
			for cc in dashLayers {
				cc.opacity = 0.0
			}
			for cc in shapeLayers {
				cc.opacity = 1.0
			}
			for cc in assitedLayers {
				cc.strokeEnd = 0.0
				cc.opacity = 1.0
			}
			
			infoLabel.text = "calculate \(nextNum) points"
			
			pointsAlongPath = []
			
			numPointsOnPath = nextNum
			
			showClosest = numPointsOnPath == 10
			closeLayer.opacity = showClosest ? 1.0 : 0.0
			
			for (i, pth) in strokePathsArray.enumerated() {
				let cpth = pth.cgPath.copy(using: &defaultTransform)!
				var pctPoints: [CGPoint] = []
				for i in 0...numPointsOnPath {
					let pct = CGFloat(i) / CGFloat(numPointsOnPath)
					guard let p = cpth.point(at: pct) else {
						fatalError("could not get point at: \(i) / \(pct)")
					}
					pctPoints.append(p)
				}
				pointsAlongPath.append(pctPoints)
				
				let dPath = UIBezierPath()
				r = .init(x: 0, y: 0, width: 4, height: 4)
				d = r.width * 0.5
				for pt in pctPoints {
					r.origin = .init(x: pt.x - d, y: pt.y - d)
					dPath.append(UIBezierPath(ovalIn: r))
				}
				ptLayers[i].path = dPath.cgPath
				ptLayers[i].lineWidth = numPointsOnPath == 10 ? 1.0 : 0.0
			}
			
			tracingIDX = -1
			pathToShow = 0
			
			step += 1
			return()
		}
		
		if step == 10 {
			maxIDX = 0
			for i in 0..<shapeLayers.count {
				dashLayers[i].opacity = i == pathToShow ? 1.0 : 0.0
			}
			tracingIDX += 1
			traceLayer.path = dashLayers[tracingIDX].path
			step += 1
			if numPointsOnPath == 100 {
				step += 1
			}
			return()
		}
		if step == 11 {
			for i in 0..<shapeLayers.count {
				ptLayers[i].opacity = i == pathToShow ? 1.0 : 0.0
			}
			step += 1
			return()
		}
		if step == 12 {
			maxIDX = 0
			isTracing = true
			step += 1
			return()
		}
		if step == 13 {
			pathToShow += 1
			for cc in ptLayers {
				cc.opacity = 0.0
			}
			for cc in dashLayers {
				cc.opacity = 0.0
			}
			if pathToShow < shapeLayers.count {
				step = 10
			} else {
				step += 1
			}
			return()
		}
		if step == 14 {
			nextNum = 100
			step = 9
			return()
		}
	}
	
	var lastPCT: CGFloat = 0.0
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		guard let t = touches.first else { return }
		let p: CGPoint = t.location(in: self.view)
		let dp: CGPoint = p
		
		if isShowingPaths {
			return()
		}
		
		imgView.isHidden = false
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		if isDrawing == 1 {
			dPath.addLine(to: p)
			imgView.frame.origin = dp
			for cc in drawLayers {
				cc.path = dPath.cgPath
			}
			if !showClosest {
				infoLabel.text = "Trace Len: \(Int(traceLength))  User Len: \(Int(dPath.length))"
			}
			if showAssist {
				let pct = dPath.length / traceLength
				if lastPCT != pct {
					lastPCT = pct
					assitedLayers[0].strokeEnd = pct
				}
			}
		}
		CATransaction.commit()
		
		if tracingIDX == -1 || tracingIDX > assitedLayers.count - 1 { return }
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if let pIDX = findClosestPointIndex(to: p, in: pointsAlongPath[tracingIDX]) {
			if step > 5 {
				maxIDX = max(maxIDX, pIDX)
			} else {
				maxIDX = pIDX
			}
			var pp = pointsAlongPath[tracingIDX][pIDX]
			if numPointsOnPath == 100 {
				pp.x += 0.5
			}
			let cPath = UIBezierPath()
			cPath.move(to: .init(x: dp.x + 1, y: dp.y))
			cPath.addLine(to: pp)
			closeLayer.path = cPath.cgPath
			let pct = CGFloat(maxIDX) / CGFloat(numPointsOnPath)
			if lastPCT != pct {
				assitedLayers[tracingIDX].strokeEnd = CGFloat(maxIDX) / CGFloat(numPointsOnPath)
			}
			let spct = String(format: "%0.0f", (CGFloat(maxIDX) / CGFloat(numPointsOnPath)) * 100.0)
			if step > 5 {
				infoLabel.text = "Closest: \(pIDX)  Max: \(maxIDX)  Pct: \(spct)%"
			} else {
				infoLabel.text = "Closest: \(pIDX)  Pct: \(spct)%"
			}
		}
		CATransaction.commit()
		imgView.frame.origin = dp
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		print("touch ended")
		closeLayer.path = nil
		lastPCT = 0.0
		imgView.isHidden = true
		
		if isShowingPaths {
			return()
		}
		
		if isDrawing == 1 {
			imgView.frame.origin = .zero
			step += 1
			return()
		}
		
		if !isTracing { return }
		
		if maxIDX < numPointsOnPath {
			maxIDX = 0
			imgView.frame.origin = .zero
			return()
		}
		
		infoLabel.text = "Closest: 0  Max: 0  Pct: 0%"
		imgView.frame.origin = .zero
		closeLayer.path = nil
		for (i, cc) in dashLayers.enumerated() {
			cc.opacity = i == tracingIDX ? 1.0 : 0.0
		}
		
		if tracingIDX > assitedLayers.count - 1 {
			infoLabel.isHidden = true
			tracingIDX = -1
			step += 1
			return()
		}
		assitedLayers[tracingIDX].opacity = 1.0
		traceLayer.path = dashLayers[tracingIDX].path
		maxIDX = 0
	}
	// find the CGPoint in array of CGPoint, closest to target CGPoint
	func findClosestPointIndex(to target: CGPoint, in points: [CGPoint]) -> Int? {
		guard !points.isEmpty else { return nil }
		return points.enumerated().min(by: { $0.element.distance(to: target) < $1.element.distance(to: target) })?.offset
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemYellow
		view.backgroundColor = UIColor(hex: "88AAFF")
		self.view.addSubview(targetView)
		
		var path: MyBezierPath!
		
		path = MyBezierPath(svgPath: "m 17.899207,12.838052 c 24.277086,0 48.554171,0 72.831257,0")
		
		strokePathsArray.append(path)
		
		path = MyBezierPath(svgPath: "M 81.707208,12.894524 C 81.560683,44.598905 71.417523,97.40583 45.542397,94.433749")
		
		strokePathsArray.append(path)
		
		path = MyBezierPath(svgPath: "m 27.183494,30 c 1.799867,6.703167 5.73525,21.942548 19.10735,25.425821 C 62.18913,58.972955 71.676308,43.806518 56.324843,30 c 8.148778,-0.235038 16.297872,0.3043 24.444458,0")
		
		strokePathsArray.append(path)
		
		defaultTransform = CGAffineTransform(scaleX: self.targetView.frame.width/109, y: self.targetView.frame.width/109)
		
		for pth in strokePathsArray {
			let shapeLayer = CAShapeLayer()
			shapeLayer.backgroundColor = UIColor.cyan.cgColor
			
			shapeLayer.transform = CATransform3DMakeAffineTransform(defaultTransform)
			
			shapeLayer.path = pth.cgPath
			shapeLayer.fillColor = UIColor.clear.cgColor
			shapeLayer.lineWidth = 10
			shapeLayer.lineCap = .round
			shapeLayer.strokeColor = UIColor.white.cgColor
			self.targetView.layer.insertSublayer(shapeLayer, at: 0)
			shapeLayers.append(shapeLayer)
			
			let dashLayer = CAShapeLayer()
			dashLayer.path = pth.cgPath
			dashLayer.fillColor = UIColor.clear.cgColor
			dashLayer.lineDashPattern =  [2,2]
			
			dashLayer.transform = CATransform3DMakeAffineTransform(defaultTransform)
			dashLayer.strokeColor = UIColor(hex: "f06292").cgColor
			dashLayer.lineWidth = 0.5
			
			// don't use a stroked-path
			//self.currentPathToTrace =   path.cgPath.copy(strokingWithWidth: 0, lineCap: .round, lineJoin: .miter, miterLimit: 0, transform: defaultTransform)
			self.currentPathToTrace = pth.cgPath.copy(using: &defaultTransform)
			
			print("cp:", currentPathToTrace.length)
			
			if let startPoint = pth.startPoint {
				let circulPath = UIBezierPath(arcCenter: CGPoint(x: startPoint.x , y: startPoint.y) , radius: 1.5, startAngle: 0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
				let circleLayer = CAShapeLayer()
				circleLayer.path = circulPath.cgPath
				circleLayer.fillColor = UIColor(hex: "f06292").cgColor
				circleLayer.transform = CATransform3DMakeTranslation(0, 0, 0)
				dashLayer.insertSublayer(circleLayer, at: 0)
			}
			let secondLastPoint = pth.cgPath.points().count>2 ?  pth.cgPath.points()[pth.cgPath.points().count-2] : pth.cgPath.points()[0]
			if let lastPoint = pth.cgPath.points().last {
				let angle = atan2((lastPoint.y - secondLastPoint.y), (lastPoint.x - secondLastPoint.x))
				let distance: CGFloat = 1.0
				let path = UIBezierPath()
				path.move(to: lastPoint)
				path.addLine(to: calculatePoint(from: lastPoint, angle: angle + CGFloat.pi/2, distance: distance)) // to the right
				path.addLine(to: calculatePoint(from: lastPoint, angle: angle, distance: distance)) // straight ahead
				path.addLine(to: calculatePoint(from: lastPoint, angle: angle - CGFloat.pi/2, distance: distance)) // to the left
				path.close()
				let  arrowHeadLayer = CAShapeLayer()
				arrowHeadLayer.path = path.cgPath
				arrowHeadLayer.lineWidth = 1
				arrowHeadLayer.strokeColor = UIColor(hex: "f06292").cgColor
				arrowHeadLayer.fillColor = UIColor.white.cgColor
				dashLayer.insertSublayer(arrowHeadLayer, at: 1)
			}
			self.targetView.layer.addSublayer(dashLayer)
			dashLayers.append(dashLayer)
			
			let aLayer = CAShapeLayer()
			aLayer.path = pth.cgPath
			aLayer.fillColor = UIColor.clear.cgColor
			
			aLayer.transform = CATransform3DMakeAffineTransform(defaultTransform)
			aLayer.strokeColor = accentColor.cgColor
			aLayer.lineWidth = 6
			aLayer.lineCap = .round
			aLayer.opacity = 0.0
			aLayer.strokeEnd = 0.0
			
			self.targetView.layer.addSublayer(aLayer)
			assitedLayers.append(aLayer)
			
		}
		for i in 1...strokePathsArray.count {
			//			let uPth = UserPath().path(i)
			//			userPaths.append(MyBezierPath(cgPath: uPth.cgPath))
			
			var c2: CAShapeLayer!
			
			c2 = CAShapeLayer()
			c2.strokeColor = UIColor.systemRed.cgColor
			c2.fillColor = UIColor.systemRed.cgColor
			c2.lineWidth = 1
			self.targetView.layer.addSublayer(c2)
			ptLayers.append(c2)
			
			c2 = CAShapeLayer()
			c2.fillColor = nil
			c2.strokeColor = userColor
			c2.lineWidth = 10
			c2.lineCap = .round
			c2.lineJoin = .round
			c2.path = uPth.cgPath
			self.targetView.layer.addSublayer(c2)
			sqLayers1.append(c2)
			
			c2 = CAShapeLayer()
			c2.fillColor = nil
			c2.strokeColor = userLineColor
			c2.lineWidth = 1
			c2.lineCap = .round
			c2.lineJoin = .round
			c2.path = uPth.cgPath
			self.targetView.layer.addSublayer(c2)
			sqLayers2.append(c2)
		}
		
		traceLayer = CAShapeLayer()
		traceLayer.fillColor = UIColor.clear.cgColor
		traceLayer.lineDashPattern =  [2,2]
		
		traceLayer.transform = CATransform3DMakeAffineTransform(defaultTransform)
		traceLayer.strokeColor = UIColor(hex: "f06292").cgColor
		traceLayer.lineWidth = 0.5
		
		traceLayer.path = dashLayers[0].path
		view.layer.addSublayer(traceLayer)
		
		closeLayer = CAShapeLayer()
		closeLayer.fillColor = UIColor.clear.cgColor
		closeLayer.strokeColor = UIColor.black.cgColor
		closeLayer.opacity = 0.0
		view.layer.addSublayer(closeLayer)
		targetView.layer.addSublayer(closeLayer)
		
		if let img = UIImage(named: "pen") {
			imgView.image = img
			imgView.frame = .init(x: 0, y: 0, width: img.size.width, height: img.size.height)
		}
		view.addSubview(imgView)
		targetView.addSubview(imgView)
		imgView.isHidden = true
		
		for cc in sqLayers1 {
			cc.opacity = 0.0
		}
		for cc in sqLayers2 {
			cc.opacity = 0.0
		}
		for cc in dashLayers {
			cc.strokeColor = UIColor.blue.cgColor
			for ccc in cc.sublayers! {
				if let ccc = ccc as? CAShapeLayer {
					ccc.strokeColor = cc.strokeColor
					ccc.fillColor = cc.strokeColor
				}
			}
		}
		
		targetView.frame = targetView.frame.offsetBy(dx: 100, dy: 0)
		
		infoLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(infoLabel)
		NSLayoutConstraint.activate([
			infoLabel.leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: 0.0),
			infoLabel.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: 0.0),
			infoLabel.bottomAnchor.constraint(equalTo: targetView.topAnchor, constant: 12.0),
		])
		infoLabel.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		infoLabel.font = .systemFont(ofSize: 14.0, weight: .light)
		infoLabel.font = .monospacedSystemFont(ofSize: 14.0, weight: .light)
		infoLabel.textAlignment = .center
		infoLabel.text = " "
		//infoLabel.isHidden = true
		
		drawLayers = []
		var drawLayer = CAShapeLayer()
		drawLayer.fillColor = UIColor.clear.cgColor
		drawLayer.strokeColor = userColor
		drawLayer.lineWidth = 10
		drawLayer.lineCap = .round
		drawLayer.lineJoin = .round
		self.targetView.layer.addSublayer(drawLayer)
		drawLayers.append(drawLayer)
		
		drawLayer = CAShapeLayer()
		drawLayer.fillColor = nil
		drawLayer.strokeColor = userLineColor
		drawLayer.lineWidth = 1
		drawLayer.lineCap = .round
		drawLayer.lineJoin = .round
		self.targetView.layer.addSublayer(drawLayer)
		drawLayers.append(drawLayer)
		
		for cc in shapeLayers {
			cc.opacity = 0.0
		}
		for cc in dashLayers {
			cc.opacity = 0.0
		}
		for cc in ptLayers {
			cc.opacity = 0.0
		}
		shapeLayers[0].opacity = 1.0
		dashLayers[0].opacity = 1.0
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		traceLength = userPaths[0].length
		infoLabel.text = "Trace Len: \(Int(traceLength))  User Len: 0"
	}
	
	func calculatePoint(from point: CGPoint, angle: CGFloat, distance: CGFloat) -> CGPoint {
		return CGPoint(x: point.x + CGFloat(cosf(Float(angle))) * distance, y: point.y + CGFloat(sinf(Float(angle))) * distance)
	}
	
	*/
}

