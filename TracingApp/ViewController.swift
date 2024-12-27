//
//  ViewController.swift
//  TracingApp
//
//  Created by Sunil on 29/12/2020.
//

import UIKit
import SwiftyDraw

class ApproachVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var path = MyBezierPath(svgPath: "m 27.183494,30 c 1.799867,6.703167 5.73525,21.942548 19.10735,25.425821 C 62.18913,58.972955 71.676308,43.806518 56.324843,30 c 8.148778,-0.235038 16.297872,0.3043 24.444458,0")
		path = MyBezierPath(svgPath: "m 100,80 H 400")

		var defaultTransform = CGAffineTransform(scaleX: 6, y: 6)
			//.translatedBy(x: 10.0, y: 0.0)
		
		defaultTransform = CGAffineTransform(scaleX: 1, y: 1)

		guard let pth = path.cgPath.copy(using: &defaultTransform) else { return }
		
		let c1 = CAShapeLayer()
		c1.strokeColor = UIColor.systemBlue.cgColor
		c1.fillColor = UIColor.clear.cgColor
		c1.path = pth
		
		view.layer.addSublayer(c1)
		
		var pts: [CGPoint] = []
		for i in 0...20 {
			let pct = CGFloat(i) / 20.0
			if let pt = pth.point(at: pct) {
				pts.append(pt)
			}
		}
		
		let c2 = CAShapeLayer()
		c2.strokeColor = UIColor.systemRed.cgColor
		c2.fillColor = UIColor.systemRed.cgColor
		
		let dPath = UIBezierPath()
		var r: CGRect = .init(x: 0, y: 0, width: 4, height: 4)
		var d: CGFloat = r.width * 0.5
		for pt in pts {
			r.origin = .init(x: pt.x - d, y: pt.y - d)
			dPath.append(UIBezierPath(ovalIn: r))
		}
		c2.path = dPath.cgPath
		
		view.layer.addSublayer(c2)

		
	}
	
}

class ViewController: UIViewController, SwiftyDrawViewDelegate {
	
	var colors: [UIColor] = [
		.green, .yellow, .systemYellow,
	]
	
	func xswiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool {
		
		print("should begin")
		return false
		
		let point = touch.location(in: drawingView)
		
		allowTracing = false
		
		// don't allow tracing if touch did not START inside pathToHitTestAgainst
		if pathToHitTestAgainst.contains(point) {
			if let i = findClosestPointIndex(to: point, in: interpolatedPoints) {
				// starting trace must be at the beginning of the current path
				// if this is the FIRST touch inside pathToHitTestAgainst
				//	AND it is farther than proximityToStart interpolated points from the start
				//		disable tracing until touch-up
				//		and don't do anything else
				if highestIDX == 0 && i > proximityToStart {
					allowTracing = false
				} else {
					allowTracing = true
				}
			}
		}

		//	reset highestIDX
		highestIDX = 0

		print("should begin", allowTracing)
		
		return allowTracing
	}
	
