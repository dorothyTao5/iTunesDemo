//  Created by dorothy on 2021/4/18.

import UIKit

protocol CustomSegmentDelegate: AnyObject {
    func switchRightToLeft()
    func switchLeftToRight()
}

class CustomSegment: UIView {
    weak var delegate: CustomSegmentDelegate?
    //init
    lazy var isOnLeftSide: Bool = true {
        didSet {
            connectCustomSegment(lcBGViewH: lcHeight, lcBGViewW: lcWidth)
        }
    }
    //segment【沒有選到的】normal text color
    var ColBasicTxtR: UIColor = R.color.black_white()!.withAlphaComponent(0.7)
    var ColBasicTxtL: UIColor = R.color.black_white()!.withAlphaComponent(0.7)
    //segment【選到的】Label text color
    var ColSeletedR: UIColor = R.color.black_white()!
    var ColSeletedL: UIColor = R.color.black_white()!
    //segment 左右兩邊Label text
    var LbTextL: String = "Light"
    var LbTextR: String = "Dark"
    //所有label.text 大小
    var TextSize: CGFloat = 16
    //Segment上可移動的背景顏色
    var ColSubVwR: UIColor = R.color.white_black()!.withAlphaComponent(0.5)
    var ColSubVwL: UIColor = R.color.white_black()!.withAlphaComponent(0.5)
    //背景顏色
    var backgroundCol: UIColor = R.color.black_white()!.withAlphaComponent(0.2)
    //segment 的外框
    var segmentBorderWidth: CGFloat = 2
    var segmentBorderColor: UIColor = .clear
    //半圓 halfRound
    var shouldHalfRound = false {
        didSet {
            shouldHalfRounded()
        }
    }
    //segment上可滑動的View&& Label
    let subView = UIView()
    private var lbDownR = UILabel()
    private var lbDownL = UILabel()
    var textWeight: UIFont.Weight = .medium {
        didSet {
            lbDownR.font = UIFont.systemFont(ofSize: TextSize, weight: textWeight)
        }
    }
    private lazy var vOriginal : CGPoint!  = {
        if isOnLeftSide == true {
            return getLeftCGCenter()
        }else {
           return getRightCGCenter()
        }
    }()
    private lazy var leftEdge : CGPoint! = {
        getLeftCGCenter()
    }()
    
    private lazy var rightEdge : CGPoint! = {
        getRightCGCenter()
    }()
    //action
    var moveToLeftSide: Bool = true {
        didSet {
            moveToLeftSide ? animateSubViewFromRightToLeft() : animateSubViewFromLeftToRight()
            moveToLeftSide ? delegate?.switchRightToLeft() : delegate?.switchLeftToRight()
        }
    }
    ///給view的高和寬
    private var lcHeight = CGFloat()
    private var lcWidth = CGFloat()
    
//MARK: - Life Cycle
    init(height: CGFloat, width:CGFloat) {
        super.init(frame: .zero)
        lcHeight = height
        lcWidth = width
        commonInit()
        connectCustomSegment(lcBGViewH: height, lcBGViewW:width)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        connectCustomSegment(lcBGViewH: frame.height, lcBGViewW: frame.width)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - private function
    ///setup segment
    private func connectCustomSegment(lcBGViewH: CGFloat, lcBGViewW:CGFloat){
        self.layer.borderWidth = segmentBorderWidth
        self.layer.borderColor = segmentBorderColor.cgColor
        lcHeight = lcBGViewH
        lcWidth = lcBGViewW
        let rCenterPoint = getRightCGCenter()
        let lCenterPoint =  getLeftCGCenter()
        
        switch isOnLeftSide {
        case true:
            setUpSelectedView(cgpoint: lCenterPoint)
            vOriginal = lCenterPoint
        case false:
            setUpSelectedView(cgpoint: rCenterPoint)
            vOriginal = rCenterPoint
        }
        
        setUpDownLabel(lbDown: &lbDownR, lbText: LbTextR, getCenter: getRightCGCenter)
        setUpDownLabel(lbDown: &lbDownL, lbText: LbTextL, getCenter: getLeftCGCenter)
        
        shouldHalfRounded()
    }
    
    private func shouldHalfRounded() {
        if shouldHalfRound {
            self.layer.cornerRadius = lcHeight / 2
            subView.layer.cornerRadius = (lcHeight - segmentBorderWidth * 2) / 2
        }
    }
    //MARK: - Get Position
    private func commonInit() {
        self.backgroundColor = backgroundCol
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        
        lbDownL.text = LbTextL
        lbDownR.text = LbTextR
        
        let panL = UIPanGestureRecognizer(target: self, action: #selector(panHorizontal))
        lbDownL.addGestureRecognizer(panL)
        let panR = UIPanGestureRecognizer(target: self, action: #selector(panHorizontal))
        lbDownR.addGestureRecognizer(panR)
        
        lbDownL.isUserInteractionEnabled = true
        lbDownR.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRecognize))
        lbDownL.addGestureRecognizer(tapGesture)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(tapRecognize))
        lbDownR.addGestureRecognizer(tapGesture2)
    }
    
    private func getLeftCGCenter() -> CGPoint {
        let yCenterPoint = lcHeight / 2
        let leftXPoint = (lcWidth / 4) + (segmentBorderWidth / 2)
        return CGPoint(x: leftXPoint ,y: yCenterPoint )
    }
    
