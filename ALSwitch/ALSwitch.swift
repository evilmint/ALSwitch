//
//  ALSwitch.swift
//  testdesignable
//
//  Created by Aleksander Lorenc on 13/03/2019.
//  Copyright © 2019 Unwrapped Software. All rights reserved.
//

import CoreGraphics
import UIKit

/// ALSwitch is a basic CoreGraphics implementation of the native UISwitch.
@IBDesignable public class ALSwitch: UIControl {
    private var width: CGFloat = 51
    private var height: CGFloat = 31
    private var frameWidth: CGFloat = 51
    private var frameHeight: CGFloat = 33
    private var changedValuesInTouches = false
    private let minimumPadding: CGFloat = 1

    /// Defines padding of the main switch area.
    /// Minimum value is 1.0.
    @IBInspectable public var knobPadding: CGFloat = 2.0 {
        didSet {
            knobPadding = max(minimumPadding, knobPadding)
            setNeedsDisplay()
        }
    }

    /// Defines the fill color of the main switch area.
    /// If onFillColor is defined, it is used for the on state.
    @IBInspectable public var fillColor: UIColor = UIColor(red: 75.9 / 255.0,
                                                           green: 215.7 / 255.0,
                                                           blue: 99.7 / 255.0, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }

    /// Defines the fill color of the main switch area for the on state.
    @IBInspectable public var onFillColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    /// Defines the fill color of the knob.
    /// If onFillColor is defined, it is used for the on state.
    @IBInspectable public var knobColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }

    /// Defines the fill color of the knob for the on state.
    @IBInspectable public var onKnobColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    /// Returns true if the switch is in the "on" state, otherwise "false".
    /// Used for setting the switch's state.
    @IBInspectable public var isOn: Bool = false {
        didSet {
            setNeedsDisplay()
            sendActions(for: .valueChanged)
        }
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: frameWidth, height: frameHeight)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        clipsToBounds = false
        layer.masksToBounds = false
        accessibilityTraits = UIAccessibilityTraits.button
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.preciseLocation(in: self)

        if bounds.contains(touchLocation) {
            let leftSideRect = CGRect(x: bounds.origin.x,
                                      y: bounds.origin.y,
                                      width: bounds.width / 2.0,
                                      height: bounds.height)

            let isOnNew = !leftSideRect.contains(touchLocation)

            if isOnNew != isOn {
                isOn = isOnNew
                changedValuesInTouches = true
            }
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !touches.isEmpty else { return }

        if !changedValuesInTouches {
            toggleValue()
        }

        changedValuesInTouches = false
    }

    private func toggleValue() {
        isOn = !isOn
    }

    private func roundedRectangle(from rect: CGRect, radius: CGFloat) -> CGPath {
        let path = CGMutablePath()

        let midTopPoint = CGPoint(x: rect.origin.x + rect.width / 2.0, y: rect.origin.y)

        path.move(to: midTopPoint)

        let topRightPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRightPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeftPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let topLeftPoint = CGPoint(x: rect.minX, y: rect.minY)

        path.addArc(tangent1End: topRightPoint,
                    tangent2End: bottomRightPoint,
                    radius: radius)
        path.addArc(tangent1End: bottomRightPoint,
                    tangent2End: bottomLeftPoint,
                    radius: radius)

        path.addArc(tangent1End: bottomLeftPoint,
                    tangent2End: topLeftPoint,
                    radius: radius)

        path.addArc(tangent1End: topLeftPoint,
                    tangent2End: topRightPoint,
                    radius: radius)

        path.closeSubpath()
        return path
    }

    override public func draw(_ drawRect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let rect = CGRect(x: drawRect.origin.x,
                          y: drawRect.origin.y,
                          width: width,
                          height: height)

        let drawSwitchFrame: (CGContext) -> Void = { context in
            let path = self.roundedRectangle(from: rect, radius: min(self.width, self.height) / 2.0)
            context.saveGState()

            let onFillColor = self.onFillColor ?? self.fillColor
            context.setFillColor((self.isOn ? onFillColor : self.fillColor).cgColor)
            context.addPath(path)
            context.fillPath()
            context.restoreGState()
        }

        let drawKnob: (CGContext) -> Void = { context in
            let knobPadding = self.knobPadding
            let ellipseSideWidth: CGFloat = min(rect.width, rect.height) - knobPadding * 2.0

            let knobEnabledRect = CGRect(origin: CGPoint(x: rect.origin.x + rect.width - knobPadding - ellipseSideWidth,
                                                         y: rect.origin.y + knobPadding),
                                         size: CGSize(width: ellipseSideWidth,
                                                      height: ellipseSideWidth))
            let knobDisabledRect = CGRect(x: rect.origin.x + knobPadding,
                                          y: rect.origin.y + knobPadding,
                                          width: ellipseSideWidth,
                                          height: ellipseSideWidth)
            let knobRect = self.isOn ? knobEnabledRect : knobDisabledRect

            context.saveGState()
            context.addEllipse(in: knobRect)
            context.setShadow(offset: CGSize(width: 0, height: 2), blur: 4.0, color: UIColor.black.withAlphaComponent(0.3).cgColor)

            let knobColor = (self.isOn ? (self.onKnobColor ?? self.knobColor) : self.knobColor).cgColor

            context.setFillColor(knobColor)
            context.fillPath()
            context.restoreGState()
        }

        drawSwitchFrame(context)
        drawKnob(context)
    }
}