	func xswiftyDraw(didBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {

		print("did begin")

	}
	
	func xswiftyDraw(isDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {
		
		print("is drawing")
		
		if !allowTracing { return }
		
		let point = touch.location(in: drawingView)
		
		let iscontain = pathToHitTestAgainst.contains(point)
		if iscontain  {
			
			if let i = findClosestPointIndex(to: point, in: interpolatedPoints) {
				// starting trace must be at the beginning of the current path
				// if this is the FIRST touch inside pathToHitTestAgainst
				//	AND it is farther than proximityToStart interpolated points from the start
				//		disable tracing until touch-up
				//		and don't do anything else
				if highestIDX == 0 && i > proximityToStart {
					allowTracing = false
					return()
				}
				highestIDX = max(highestIDX, i)
			}
			
			let pctAlongPath = CGFloat(highestIDX) / CGFloat(numInterpolatedPoints)
			
			if self.assistiveTouchSwitch.isOn {
				
				// don't know what this is doing?
				//				if let first = self.currentPathToTrace.points().first{
				//					print("distamce:",   first.distance(to: point))
				//					print("length: ", currentPathToTrace.length)
				//
				//
				//					if first.distance(to: point)>=21 &&  assistiveDrawLayersArray[strokeIndex].strokeEnd == 0  {
				//						print("from right")
				//						assistiveDrawLayersArray[strokeIndex].strokeEnd = 0
				//						showTutorial()
				//						return
				//					}
				//				}
				
				if pctAlongPath >= pctNeededToCompleteAssisted {
					
					CATransaction.begin()
					CATransaction.setDisableActions(false)
					assistiveDrawLayersArray[strokeIndex].strokeEnd = 1
					CATransaction.commit()
					
					
					if strokeIndex == strokePathsArray.count-1{
						dashLayer.removeFromSuperlayer()
						dashLayer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }
						drawingView.clear()
						return
					}
					
					let layer = CAShapeLayer()
					layer.fillColor = UIColor.clear.cgColor
					layer.lineWidth = 10
					layer.lineCap = .round
					layer.strokeColor = self.accentColor.cgColor
					if let drawItem = drawingView.drawItems.last {
						layer.path = drawItem.path
					}
					self.canvasView.layer.addSublayer(layer)

					dashLayer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }
					drawingView.clear()
					self.strokeIndex+=1
					showHint()
					showTutorial()
					
				} else {
					
					CATransaction.begin()
					CATransaction.setDisableActions(true)
					assistiveDrawLayersArray[strokeIndex].strokeEnd = pctAlongPath
					CATransaction.commit()
					
				}
				
				
			}
			
		} else {
			
			allowTracing = false
			
			if assistiveDrawLayersArray.count >= strokeIndex {
				assistiveDrawLayersArray[strokeIndex].strokeEnd = 0
			}
			drawingView.undo()
			showTutorial()
			
		}
	}

