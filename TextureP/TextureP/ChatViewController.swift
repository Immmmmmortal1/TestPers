//
//  ChatViewController.swift
//  TextureP
//
//  Created by ykmason on 2025/5/22.
//

import UIKit
import AsyncDisplayKit
class ChatViewController: ASDKViewController<ASTableNode>,ASTableDataSource,ASTableDelegate {
    var messages:[Message] = []
    
    override init() {
         let tableNode = ASTableNode()
         super.init(node: tableNode)
         tableNode.dataSource = self
        tableNode.delegate = self
        // 反向
         tableNode.inverted = true
         generateMockData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func generateMockData() {
      
        messages = [
            Message(text: getLongText(), type: .incoming, isReply: false, imageName: "", imageNames: ["1", "2", "3"]),
            Message(text: "Hi there!  @Jhon robber", type: .outgoing, isReply: true, imageName: "2", imageNames: []),
            Message(text: "How's it going? https://www.google.com", type: .incoming, isReply: false, imageName: "", imageNames: ["1", "2"]),
            Message(text: "Pretty good. You?", type: .incoming, isReply: false, imageName: "", imageNames: []),
            Message(text: "Here's a long reply with multiple images", type: .incoming, isReply: true, imageName: "", imageNames: ["1", "2", "3", "4", "5"]),
            Message(text: "@alice checkout this cool link https://swift.org", type: .outgoing, isReply: false, imageName: "", imageNames: []),
            Message(text: "No media but very long long long text... " + getLongText(), type: .incoming, isReply: false, imageName: "", imageNames: []),
            Message(text: "single image with caption", type: .outgoing, isReply: false, imageName: "", imageNames: ["3"]),
            Message(text: "gallery up to 6", type: .incoming, isReply: false, imageName: "", imageNames: ["1", "2", "3", "4", "5", "6"]),
            Message(text: "edge case no text only images", type: .outgoing, isReply: false, imageName: "", imageNames: ["1", "2", "3"]),
            Message(text: "with reply and mention @bob", type: .incoming, isReply: true, imageName: "", imageNames: [])
        ]
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let message = messages[indexPath.row]
        let cell = ChatMessageNodeV1(message: message)
        cell.isForward = true
        return {cell}
    }
    
    func getLongText() -> String {
        return "incoming: Hello! 发动机哈市付款计划反馈萨达合法凯撒发生大幅度升级符i我饿依然我饿会更大发哈就撒更大飞机啊哈更大说法更大实际发很简单三个发神经东方国际阿萨代发给手机大发国际啊等说法估计是打发估计阿萨达高发季送达高发季阿萨代发噶几送达高发季阿萨达刚发刚发伤筋动骨放假啊都是高发季阿萨达高发季阿萨达高发季打撒刚发iu俄日我饿u一日青蛙恶意u地方噶世纪东方发动机哈市付款计划反馈萨达合法凯撒发生大幅度升级符i我饿依然我饿会更大发哈就撒更大飞机啊哈更大说法更大实际发很简单三个发神经东方国际阿萨代发给手机大发国际啊等说法估计是打发估计阿萨达高发季送达高发季阿萨代发噶几送达高发季阿萨达刚发刚发伤筋动骨放假啊都是高发季阿萨达高发季阿萨达高发季打撒刚发iu俄日我饿u一日青蛙恶意u地方噶世纪东方发动机哈市付款计划反馈萨达合法凯撒发生大幅度升级符i我饿依然我饿会更大发哈就撒更大飞机啊哈更大说法更大实际发很简单三个发神经东方国际阿萨代发给手机大发国际啊等说法估计是打发估计阿萨达高发季送达高发季阿萨代发噶几送达高发季发动机哈市付款计划反馈萨达合法凯撒发生大幅度升级符i我饿依然我饿会更大发哈就撒更大飞机啊哈更大说法更大实际发很发动机哈市付款计划反馈萨达合法凯撒发生大幅度升级符i我饿依然我饿会更大发哈就撒更大飞机啊哈更大说法更大实际发很简单三个发神经东方国际阿萨代发给手机大发国际啊等说法估计是打发估计阿萨达高发季送达高发季阿萨代发噶几送达高发季阿萨达刚发刚发伤筋动骨放假啊都是高发季阿萨达高发季阿萨达高发季打撒刚发iu俄日我饿u一日青蛙恶意u地方噶世纪东方范德萨合法化啥地方维护二哈发动机哈市付款计划反馈萨达合法凯撒发生大幅度升级符i我饿依然我饿会更大发哈就撒更大飞机啊哈更大说法更大实际发很简单三个发神经东方国际阿萨代发给手机大发国际啊等说法估计是打发估计阿萨达高发季送达高发季阿萨代发噶几送达高发季阿萨达刚发刚发伤筋动骨放假啊都是高发季阿萨达高发季阿萨达高发季打撒刚发iu俄日我饿u一日青蛙恶意u地方噶世纪东方发动机哈市付款计划反馈萨达合法凯撒发生大幅度升级符i我饿依然我饿会更大发哈就撒更大飞机啊哈更大说法更大实际发很简单三个发神经东方国际阿萨代发给手机大发国际啊等说法估计是打发估计阿萨达高发季送达高发季阿萨代发噶几送达高发季阿萨达刚发刚发伤筋动骨放假啊都是高发季阿萨达高发季阿萨达高发季打撒刚发iu俄日我饿u一日青蛙恶意u地方噶世纪东方发动机哈市付款计划反馈萨达合法凯撒发生大幅度升级符i我饿依然我饿会更大发哈就撒更大飞机啊哈更大说法更大实际发很简单三个发神经东方国际阿萨代发给手机大发国际啊等说法估计是打发估计阿萨达高发季送达高发季阿萨代发噶几送达高发季发动机哈市付款计划反馈萨达合法凯撒发生大幅度升级符i我饿依然我饿会更大发哈就撒更大飞机啊哈更大说法更大实际发很发动机哈市付款计划反馈萨达合法凯撒发生大幅度升级符i我饿依然我饿会更大发哈就撒更大飞机啊哈更大说法更大实际发很简单三个发神经东方国际阿萨代发给手机大发国际啊等说法估计是打发估计阿萨达高发季送达高发季阿萨代发噶几送达高发季阿萨达刚发刚发伤筋动骨放假啊都是高发季阿萨达高发季阿萨达高发季打撒刚发iu俄日我饿u一日青蛙恶意u地方噶世纪东方范德萨合法化啥地方维护二哈"
    }
    
}
//class ChatViewController: ASDKViewController<ASDisplayNode> {
//    
//    override init() {
//        let node = WelcomeNode()
//        super.init(node: node)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//}
//class WelcomeNode: ASDisplayNode {
//    private let titleNode = ASTextNode()
//    private let imageNode = ASImageNode()
//
//    override init() {
//        super.init()
//        automaticallyManagesSubnodes = true
//
//        titleNode.attributedText = NSAttributedString(string: "欢迎使用", attributes: [
//            .font: UIFont.boldSystemFont(ofSize: 24),
//            .foregroundColor: UIColor.black
//        ])
//
//        imageNode.image = UIImage(named: "welcome")
//        imageNode.contentMode = .scaleAspectFit
//        imageNode.style.preferredSize = CGSize(width: 120, height: 120)
//    }
//
//    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        let stack = ASStackLayoutSpec.vertical()
//        stack.spacing = 20
//        stack.justifyContent = .center
//        stack.alignItems = .center
//        stack.children = [imageNode, titleNode]
//        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 100, left: 20, bottom: 20, right: 20), child: stack)
//    }
//}
