//
//  TmpViewController.swift
//  TracingApp
//
//  Created by Don Mag on 12/31/24.
//

import UIKit
import SwiftyDraw

class TmpViewController: UIViewController, SwiftyDrawViewDelegate {

	var accentColor = UIColor(hex: "00acc1").withAlphaComponent(0.75)
	let canvasView = SwiftyDrawView()
	var strokePathsArray = [MyBezierPath]()
	var strokeIndex: Int = 0
	//var dashLayer: CAShapeLayer = CAShapeLayer()
	var currentPathToTrace : CGPath!
	var defaultTransform  = CGAffineTransform()

	let hitColor: CGColor = UIColor.darkGray.cgColor
	let dashColor: CGColor = UIColor.cyan.cgColor
	let userColor: CGColor = UIColor.systemGreen.withAlphaComponent(0.75).cgColor
	let userLineColor: CGColor = UIColor.green.cgColor
	
	var step: Int = 0
	var pctEnd: CGFloat = 0.12
	var sqLayers1: [CAShapeLayer] = []
	var sqLayers2: [CAShapeLayer] = []
	var stLayers: [CAShapeLayer] = []
	var ptLayers: [CAShapeLayer] = []
	var dashLayers: [CAShapeLayer] = []
	var assitedLayers: [CAShapeLayer] = []
	var userPaths: [MyBezierPath] = []
	
	var numPercentagePoints: Int = 10
	var percentagePoints: [[CGPoint]] = []

	var traceLayer: CAShapeLayer!
	var closeLayer: CAShapeLayer!
	let imgView: UIImageView = UIImageView()
	var isTracing: Bool = false
	var tracingIDX: Int = -1
	var maxIDX: Int = 0
	let infoLabel: UILabel = UILabel()
	
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
		canvasView.brush = .thick
		canvasView.brush.color =  Color.init(self.accentColor)
		canvasView.frame = sTargetView.bounds
		canvasView.delegate = self
		
