//
//  Extensions.swift
//  NepMeds
//
//  Created by Sunil on 7/18/19.
//  Copyright © 2019 SunBi. All rights reserved.
//

import Foundation



import UIKit

//MARK: UIColor Extension

extension UIColor {
    
    struct MainTheme {
        static var blueColor: UIColor  { return UIColor(hex: "1da2f4") }

        static var yellow: UIColor {return UIColor(hex: "ff9e34")}
        static var categorytitleColor : UIColor {
            if #available(iOS 13, *) {
                return  UIColor(named: "titleColor")!
            }
            else {
                return UIColor(hex: "1F2124")
            }

        }

        static var titleColor : UIColor {
            if #available(iOS 13, *) {
                return  UIColor.secondaryLabel
            }
            else {
                return UIColor(hex: "3C3C43")
            }

        }

       static var backgroundColor : UIColor {
            if #available(iOS 13, *) {
                return  UIColor.secondarySystemBackground
            }
            else {
                return UIColor.white
            }
        }
        
        static var cyan: UIColor { return UIColor(hex: "15afb7") }
    }
    
    ///custom colors for different views and borders
    static let buttonBorder = UIColor(red:0.24, green:0.42, blue:0.70, alpha:1.0)
    
    
    convenience init(hex: String) {
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
        
    }
        class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
            let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
            return color
        }
    
    
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        
        return self.adjust(by: abs(percentage) )
    }
    
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
        
    }
    
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
            
        } else {
            
            return nil
        }
    }
    
}


//MARK:- UIDevice Extension
extension UIDevice {
    
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    
    static var isIphone6 : Bool {
        
        var modelIdentifier = ""
        if isSimulator {
            
            modelIdentifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
        } else {
            
            var size = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: size)
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            modelIdentifier = String(cString: machine)
            
        }
        
        return modelIdentifier == "iPhone7,2" || modelIdentifier == "iPhone8,1"
        
    }
    
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR = "iPhone XR"
        case iPhone_XSMax = "iPhone XS Max"
        case unknown
        
    }
    
    
    var hasNotch: Bool{
        
        return UIScreen.main.nativeBounds.height >= 1792 && screenType != .iPhones_6Plus_6sPlus_7Plus_8Plus
        
        
    }
    
    var isPlusSized: Bool {
        return UIScreen.main.nativeBounds.height >= 1792
    }
    
    var screenType: ScreenType {
        
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            return .unknown
            
        }
        
    }
    
    
}


//MARK:- UIView Extension

extension UIView {
    
    func shakeView() {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        
    }
    
    
    func addDropShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        
//        layer.masksToBounds = false
//        layer.shadowOffset = offset
//        layer.shadowColor = color.cgColor
//        layer.shadowRadius = radius
//        layer.shadowOpacity = opacity
//        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
//        layer.cornerRadius = 5
//        layer.shouldRasterize = true
        
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1.0
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.9).cgColor
        
    
        
        

        
    }
    func dropShadow(scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.5
      layer.shadowOffset = CGSize(width: -1, height: 1)
      layer.shadowRadius = 1

      layer.shadowPath = UIBezierPath(rect: bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    /// for dashed border
    func addDashedBorder(color: CGColor) {
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [10,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    
}

//MARK:- UIButton Extension
extension UIButton {
    
    func setButtonBorder(borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat) {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
    }
    
}


//MARK:- UITextfield Extension

extension UITextField {
    
    func setLeftViewIcon(icon: UIImage, scale: CGFloat = 0.85) {
           let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 20))
           btnView.setImage(icon, for: .normal)
           btnView.imageEdgeInsets = UIEdgeInsets(top: -2, left: 0, bottom:0, right: 0)
           btnView.contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 2)
           if #available(iOS 13.0, *) {
               btnView.imageView?.tintColor  = .placeholderText
           } else {
               btnView.imageView?.tintColor  = .lightGray
           }
           btnView.imageView?.layer.transform = CATransform3DMakeScale(scale, scale, scale)
           self.leftViewMode = .always
           self.leftView = btnView

       }


    func setRightViewIcon(icon: UIImage, inset: CGFloat = 0) {
           let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 20))
           btnView.setImage(icon, for: .normal)
        btnView.contentHorizontalAlignment = .right
           btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom:0, right: inset)