    func xswiftyDraw(didFinishDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {

		print("did finish")
		
		if !allowTracing { return }

		allowTracing = false
		
		let pctAlongPath = CGFloat(highestIDX) / CGFloat(numInterpolatedPoints)

		var completed: Bool = false
		
		if assistiveTouchSwitch.isOn {
			// we will only get here if pctAlongPath is LESS THAN pctNeededToCompleteAssisted
			completed = false
		} else {
			completed = pctAlongPath >= pctNeededToCompleteNonAssisted
		}
		
		if !completed {
			print("Not completed", pctAlongPath)
			
			allowTracing = false
			highestIDX = 0
			if assistiveTouchSwitch.isOn {
				assistiveDrawLayersArray[strokeIndex].strokeEnd = 0
			}
			drawingView.undo()
			showTutorial()

		} else {
			print("completed", pctAlongPath)

			allowTracing = false
			highestIDX = 0

			// we will only get here if assistiveTouchSwitch is OFF
			
			if strokeIndex == strokePathsArray.count-1{
				dashLayer.removeFromSuperlayer()
				dashLayer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }
				drawingView.clear()
				
				return
			}
			
			dashLayer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }
			//drawingView.clear()
			
			self.strokeIndex+=1
			showHint()
			showTutorial()

        }

    }

	
	func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool {

		highestIDX = 0
		
		var b: Bool = false
		let point = touch.location(in: drawingView)
		if pathToHitTestAgainst.contains(point) {
			if let i = findClosestPointIndex(to: point, in: interpolatedPoints) {
				if i <= proximityToStart {
					b = true
				}
			}
		}
		
		allowTracing = b
		
		return b
	}
	func swiftyDraw(didBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {
		
	}
	func swiftyDraw(isDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {
		
		if !allowTracing { return }
		
		let point = touch.location(in: drawingView)
		
		if !pathToHitTestAgainst.contains(point) {
			allowTracing = false
			drawingView.undo()
			CATransaction.begin()
			CATransaction.setDisableActions(false)
			if self.assistiveDrawLayersArray.count > self.strokeIndex {
				self.assistiveDrawLayersArray[strokeIndex].strokeEnd = 0
			}
			CATransaction.setCompletionBlock({
				self.showTutorial()
			})
			CATransaction.commit()
			return
		}

		if let i = findClosestPointIndex(to: point, in: interpolatedPoints) {
			highestIDX = max(highestIDX, i)
		}
		
		if assistiveTouchSwitch.isOn {
			let pctAlongPath = CGFloat(highestIDX) / CGFloat(numInterpolatedPoints)
			
			if pctAlongPath >= pctNeededToCompleteAssisted {
				
				CATransaction.begin()
				CATransaction.setDisableActions(false)
				assistiveDrawLayersArray[strokeIndex].strokeEnd = 1
				assistiveDrawLayersArray[strokeIndex].strokeColor = self.colors[self.strokeIndex].cgColor
				CATransaction.commit()
				
				dashLayer.removeFromSuperlayer()
				dashLayer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }
				drawingView.clear()
				
				allowTracing = false
				
				if strokeIndex == strokePathsArray.count-1 {
					return
				}
				
				self.strokeIndex+=1
				showHint()
				showTutorial()

			} else {
				
				CATransaction.begin()
				CATransaction.setDisableActions(true)
				assistiveDrawLayersArray[strokeIndex].strokeEnd = pctAlongPath
				CATransaction.commit()

			}
		}

	}
	func swiftyDraw(didFinishDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {
		
		if !allowTracing { return }
		
		if assistiveTouchSwitch.isOn {
			allowTracing = false
			drawingView.undo()
			CATransaction.begin()
			CATransaction.setDisableActions(false)
			if self.assistiveDrawLayersArray.count > self.strokeIndex {
				self.assistiveDrawLayersArray[strokeIndex].strokeEnd = 0
			}
			CATransaction.setCompletionBlock({
				self.showTutorial()
			})
			CATransaction.commit()
			return
		}
		
		let pctAlongPath = CGFloat(highestIDX) / CGFloat(numInterpolatedPoints)

		if pctAlongPath < pctNeededToCompleteNonAssisted {
			allowTracing = false
			drawingView.undo()
			showTutorial()
			return
		}
		
		dashLayer.removeFromSuperlayer()
		dashLayer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }
		
		let layer = CAShapeLayer()
		layer.fillColor = UIColor.clear.cgColor
		layer.lineWidth = 10
		layer.lineCap = .round
		layer.strokeColor = self.accentColor.cgColor
		layer.strokeColor = self.colors[self.strokeIndex].cgColor
		if let drawItem = drawingView.drawItems.last {
			layer.path = drawItem.path
		}
		self.canvasView.layer.addSublayer(layer)
		
		drawingView.clear()
		
		if strokeIndex == strokePathsArray.count-1 {
			return
		}
		
		self.strokeIndex+=1
		showHint()
		showTutorial()
		
	}
	
    @IBAction func resetCanvas(_ sender: Any) {
        self.canvasView.clear()
        self.canvasView.layer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }
        self.strokeIndex = 0

        dashLayer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }

        if self.assistiveTouchSwitch.isOn {
            self.assistiveDrawLayersArray.forEach{
                $0.strokeEnd = 0
            }
        }

        showHint()
        showTutorial()
    }




    func swiftyDraw(didCancelDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {

    }

    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }






    var swiped = false
    var lastPoint = CGPoint.zero

    var accentColor = UIColor(hex: "00acc1")

    let canvasView = SwiftyDrawView()

    var isTutorialAnimationInProgresss = false

    @IBOutlet weak var assistiveTouchSwitch: UISwitch!


    var strokeAnimationCounter = 0


    @IBAction func toggleAssistiveTouch(_ sender: UISwitch) {

        self.canvasView.brush.color = sender.isOn ? Color(.clear) : Color(self.accentColor)

		setUpLayersForAssistiveMode()

    }

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
        canvasView.brush.color =  self.assistiveTouchSwitch.isOn ? Color(.clear) : Color.init(self.accentColor)
        canvasView.frame = sTargetView.bounds
        canvasView.delegate = self

        return sTargetView
    }()




    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    var currentPathToTrace : CGPath!


    var defaultTransform  = CGAffineTransform()


    var assistiveDrawLayersArray = [CAShapeLayer()]

    var pathToHitTestAgainst : CGPath!

    let dashLayer = CAShapeLayer()
    let tutorialLayer = CALayer()

    var strokeIndex = 0 {
        didSet {
            self.pathToHitTestAgainst = self.strokePathsArray[strokeIndex].cgPath.copy(strokingWithWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: 0, transform: defaultTransform)
        }
    }
    var strokePathsArray = [MyBezierPath]()
    override func viewDidLoad() {
        super.viewDidLoad()
		
		assistiveTouchSwitch.isOn = false
		
        self.view.addSubview(targetView)
        // Do any additional setup after loading the view.
//        view.backgroundColor = .black
        let path = MyBezierPath(svgPath: "m 17.899207,12.838052 c 24.277086,0 48.554171,0 72.831257,0")
        let path2 = MyBezierPath(svgPath: "m 27.183494,30 c 1.799867,6.703167 5.73525,21.942548 19.10735,25.425821 C 62.18913,58.972955 71.676308,43.806518 56.324843,30 c 8.148778,-0.235038 16.297872,0.3043 24.444458,0")
        let path1 = MyBezierPath(svgPath: "M 81.707208,12.894524 C 81.560683,44.598905 71.417523,97.40583 45.542397,94.433749")



        strokePathsArray.append(path)
        strokePathsArray.append(path1)
        strokePathsArray.append(path2)


        let combinedPath = CGMutablePath()

        combinedPath.addPath(path.cgPath)
        combinedPath.addPath(path1.cgPath)
        combinedPath.addPath(path2.cgPath)

        defaultTransform = CGAffineTransform(scaleX: self.targetView.frame.width/109, y: self.targetView.frame.width/109)

        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.cyan.cgColor

        shapeLayer.transform = CATransform3DMakeAffineTransform(defaultTransform)
                // The Bezier path that we made needs to be converted to
                // a CGPath before it can be used on a layer.
        shapeLayer.path = combinedPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = UIColor.white.cgColor
        self.targetView.layer.addSublayer(shapeLayer)



        self.pathToHitTestAgainst = self.strokePathsArray[0].cgPath.copy(strokingWithWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: 0, transform: defaultTransform)





//        showHint()
//        showTutorial()


        // or animate all paths then show hint
        animatePath()



        setUpLayersForAssistiveMode()

        self.targetView.layer.addSublayer(self.canvasView.layer)




    }


    func setUpLayersForAssistiveMode(){
		for l in self.assistiveDrawLayersArray {
			l.removeFromSuperlayer()
		}
        self.assistiveDrawLayersArray.removeAll()

        if self.assistiveTouchSwitch.isOn {

            self.strokePathsArray.forEach{

                let layer = CAShapeLayer()

                layer.path = $0.cgPath
                layer.fillColor = UIColor.clear.cgColor
                layer.lineWidth = 6
                layer.strokeStart = 0
                layer.strokeEnd = 0
                layer.lineCap = .round
                layer.strokeColor = self.accentColor.cgColor
                layer.transform = CATransform3DMakeAffineTransform(defaultTransform)
                self.targetView.layer.addSublayer(layer)
                assistiveDrawLayersArray.append(layer)


            }

    }

    }







    func showHint(){

        let path = self.strokePathsArray[strokeIndex]

        dashLayer.path = path.cgPath
        dashLayer.fillColor = UIColor.clear.cgColor
        dashLayer.lineDashPattern =  [2,2]
        dashLayer   .contents = UIImage(named: "pen")?.cgImage

        dashLayer.transform = CATransform3DMakeAffineTransform(defaultTransform)
        dashLayer.strokeColor = UIColor(hex: "f06292").cgColor
        dashLayer.lineWidth = 0.5

		// don't use a stroked-path
        //self.currentPathToTrace =   path.cgPath.copy(strokingWithWidth: 0, lineCap: .round, lineJoin: .miter, miterLimit: 0, transform: defaultTransform)
		self.currentPathToTrace = path.cgPath.copy(using: &defaultTransform)


        if let startPoint = path.startPoint {

            let circulPath = UIBezierPath(arcCenter: CGPoint(x: startPoint.x , y: startPoint.y) , radius: 1.5, startAngle: 0, endAngle: 2.0 * CGFloat.pi, clockwise: true)

            let circleLayer = CAShapeLayer()
            circleLayer.path = circulPath.cgPath
            circleLayer.fillColor = UIColor(hex: "f06292").cgColor
            circleLayer.transform = CATransform3DMakeTranslation(0, 0, 0)

            dashLayer.insertSublayer(circleLayer, at: 0)

        }




        let secondLastPoint =  path.cgPath.points().count>2 ?  path.cgPath.points()[path.cgPath.points().count-2] : path.cgPath.points()[0]



        if let lastPoint = path.cgPath.points().last {

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

		// generate array of points along path
		interpolatedPoints = []
		for i in 0..<numInterpolatedPoints {
			let pct = CGFloat(i) / CGFloat(numInterpolatedPoints)
			guard let p = currentPathToTrace.point(at: pct) else {
				fatalError("could not get point at: \(i) / \(pct)")
			}
			interpolatedPoints.append(p)
		}

		allowTracing = false
    }

	var interpolatedPoints: [CGPoint] = []
	var highestIDX: Int = 0
	var numInterpolatedPoints: Int = 100
	var proximityToStart: Int = 2
	var pctNeededToCompleteAssisted: CGFloat = 0.9
	var pctNeededToCompleteNonAssisted: CGFloat = 0.95
	var allowTracing: Bool = true

    func showTutorial(){

        if isTutorialAnimationInProgresss {
            return    //avoid animation on repeated taps outside boundary
        }

        let path = self.strokePathsArray[strokeIndex]
        self.tutorialLayer.opacity = 1
        tutorialLayer.contents = UIImage(named: "pen")?.cgImage

        tutorialLayer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        tutorialLayer.anchorPoint = CGPoint.zero

        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 1
        animation.repeatCount = 0 // just recommended by Apple
        animation.path = path.cgPath
        animation.calculationMode = .paced
        animation.beginTime = 0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        CATransaction.begin()


        isTutorialAnimationInProgresss = true
        CATransaction.setCompletionBlock({
            self.tutorialLayer.opacity = 0
            self.isTutorialAnimationInProgresss = false
        })
        tutorialLayer.add(animation, forKey: nil)

        CATransaction.commit()

        dashLayer.addSublayer(tutorialLayer)

        self.targetView.layer.addSublayer(dashLayer)



    }





    func calculatePoint(from point: CGPoint, angle: CGFloat, distance: CGFloat) -> CGPoint {
        return CGPoint(x: point.x + CGFloat(cosf(Float(angle))) * distance, y: point.y + CGFloat(sinf(Float(angle))) * distance)
    }

    func animatePath(){


        if strokeAnimationCounter == self.strokePathsArray.count {
            return
        }


        let layer : CAShapeLayer = CAShapeLayer()
        layer.strokeColor = self.accentColor.cgColor
        layer.lineWidth = 5.0
        layer.fillColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        layer.lineCap = .round
        layer.borderColor = UIColor.clear.cgColor
        
        layer.transform = CATransform3DMakeAffineTransform(defaultTransform)

        layer.path = self.strokePathsArray[strokeAnimationCounter].cgPath

        CATransaction.begin()

        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0

        animation.duration = 1.0
        CATransaction.setCompletionBlock{ [unowned self] in
            strokeAnimationCounter += 1
            if strokeAnimationCounter <= strokePathsArray.count-1{
                self.animatePath()
            }
            else {
                self.canvasView.layer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }
                showHint()
                showTutorial()
            }

           print("Animation completed")

       }
        layer.add(animation, forKey: "myStroke")
        CATransaction.commit()

    self.canvasView.layer.addSublayer(layer)


    }

	// find the CGPoint in array of CGPoint, closest to target CGPoint
	func findClosestPointIndex(to target: CGPoint, in points: [CGPoint]) -> Int? {
		guard !points.isEmpty else { return nil }
		return points.enumerated().min(by: { $0.element.distance(to: target) < $1.element.distance(to: target) })?.offset
	}

}

class MyBezierPath: UIBezierPath {
    var startPoint :CGPoint?

    override func move(to point: CGPoint) {
        super.move(to: point)
        startPoint=point
    }



}


extension CGPath {


    func points() -> [CGPoint]
        {
            var bezierPoints = [CGPoint]()
        self.forEach(body: { (element: CGPathElement) in
                let numberOfPoints: Int = {
                    switch element.type {
                    case .moveToPoint, .addLineToPoint: // contains 1 point
                        return 1
                    case .addQuadCurveToPoint: // contains 2 points
                        return 2
                    case .addCurveToPoint: // contains 3 points
                        return 3
                    case .closeSubpath:
                        return 0
                    }
                }()
                for index in 0..<numberOfPoints {
                    let point = element.points[index]
                    bezierPoints.append(point)
                }
            })
            return bezierPoints
        }



    func forEach( body:@escaping @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: callback)
    }
}

// Finds the first point in a path





