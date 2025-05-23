//
//  CellNode.swift
//  TextureP
//
//  Created by ykmason on 2025/5/22.
//

import Foundation
import AsyncDisplayKit
class ChatMessageNodeV1: ASCellNode {
    



    var isSelecting = false
    var isForward = false
    
    private let messageContent = ASDisplayNode() //消息容器
    private let leftSelectNode = ASDisplayNode() // 左边选择
    private let rightForwardNode = ASDisplayNode() // 右边转发
    
    private var translationX: CGFloat = 0
    
    init(message: Message) {
        super.init()
        automaticallyManagesSubnodes = true
        
        messageContent.backgroundColor = .brown
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        messageContent.view.addGestureRecognizer(panGesture)
        messageContent.view.isUserInteractionEnabled = true
        messageContent.style.flexGrow = 1
        messageContent.style.flexShrink = 1
        messageContent.style.height = ASDimension(unit: .points, value: 100)
        
        leftSelectNode.backgroundColor = .blue
        rightForwardNode.backgroundColor = .red
        
        leftSelectNode.style.preferredSize = CGSize(width: 30, height: 30)
        rightForwardNode.style.preferredSize = CGSize(width: 30, height: 30)
        
        self.style.height = ASDimension(unit: .auto, value: 0)

    }
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        
        // NEW: 判断是否是“主要是横向滑动”
        let isHorizontal = abs(translation.x) > abs(translation.y)

        switch gesture.state {
        case .began, .changed:
            guard isHorizontal else { return } // 忽略垂直滑动

            let deltaX = max(min(translation.x, 0), -60)
            messageContent.transform = CATransform3DMakeTranslation(deltaX, 0, 0)
            translationX = deltaX

        case .ended, .cancelled:
            let shouldReveal = translationX < -30
            let finalX: CGFloat = shouldReveal ? -60 : 0

            UIView.animate(withDuration: 0.2) {
                self.messageContent.transform = CATransform3DMakeTranslation(finalX, 0, 0)
            }

            translationX = finalX

        default:
            break
        }
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        messageContent.style.flexGrow = 1
        messageContent.style.flexShrink = 1

        // Stack background buttons horizontally
        let backgroundButtons = ASStackLayoutSpec.horizontal()
        backgroundButtons.children = [leftSelectNode, ASLayoutSpec(), rightForwardNode]
        backgroundButtons.style.width  = ASDimension(unit: .fraction, value: 1.0)
        backgroundButtons.style.height = ASDimension(unit: .points, value: 100)
        backgroundButtons.justifyContent = .spaceBetween
        backgroundButtons.alignItems = .center

        // Stack messageContent over buttons using absolute layout
        let absoluteLayout = ASAbsoluteLayoutSpec(children: [backgroundButtons, messageContent])

        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10),
            child: absoluteLayout
        )
    }
}
extension ChatMessageNodeV1: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // 允许和 tableView 的手势共存
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let velocity = pan.velocity(in: pan.view)
        return abs(velocity.x) > abs(velocity.y) // 只有主要是横向滑动时才处理
    }
}
class ChatMessageNode: ASCellNode {
    private let bubbleNode  = ASDisplayNode()
    private let textNode = ASTextNode()
    private let avatarNode = ASImageNode()
    private let imageNode = ASImageNode()
    private let replyNode = ChatReplyNode()
    private let imageGridNode = NineGridImageNode()
    
    private var isExpanded: Bool = false
    