//           btnView.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
           if #available(iOS 13.0, *) {
               btnView.imageView?.tintColor  = .placeholderText
           } else {
               btnView.imageView?.tintColor  = .lightGray
           }
           btnView.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
           self.rightViewMode = .always
           self.rightView = btnView

       }
    
    
    
    func setLeftViewPadding(width: CGFloat = 16) {
        
        let btnView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        self.leftViewMode = .always
        self.leftView = btnView
        
    }
    
    
}

//MARK:- String Extension

extension String {
    
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSMutableAttributedString? {
        
        do {
            
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "color: #6a6a6a !important;" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSMutableAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
            
        } catch {
            
            print("error: ", error)
            return nil
            
        }
        
    }
    
    
    
    var htmlToAttributedString: NSAttributedString? {
        
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            
        } catch {
            return NSAttributedString()
        }
        
    }
    
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
        
    }
    
    
    
    func strikeThrough() -> NSMutableAttributedString {
        
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: NSRange(location: 0, length: attributeString.length))
        
        return attributeString
        
    }
    
    
}





public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable { }
extension UITableViewHeaderFooterView: Reusable { }
extension UICollectionViewCell: Reusable { }

// MARK: - UITableViewCell
public extension UITableView {
    
    @discardableResult
    func registerReusableClass(withClass cellClass: Reusable.Type) -> UITableView {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
        
        return self
    }
    
    @discardableResult
    func registerReusableNib(withClass cellClass: Reusable.Type) -> UITableView {
        let nib = UINib(nibName: cellClass.reuseIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
        
        return self
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass cellClass: T.Type, for indexPath: IndexPath) -> T  {
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
}

// MARK: - UITableViewHeaderFooterView
public extension UITableView {
    
    @discardableResult
    func registerReusableHeaderFooterView(withClass headerFooterViewClass: Reusable.Type, fromNib: Bool = false) -> UITableView {
        if fromNib {
            let nib = UINib(nibName: headerFooterViewClass.reuseIdentifier, bundle: nil)
            register(nib, forHeaderFooterViewReuseIdentifier: headerFooterViewClass.reuseIdentifier)
        } else {
            register(headerFooterViewClass, forHeaderFooterViewReuseIdentifier: headerFooterViewClass.reuseIdentifier)
        }
        
        return self
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass headerFooterViewClass: T.Type = T.self) -> T?  {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T
    }
    
    
    
}

// MARK: - UICollectionView
extension UICollectionView {
    
    @discardableResult
    public func registerReusable(withClass cellClass: Reusable.Type, fromNib: Bool = false) -> UICollectionView {
        if fromNib {
            let nib = UINib(nibName: cellClass.reuseIdentifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
        } else {
            register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
        }
        
        return self
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(withClass cellClass: T.Type, for indexPath: IndexPath) -> T  {
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
}


//MARK:_ UILabel Extension
extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
    func fadeTransition(_ duration:CFTimeInterval) {
           let animation = CATransition()
           animation.timingFunction = CAMediaTimingFunction(name:
               CAMediaTimingFunctionName.easeInEaseOut)
           animation.type = CATransitionType.fade
           animation.duration = duration
           layer.add(animation, forKey: CATransitionType.fade.rawValue)
       }
}


//MARK:- CALayer Extension

extension CALayer {
    
    func bottomAnimation(duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = duration
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        self.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
    func topAnimation(duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = duration
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromBottom
        self.add(animation, forKey: CATransitionType.push.rawValue)
    }
    func leftAnimation(duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = duration
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromLeft
        self.add(animation, forKey: CATransitionType.push.rawValue)
    }
}


extension UIView {

    func applyShadowWithCornerRadius(color:UIColor, opacity:Float, radius: CGFloat, edge:AIEdge, shadowSpace:CGFloat)    {

        var sizeOffset:CGSize = CGSize.zero
        switch edge {
        case .Top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace)
        case .Left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0)
        case .Bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace)
        case .Right:
            sizeOffset = CGSize(width: shadowSpace, height: 0)


        case .Top_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .Top_Right:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
        case .Bottom_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
        case .Bottom_Right:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)


        case .All:
            sizeOffset = CGSize(width: 0, height: 0)
        case .None:
            sizeOffset = CGSize.zero
        }

        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true;

        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false

        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
    }
}

enum AIEdge:Int {
    case
    Top,
    Left,
    Bottom,
    Right,
    Top_Left,
    Top_Right,
    Bottom_Left,
    Bottom_Right,
    All,
    None
}


import UIKit

public extension UILabel {
    convenience init(badgeText: String, color: UIColor = .red, fontSize: CGFloat = UIFont.smallSystemFontSize) {
        self.init()
        text = badgeText.count > 1 ? " \(badgeText) " : badgeText
        textAlignment = .center
        textColor = .white
        backgroundColor = color
        
        font = UIFont.systemFont(ofSize: fontSize)
        layer.cornerRadius = fontSize * CGFloat(0.6)
        clipsToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .height, multiplier: 1, constant: 0))
    }
}

