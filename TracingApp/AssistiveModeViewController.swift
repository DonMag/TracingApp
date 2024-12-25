//
//  CanvasViewController.swift
//  TracingApp
//
//  Created by Sunil on 11/01/2021.
//

import Foundation
import UIKit
public enum TraceOptions {
    case alphabet
    case sketch
}



class  CanvasViewController: UIViewController {
    @IBOutlet weak var cardBoardView: Cardboard!
    var paths = [[CGPoint]]() //paths loaded from dataset/question
    var pointToTrace = [CGPoint]() //points of first set of path to trace
    var layerToTrace = [CAShapeLayer]() //layers of first set of path to trace
    var lastPoint = CGPoint(x: 0.0, y: 0.0) //last point touched among the path to trace
    var image = UIImageView(image:UIImage(named: "Arrow"))
    var traceOption : TraceOptions? = .alphabet

    var colors : [UIColor] = [
        UIColor(red: 34, green: 0, blue: 43, alpha: 0.35),
        UIColor(red: 0, green: 0, blue: 66, alpha: 0.35),
        UIColor(red: 112, green: 0, blue: 0, alpha: 0.35),
        UIColor(red: 0, green: 14, blue: 16, alpha: 0.35)
    ]
    override func viewDidLoad() {


        let path = MyBezierPath(svgPath: "m 17.899207,12.838052 c 24.277086,0 48.554171,0 72.831257,0")
        let path2 = MyBezierPath(svgPath: "m 27.183494,30 c 1.799867,6.703167 5.73525,21.942548 19.10735,25.425821 C 62.18913,58.972955 71.676308,43.806518 56.324843,30 c 8.148778,-0.235038 16.297872,0.3043 24.444458,0")
        let path1 = MyBezierPath(svgPath: "M 81.707208,12.894524 C 81.560683,44.598905 71.417523,97.40583 45.542397,94.433749")





        paths.append(path.cgPath.points())
        paths.append(path1.cgPath.points())
        paths.append(path2.cgPath.points())




        for (i,path) in paths.enumerated() {
            var lastPointOfpath = path.first ?? CGPoint.zero
            for (j,point) in path.enumerated() {
                addTracePointAt(identifier: String(i)+String(j), point: point, color: .red)
                //cardboard.joinPoint(touchedPoint: lastPointOfpath, lastPoint: point)
                cardBoardView.drawLine(start: lastPointOfpath, end: point)
                lastPointOfpath = point
            }
        }

        //first set of points to trace
        pointToTrace = paths.first ?? []
        lastPoint = pointToTrace.first ?? CGPoint.zero
        addTutorial()




        
    }


    func addTracePointAt(identifier:String,point:CGPoint,color:UIColor) {
        let circleLayer = CAShapeLayer();
        circleLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: self.cardBoardView.frame.width/109, y: self.cardBoardView.frame.width/109))
        let circlePath = UIBezierPath(arcCenter: point,
                                      radius: 20,
                                      startAngle: 0,
                                      endAngle: 2 * CGFloat.pi,
                                      clockwise: true)


        circleLayer.path = circlePath.cgPath
        circleLayer.name = identifier
        circleLayer.fillColor = UIColor.clear.cgColor

        func addIndicatorLayer() -> CAShapeLayer {
            let indicatorLayer = CAShapeLayer();
            let indicatorPath = UIBezierPath(arcCenter: point,
                                             radius: 1,
                                             startAngle: 0,
                                             endAngle: 2 * CGFloat.pi,
                                             clockwise: true)
            indicatorLayer.path = indicatorPath.cgPath
            indicatorLayer.fillColor = color.cgColor
            return indicatorLayer
        }

        circleLayer.addSublayer(addIndicatorLayer())
        cardBoardView.layer.addSublayer(circleLayer)
        layerToTrace.append(circleLayer)
    }



    func addTutorial() {
        var count = pointToTrace.count
        image.center = pointToTrace.first ?? CGPoint(x: 0.0, y: 0.0)
        view.bringSubviewToFront(image)
        cardBoardView.addSubview(image)
        func move(pos:Int) {
            let index = pos + 1
            if index > pointToTrace.count - 1{
                removeTutorial()
                return
            }
            UIView.animate(withDuration: 0.05, animations: {
                updateCenter(point: self.pointToTrace[index])
            }) { (_) in
                move(pos: index)
            }
        }
        move(pos: 0)
        func updateCenter(point:CGPoint) {
            image.center = point
        }
    }

    func removeTutorial() {
        image.removeFromSuperview()
    }





}