		return sTargetView
	}()

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print("touch")
		//canvasView.undo()
		
		var c2: CAShapeLayer!
		var dPath: MyBezierPath!
		var r: CGRect!
		var d: CGFloat!
		
		print("step:", step)
		
		if step == 0 {
			for cc in sqLayers1 {
				cc.opacity = 1.0
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
			
			let pth = UserPath().path(4)
			sqLayers1[0].path = pth.cgPath
			sqLayers2[0].path = pth.cgPath
			
			step += 1
			return()
		}
		if step == 3 {
			CATransaction.begin()
			CATransaction.setDisableActions(false)
			sqLayers1[0].path = userPaths[0].cgPath
			sqLayers2[0].path = userPaths[0].cgPath
			for cc in sqLayers1 {
				cc.strokeEnd = 0.0
			}
			for cc in sqLayers2 {
				cc.strokeEnd = 0.0
			}
			CATransaction.commit()

			step += 1
			return()
		}
		if step == 4 {
			numPercentagePoints = 10
			
			for (i, pth) in strokePathsArray.enumerated() {
				let cpth = pth.cgPath.copy(using: &defaultTransform)!
				var pctPoints: [CGPoint] = []
				for i in 0...numPercentagePoints {
					let pct = CGFloat(i) / CGFloat(numPercentagePoints)
					guard let p = cpth.point(at: pct) else {
						fatalError("could not get point at: \(i) / \(pct)")
					}
					pctPoints.append(p)
				}
				percentagePoints.append(pctPoints)

				let dPath = UIBezierPath()
				r = .init(x: 0, y: 0, width: 4, height: 4)
				d = r.width * 0.5
				for pt in pctPoints {
					r.origin = .init(x: pt.x - d, y: pt.y - d)
					dPath.append(UIBezierPath(ovalIn: r))
				}
				ptLayers[i].path = dPath.cgPath
			}
			ptLayers[1].opacity = 0.0
			ptLayers[2].opacity = 0.0

			tracingIDX = 0
			assitedLayers[tracingIDX].opacity = 1.0
			closeLayer.opacity = 1.0
			
			step += 1
			return()
		}
		if step == 5 {
			infoLabel.text = "Closest: 0 \t Max: 0"
			infoLabel.isHidden = false
			print("start")
			step += 1
			return()
		}
		if step == 6 {
			isTracing = true
			assitedLayers[tracingIDX].opacity = 1.0
			traceLayer.path = dashLayers[tracingIDX].path
		}
		if step == 7 {
			isTracing = false
			for cc in ptLayers {
				cc.opacity = 0.0
			}
			imgView.frame.origin = .zero

			step += 1
			return()
		}
		if step == 16 {
			guard let t = touches.first else { return }
			let p = t.location(in: self.view)
			imgView.frame.origin = p
			imgView.frame = imgView.frame.offsetBy(dx: 374, dy: 45)
		}
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if tracingIDX == -1 || tracingIDX > assitedLayers.count - 1 { return }
		guard let t = touches.first else { return }
		var p: CGPoint = t.location(in: self.view)
		var dp: CGPoint = p
		dp.x += 374
		dp.y += 45
		if let pIDX = findClosestPointIndex(to: p, in: percentagePoints[tracingIDX]) {
			maxIDX = max(maxIDX, pIDX)
			var pp = percentagePoints[tracingIDX][pIDX]
			pp.x += 374
			pp.y += 45
			let cPath = UIBezierPath()
			cPath.move(to: dp)
			cPath.addLine(to: pp)
			CATransaction.begin()
			CATransaction.setDisableActions(false)
			closeLayer.path = cPath.cgPath
			assitedLayers[tracingIDX].strokeEnd = CGFloat(maxIDX) / CGFloat(numPercentagePoints)
			CATransaction.commit()
			let pct = String(format: "%0.0f", (CGFloat(maxIDX) / CGFloat(numPercentagePoints)) * 100.0)
			infoLabel.text = "Closest: \(pIDX)    Max: \(maxIDX)    Pct: \(pct)%"
		}
		imgView.frame.origin = dp
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !isTracing { return }
		tracingIDX += 1
		infoLabel.text = "Closest: 0    Max: 0    Pct: 0%"
		imgView.frame.origin = .zero
		closeLayer.path = nil
		for (i, cc) in ptLayers.enumerated() {
			cc.opacity = i == tracingIDX ? 1.0 : 0.0
		}
		if tracingIDX > assitedLayers.count - 1 {
			infoLabel.isHidden = true
			tracingIDX = -1
			step += 1
			return()
		}
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
			self.targetView.layer.addSublayer(shapeLayer)
			self.targetView.layer.insertSublayer(shapeLayer, at: 0)
			
			//self.targetView.layer.addSublayer(self.canvasView.layer)
			
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
			let uPth = UserPath().path(i)
			userPaths.append(MyBezierPath(cgPath: uPth.cgPath))

			var c2: CAShapeLayer!
			
			c2 = CAShapeLayer()
			c2.strokeColor = UIColor.red.cgColor
			c2.fillColor = UIColor.yellow.cgColor
			c2.lineWidth = 2
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
		closeLayer.strokeColor = UIColor.red.cgColor
		closeLayer.opacity = 0.0
		view.layer.addSublayer(closeLayer)
		
		if let img = UIImage(named: "pen") {
			imgView.image = img
			imgView.frame = .init(x: 0, y: 0, width: img.size.width, height: img.size.height)
		}
		view.addSubview(imgView)
		
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
		infoLabel.textAlignment = .center
		infoLabel.isHidden = true
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

	}

	func calculatePoint(from point: CGPoint, angle: CGFloat, distance: CGFloat) -> CGPoint {
		return CGPoint(x: point.x + CGFloat(cosf(Float(angle))) * distance, y: point.y + CGFloat(sinf(Float(angle))) * distance)
	}

	func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool {
		
//		highestIDX = 0
		
		var b: Bool = false
		
//		let point = touch.location(in: drawingView)
//		if pathToHitTestAgainst.contains(point) {
//			if let i = findClosestPointIndex(to: point, in: percentagePoints) {
//				if i <= proximityToStart {
//					b = true
//				}
//			}
//		}
//		
//		allowTracing = b
		
		return b
	}
	func swiftyDraw(didBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {
		
	}
	func swiftyDraw(isDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {
		
		if let p = drawingView.drawItems.first {
			print(p.path.length)
		}
		
//		if !allowTracing { return }
//		
//		let point = touch.location(in: drawingView)
//		
//		if !pathToHitTestAgainst.contains(point) {
//			allowTracing = false
//			drawingView.undo()
//			CATransaction.begin()
//			CATransaction.setDisableActions(false)
//			if self.assistiveDrawLayersArray.count > self.strokeIndex {
//				self.assistiveDrawLayersArray[strokeIndex].strokeEnd = 0
//			}
//			CATransaction.setCompletionBlock({
//				self.showTutorial()
//			})
//			CATransaction.commit()
//			return
//		}
//		
//		if let i = findClosestPointIndex(to: point, in: percentagePoints) {
//			highestIDX = max(highestIDX, i)
//		}
//		
//		if assistiveTouchSwitch.isOn {
//			let pctAlongPath = CGFloat(highestIDX) / CGFloat(numPercentagePoints)
//			
//			if pctAlongPath >= pctNeededToCompleteAssisted {
//				
//				CATransaction.begin()
//				CATransaction.setDisableActions(false)
//				assistiveDrawLayersArray[strokeIndex].strokeEnd = 1
//				assistiveDrawLayersArray[strokeIndex].strokeColor = self.colors[self.strokeIndex].cgColor
//				CATransaction.commit()
//				
//				dashLayer.removeFromSuperlayer()
//				dashLayer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }
//				drawingView.clear()
//				
//				allowTracing = false
//				
//				if strokeIndex == strokePathsArray.count-1 {
//					return
//				}
//				
//				self.strokeIndex+=1
//				showHint()
//				showTutorial()
//				
//			} else {
//				
//				CATransaction.begin()
//				CATransaction.setDisableActions(true)
//				assistiveDrawLayersArray[strokeIndex].strokeEnd = pctAlongPath
//				CATransaction.commit()
//				
//			}
//		}
		
	}
	func swiftyDraw(didFinishDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {
		
		if let p = drawingView.drawItems.first {
			print(p.path)
		}

//		if !allowTracing { return }
//		
//		if assistiveTouchSwitch.isOn {
//			allowTracing = false
//			drawingView.undo()
//			CATransaction.begin()
//			CATransaction.setDisableActions(false)
//			if self.assistiveDrawLayersArray.count > self.strokeIndex {
//				self.assistiveDrawLayersArray[strokeIndex].strokeEnd = 0
//			}
//			CATransaction.setCompletionBlock({
//				self.showTutorial()
//			})
//			CATransaction.commit()
//			return
//		}
//		print(drawingView.drawItems.last?.path)
//		print(drawingView.drawItems.last?.path.length)
//		print(currentPathToTrace.length)
//		let pctAlongPath = CGFloat(highestIDX) / CGFloat(numPercentagePoints)
//		
//		if pctAlongPath < pctNeededToCompleteNonAssisted {
//			allowTracing = false
//			drawingView.undo()
//			showTutorial()
//			return
//		}
//		
//		dashLayer.removeFromSuperlayer()
//		dashLayer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }
//		
//		let layer = CAShapeLayer()
//		layer.fillColor = UIColor.clear.cgColor
//		layer.lineWidth = 10
//		layer.lineCap = .round
//		layer.strokeColor = self.accentColor.cgColor
//		layer.strokeColor = self.colors[self.strokeIndex].cgColor
//		if let drawItem = drawingView.drawItems.last {
//			layer.path = drawItem.path
//		}
//		self.canvasView.layer.addSublayer(layer)
//		
//		drawingView.clear()
//		
//		if strokeIndex == strokePathsArray.count-1 {
//			return
//		}
//		
//		self.strokeIndex+=1
//		showHint()
//		showTutorial()
		
	}

	func swiftyDraw(didCancelDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {
		
	}

}