    private func getRightCGCenter() -> CGPoint {
        let yCenterPoint = lcHeight / 2
        let rightXPoint = (lcWidth / 4 * 3) - (segmentBorderWidth / 2)
        return CGPoint(x: rightXPoint ,y: yCenterPoint )
    }
    
    private func animateSubViewFromLeftToRight() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.subView.center = self.rightEdge
        })
        isOnLeftSide = false
        setUpUnselectedLabel(downLabel: lbDownL, basicColor: ColBasicTxtL)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
        setUpSelectedLabel( downLabel: lbDownL ,
                           selectedLabel: lbDownR,
                           basicColor: ColBasicTxtL,
                           activeTxtCol: ColSeletedR,
                           colorSubViewBG: ColSubVwR)
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.switchLeftToRight()
        }
    }
    
    private func animateSubViewFromRightToLeft() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.subView.center = self.leftEdge
        })
        isOnLeftSide = true
        setUpUnselectedLabel(downLabel: lbDownR, basicColor: ColBasicTxtR)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            setUpSelectedLabel( downLabel: lbDownR,
                               selectedLabel: lbDownL,
                               basicColor: ColBasicTxtR,
                               activeTxtCol: ColSeletedL,
                               colorSubViewBG: ColSubVwL)
//        }
        self.delegate?.switchRightToLeft()
    }
    
    //    MARK: - SetUpLabelAlike
    private func setUpSelectedLabel( downLabel:UILabel,
                             selectedLabel:UILabel,
                             basicColor: UIColor,
                             activeTxtCol: UIColor,
                             colorSubViewBG: UIColor) {
         
         selectedLabel.textColor = activeTxtCol
         subView.backgroundColor = colorSubViewBG
     }
     
    private func setUpUnselectedLabel( downLabel:UILabel, basicColor: UIColor){
         downLabel.textColor = basicColor
         downLabel.isHidden = false
     }
    
    //    MARK: - setUpViews
    private func setUpSelectedView(cgpoint:CGPoint) {
        subView.frame = CGRect(x: 0, y: 0, width: lcWidth / 2 - segmentBorderWidth, height: lcHeight - segmentBorderWidth * 2)
        subView.layer.masksToBounds = true
        subView.layer.cornerRadius = 8
        subView.center = cgpoint
        
        if isOnLeftSide == true {
            subView.backgroundColor = ColSubVwL
           
            lbDownR.textColor = ColBasicTxtR
            lbDownL.textColor = ColSeletedL
            lbDownL.text = LbTextL
        }else {
            subView.backgroundColor = ColSubVwR

            lbDownL.textColor = ColBasicTxtL
            lbDownR.textColor = ColSeletedR
            lbDownR.text = LbTextR
        }
        self.addSubview(subView)
    }
    
    private func setUpDownLabel(lbDown: inout UILabel, lbText:String, getCenter: ()->CGPoint) {
        lbDown = setUpLabel(label: lbDown)
        lbDown.font = UIFont.systemFont(ofSize: TextSize, weight: textWeight)
        lbDown.center = getCenter()
        lbDown.text = lbText
        self.addSubview(lbDown)
    }
    
    private func setUpLabel(label:UILabel) -> UILabel {
        label.frame = CGRect(x: 0, y: 0, width: lcWidth / 2 - segmentBorderWidth, height: lcHeight - segmentBorderWidth * 2)
        label.font = label.font.withSize(TextSize)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
    
    //MARK: - 點擊label移動segment
    @objc func tapRecognize(sender:UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {return}
 
        switch label.text {
        case LbTextL:
            animateSubViewFromRightToLeft()
        case LbTextR:
            animateSubViewFromLeftToRight()
        default:
            print("tapRecognize got error")
        }
    }
    
    //MARK: - Pan label左右移動
    @objc func panHorizontal(sender: UIPanGestureRecognizer) {
        ///get how far have moved
        let translation = sender.translation(in: self)
        ///get velocity in view
        let velocity = sender.velocity(in: self)
        let x = vOriginal.x + translation.x
        switch isOnLeftSide {
        case true:  //left to right
            if sender.state == UIGestureRecognizer.State.began {
                vOriginal = subView.center
            } else if sender.state == UIGestureRecognizer.State.changed {
                guard velocity.x > 0 else {return}
                
                if x > rightEdge.x {
                    subView.center = CGPoint(x: rightEdge.x, y: vOriginal.y)
                }else if x > 55 {
                    animateSubViewFromLeftToRight()
                } else if x > 0 {
                    subView.center = CGPoint(x: x, y: vOriginal.y)
                }
//                print("is on right Side",x)
            } else if sender.state == UIGestureRecognizer.State.ended {
                if velocity.x > 0 {
                    animateSubViewFromLeftToRight()
                }else {
                    subView.center = leftEdge
                }
            }
             
        case false :  //right to left
            if sender.state == UIGestureRecognizer.State.began {
                vOriginal = subView.center
            } else if sender.state == UIGestureRecognizer.State.changed {
                guard velocity.x < 0 else {return}
                
                if x < leftEdge.x {
                    subView.center = CGPoint(x: leftEdge.x, y: vOriginal.y)
                } else if x < 138 {
                    animateSubViewFromRightToLeft()
                } else if x < rightEdge.x {
                    subView.center = CGPoint(x: x, y: vOriginal.y)
                }
//                print("is on left Side",x)
            } else if sender.state == UIGestureRecognizer.State.ended {
                if velocity.x < 0 {
                    animateSubViewFromRightToLeft()
                }else {
                    subView.center = rightEdge
                }
            }
        }
    }
}

