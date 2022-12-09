//
//  GGShadowCardView.swift
//  Writer
//
//  Created by 张艳金 on 2022/12/2.
//

import UIKit
 
//任意阴影
enum GGShadowPath : Int {
    case left
    case right
    case top
    case bottom
    case leftRight
    case allSide
}

//任意圆角
enum GGCornerRadiuSide : Int {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case bothTop
    case bothBottom
    case bothLeft
    case bothRight
    case all
}
// MARK: - ShadowCardView class implementation -

class GGShadowCardView: UIView {
    struct Shadow {
        // MARK: shadow element
        public var offset: CGSize? = CGSize(width: 0, height: 1)
        public var radius: CGFloat? = 5
        public var color: UIColor? = UIColor.black
        public var opacity: CGFloat? = 0.5
        public var side:GGShadowPath? = .allSide
    }
    struct Corners {
        // MARK: corner element
        public var radius: CGFloat? = 5
        public var bounds:CGRect?
        public var side:GGCornerRadiuSide? = .all//方向
    }
    struct Paddingg{
        // MARK: other element
        public var horizontal:CGFloat? = 30//水平边距
        public var vertical:CGFloat? = 10//垂直边距
    }
    
    var shadow      = Shadow()
    var corners     = Corners()
    var padding     = Paddingg()
    
    // MARK: interface element
    private var shadowView:UIView!
    public var infoView:UIView!
    private var shadowModel:ShadowModel!
    private var cornerModel:CornerModel!
    
    func drawCornerRadiu(){
        if self.shadowModel != nil {
            shadowView.gg_setShadowPath(with: shadow.color,
                                        shadowOpacity: shadow.opacity!,
                                        shadowRadius: shadow.radius!,
                                        shadowPath: shadow.side!,
                                        shadowPathWidth: 3,
                                        needBounds: infoView.bounds)
        }
        if self.cornerModel != nil {
            infoView.gg_setCornerRadiusWith(corners.radius!,
                                            side:corners.side!,
                                            needBounds: infoView.bounds)
        }
        
        
    }
    convenience init(horizontal:CGFloat,vertical:CGFloat) {
        self.init(frame: .zero)
        padding.horizontal = horizontal
        padding.vertical = vertical
        setUp()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setShadowModel(model:ShadowModel?){
        guard model != nil else {
            return
        }
        self.shadowModel = model
        shadow.offset   = model?.shadowOffset
        shadow.radius   = model?.shadowRadius
        shadow.color    = model?.shadowColor
        shadow.opacity  = model?.shadowOpacity
    }
    public func setCornerModel(model:CornerModel?){
        guard model != nil else {
            return
        }
        self.cornerModel = model
        corners.radius  = (model?.cornerRadius)!
        corners.side    = model?.rectCorner
    }
    private func setUp(){
        let shadowV = UIView()
        addSubview(shadowV)
        shadowView = shadowV
        
        let infoV = UIView()
        infoV.backgroundColor = UIColor.green
        shadowV.addSubview(infoV)
        infoView = infoV
        
        shadowView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(padding.horizontal!)
            make.top.bottom.equalToSuperview().inset(padding.vertical!)
        }
        self.infoView.snp.makeConstraints { (make) in
            make.edges.width.height.equalToSuperview()
        }
        
    }
    
    override func layoutSubviews() {
        drawCornerRadiu()
    }
}
extension UIView {
    
    func gg_setCornerRadiusWith(_ cornerRadius: CGFloat,
                                side: GGCornerRadiuSide,
                                needBounds: CGRect) {
        var maskPath = UIBezierPath()
        switch side {
        case .topLeft:
            maskPath = UIBezierPath(roundedRect: needBounds,
                                    byRoundingCorners: .topLeft,
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        case .topRight:
            maskPath = UIBezierPath(roundedRect: needBounds,
                                    byRoundingCorners: .topRight,
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        case .bottomLeft:
            maskPath = UIBezierPath(roundedRect: needBounds,
                                    byRoundingCorners: .bottomLeft,
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        case .bottomRight:
            maskPath = UIBezierPath(roundedRect: needBounds,
                                    byRoundingCorners: .bottomRight,
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        case .bothTop:
            maskPath = UIBezierPath(roundedRect: needBounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        case .bothBottom:
            maskPath = UIBezierPath(roundedRect: needBounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        case .bothLeft:
            maskPath = UIBezierPath(roundedRect: needBounds,
                                    byRoundingCorners: [.topLeft, .bottomLeft],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        case .bothRight:
            maskPath = UIBezierPath(roundedRect: needBounds,
                                    byRoundingCorners: [.topRight, .bottomRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        case .all:
            maskPath = UIBezierPath(roundedRect: needBounds,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        }
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func gg_setShadowPath(with shadowColor: UIColor?,
                          shadowOpacity: CGFloat,
                          shadowRadius: CGFloat,
                          shadowPath: GGShadowPath,
                          shadowPathWidth: CGFloat,
                          needBounds: CGRect) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize.zero
        var shadowRect: CGRect
        let originX: CGFloat = 0
        let originY: CGFloat = 0
        let originW = needBounds.size.width
        let originH = needBounds.size.height
        switch shadowPath {
        case .top:
            shadowRect = CGRect(x: originX, y: originY - shadowPathWidth / 2, width: originW, height: shadowPathWidth)
        case .bottom:
            shadowRect = CGRect(x: originX, y: originH - shadowPathWidth / 2, width: originW, height: shadowPathWidth)
        case .left:
            shadowRect = CGRect(x: originX - shadowPathWidth / 2, y: originY, width: shadowPathWidth, height: originH)
        case .right:
            shadowRect = CGRect(x: originW - shadowPathWidth / 2, y: originY, width: shadowPathWidth, height: originH)
        case .leftRight:
            shadowRect = CGRect(x: originX - shadowPathWidth / 2, y: originY, width: originW + shadowPathWidth, height: originH)
        case .allSide:
            shadowRect = CGRect(x: originX - shadowPathWidth / 2, y: originY - shadowPathWidth / 2, width: originW + shadowPathWidth, height: originH + shadowPathWidth)
        }
        let path = UIBezierPath(rect: shadowRect)
        layer.shadowPath = path.cgPath
    }
    
}
class ShadowModel: NSObject {
    var shadowOffset:CGSize? = CGSize(width: 0, height: 1)
    var shadowRadius:CGFloat? = 3
    var shadowColor:UIColor? = UIColor.black
    var shadowOpacity:CGFloat? = 0.4
    var side:GGShadowPath? = .allSide
}

class CornerModel: NSObject {
    var bounds:CGRect? = nil
    var rectCorner:GGCornerRadiuSide? = .all
    var cornerRadius:CGFloat? = 5
    
}