    private let message: Message  // ← 新增属性
    init(message: Message) {
        self.message = message     // ← 保存到属性
        super.init()
        automaticallyManagesSubnodes = true
        
        
        configureText()

        imageGridNode.imageNames = message.imageNames
        if let image = UIImage(named: "example_image") {
            imageNode.image = image
            imageNode.contentMode = .scaleAspectFill
            imageNode.style.preferredSize = CGSize(width: 150, height: 100)
            imageNode.clipsToBounds = true
        }
        replyNode.isHidden = !message.isReply
        
    
        avatarNode.image = UIImage(systemName: "person.circle.fill")
        avatarNode.style.preferredSize = CGSize(width: 30, height: 30)
        avatarNode.cornerRadius = 15
        avatarNode.clipsToBounds = true
        
        bubbleNode.backgroundColor = message.type == .incoming ? UIColor(white: 0.9, alpha: 1) : UIColor.systemBlue.withAlphaComponent(0.5)
        bubbleNode.cornerRadius = 16
        bubbleNode.style.flexShrink = 1
        bubbleNode.style.maxWidth = ASDimension(unit: .fraction, value: 0.7)
        bubbleNode.automaticallyManagesSubnodes = true
        bubbleNode.layoutSpecBlock = { [unowned self] _, _ in
            let contentStack = ASStackLayoutSpec.vertical()
            
            var children: [ASLayoutElement] = []
            
            //:是不是有引用
            if message.isReply {
                children.append(replyNode)
            }
            //:是不是有图片
            if message.isHasImage {
                children.append(imageNode)
            }
            //: 添加图片九宫格
            if !message.imageNames.isEmpty {
                children.append(imageGridNode)
            }
            children.append(contentsOf: [textNode])
            
            contentStack.children = children
            contentStack.spacing  = 8
            let inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12), child: contentStack)
            return inset
        }
        self.style.height = ASDimension(unit: .auto, value: 0)
    }
    
    private func configureText() {
        let fullText = message.text
        
        let displayText = isExpanded || fullText.count <= 100 ? fullText : String(fullText.prefix(100)) + "… 更多"

    
        textNode.style.flexShrink = 1
        textNode.style.flexGrow = 1

        let attributedString = NSMutableAttributedString(string: displayText,
                                                         attributes: [
                                                             .font: UIFont.systemFont(ofSize: 16),
                                                             .foregroundColor: UIColor.black
                                                         ])
        let fullRange = NSRange(location: 0, length: attributedString.length)

        let mentionPattern = "@[\\w]+"
        let urlPattern = "(https?:\\/\\/[^\\s]+)"

        let combinedPattern = "(\(mentionPattern))|(\(urlPattern))"

        if let regex = try? NSRegularExpression(pattern: combinedPattern, options: []) {
            let matches = regex.matches(in: displayText, options: [], range: fullRange)
            for match in matches {
                attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: match.range)
            }
        }

        textNode.attributedText = attributedString
    }
    override func didLoad() {
        super.didLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleExpanded))
        textNode.view.addGestureRecognizer(tapGesture)
        textNode.view.isUserInteractionEnabled = true
    }
    @objc private func toggleExpanded() {
        isExpanded.toggle()
        configureText()
        setNeedsLayout()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // 包装头像和 bubble
        let messageRow = ASStackLayoutSpec.horizontal()
        messageRow.spacing = 8
        messageRow.alignItems = .end

        // 设置 bubbleNode 的最大宽度为可用宽度的 70%
        bubbleNode.style.maxWidth = ASDimension(unit: .fraction, value: 0.7)

        if message.type == .incoming {
            messageRow.children = [avatarNode, bubbleNode]
        } else {
            messageRow.children = [bubbleNode, avatarNode]
            messageRow.justifyContent = .end
        }

        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10),
            child: messageRow
        )
    }
}
// MARK: - ContentNode
class ChatMessageContentNode: ASDisplayNode {
    
    private let bubbleNode  = ASDisplayNode() // 气泡
    private let textNode = ASTextNode() // 文本
    private let avatarNode = ASImageNode() // 头像
    private let imageNode = ASImageNode() // 图片
    private let replyNode = ChatReplyNode() // 引用
    private let imageGridNode = NineGridImageNode() // 九宫格
    
    override init() {
        super.init()
        
    }
    func initNode() {
        
    }
}

// MARK: - NineGridImageNode
class NineGridImageNode: ASDisplayNode {
    private var imageNodes: [ASImageNode] = []
    var imageNames: [String] = [] {
        didSet {
            self.imageNodes = imageNames.prefix(9).map {_ in
                let node = ASImageNode()
                node.image = UIImage(named: "example_image")
                node.contentMode = .scaleAspectFill
                node.clipsToBounds = true
                return node
            }
        }
    }
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let count = imageNodes.count
        guard count > 0 else {
            return ASLayoutSpec()
        }

        let columns = min(3, count)
        let imageSpacing: CGFloat = 5
        let totalSpacing = CGFloat(columns - 1) * imageSpacing
        let imageWidth = (constrainedSize.max.width - totalSpacing) / CGFloat(columns)
        let imageSize = CGSize(width: imageWidth, height: imageWidth)

        for node in imageNodes {
            node.style.preferredSize = imageSize
        }

        var rows: [ASStackLayoutSpec] = []
        for i in stride(from: 0, to: imageNodes.count, by: columns) {
            let end = min(i + columns, imageNodes.count)
            let row = ASStackLayoutSpec.horizontal()
            row.spacing = imageSpacing
            row.children = Array(imageNodes[i..<end])
            rows.append(row)
        }

        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.spacing = imageSpacing
        verticalStack.children = rows
        return verticalStack
    }
}
class ChatReplyNode: ASDisplayNode {
    private let textNode = ASTextNode()
    private let indicatorNode = ASDisplayNode()

    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        
        indicatorNode.style.width = ASDimension(unit: .points, value: 2)

        indicatorNode.backgroundColor = .brown
//        indicatorNode.frame
        textNode.attributedText = NSAttributedString(string: "TextureP.ChatViewController: 0x107808200")
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
     
        // 包裹 indicator，增加右侧边距

        let relativeIndicator = ASRelativeLayoutSpec(
            horizontalPosition: .start,
            verticalPosition: .center,
            sizingOption: [],
            child: indicatorNode
        )
        let paddedIndicator = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0),
            child: textNode
        )
        let overlay = ASOverlayLayoutSpec(child: paddedIndicator, overlay: relativeIndicator)
        let contentInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 5), child: overlay)
        return contentInset
    }
}