extension UIBarButtonItem {
    convenience init(badge: String?, button: UIButton, target: AnyObject?, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        
        let badgeLabel = UILabel(badgeText: badge ?? "")
        button.addSubview(badgeLabel)
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .top, relatedBy: .equal, toItem: button, attribute: .top, multiplier: 1, constant: 0))
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 0))
        if nil == badge {
            badgeLabel.isHidden = true
        }
        badgeLabel.tag = UIBarButtonItem.badgeTag
        
        self.init(customView: button)
    }
    
    convenience init(badge: String?, image: UIImage, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0,width: image.size.width, height: image.size.height)
        button.setBackgroundImage(image, for: .normal)
        
        self.init(badge: badge, button: button, target: target, action: action)
    }
    
    convenience init(badge: String?, title: String, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        self.init(badge: badge, button: button, target: target, action: action)
    }
    
    var badgeLabel: UILabel? {
        return customView?.viewWithTag(UIBarButtonItem.badgeTag) as? UILabel
    }
    
    var badgedButton: UIButton? {
        return customView as? UIButton
    }
    
    var badgeString: String? {
        get { return badgeLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)}
        
        set {
            if let badgeLabel = badgeLabel {
                badgeLabel.text = nil == newValue ? nil : " \(newValue!) "
                badgeLabel.sizeToFit()
                badgeLabel.isHidden = nil == newValue
            }
        }
    }
    
    var badgedTitle: String? {
        get { return badgedButton?.title(for: .normal) }
        set { badgedButton?.setTitle(newValue, for: .normal); badgedButton?.sizeToFit() }
    }
    
    private static let badgeTag = 7373
}
extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}



 extension UILabel {

    func addInterlineSpacing(spacingValue: CGFloat = 2) {

        // MARK: - Check if there's any text
        guard let textString = text else { return }

        // MARK: - Create "NSMutableAttributedString" with your text
        let attributedString = NSMutableAttributedString(string: textString)

        // MARK: - Create instance of "NSMutableParagraphStyle"
        let paragraphStyle = NSMutableParagraphStyle()

        // MARK: - Actually adding spacing we need to ParagraphStyle
        paragraphStyle.lineSpacing = spacingValue

        // MARK: - Adding ParagraphStyle to your attributed String
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))

        // MARK: - Assign string that you've modified to current attributed Text
        attributedText = attributedString
    }

}

extension String {
    func makeAttributedTitle(with color: UIColor = UIColor.MainTheme.blueColor) -> NSMutableAttributedString {

           let att = NSMutableAttributedString(string: self)
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: NSRange(location: 0, length: att.length))

           att.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .regular) , range: NSRange(location: 0, length: 4))
        att.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 19, weight: .semibold) , range: NSRange(location: 4, length: att.length-4))







           return att

       }
}




extension UINavigationBar {

    func makeTransparent() {
        self.setBackgroundImage(UIImage(), for: .default)

        self.shadowImage = UIImage()
        self.isTranslucent = true
    }

    func undoTransparency() {
        self.setBackgroundImage(nil, for: .default)
        self.shadowImage = nil
        //        self.isTranslucent = false
        self.layoutIfNeeded()

    }
}



extension UICollectionView {

    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
}



extension UIView {

    enum UIViewFadeStyle {
        case bottom
        case top
        case left
        case right

        case vertical
        case horizontal
    }

    func fadeView(style: UIViewFadeStyle = .bottom, percentage: Double = 0.07) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]

        let startLocation = percentage
        let endLocation = 1 - percentage

        switch style {
        case .bottom:
            gradient.startPoint = CGPoint(x: 0.5, y: endLocation)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        case .top:
            gradient.startPoint = CGPoint(x: 0.5, y: startLocation)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
            gradient.locations = [0.0, startLocation, endLocation, 1.0] as [NSNumber]

        case .left:
            gradient.startPoint = CGPoint(x: startLocation, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .right:
            gradient.startPoint = CGPoint(x: endLocation, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
            gradient.locations = [0.0, startLocation, endLocation, 1.0] as [NSNumber]
        }

        layer.mask = gradient
    }

}
