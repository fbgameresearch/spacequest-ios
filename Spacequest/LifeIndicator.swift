//
// Copyright (c) 2016 Rafał Sroka
//
// Licensed under the GNU General Public License, Version 3.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
//   https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SpriteKit

class LifeIndicator: SKSpriteNode {
    
    fileprivate var titleLabelNode: SKLabelNode?
    fileprivate var lifePoints: Int = 100 {
        didSet {
            update(animated: false)
        }
    }
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(texture: SKTexture!) {
        super.init(texture: texture,
                   color: UIColor.brown,
                   size: texture.size())
        
        // Configure title
        self.titleLabelNode = SKLabelNode(fontNamed: FontName.Wawati.rawValue)
        self.titleLabelNode!.fontSize = 14.0
        self.titleLabelNode!.fontColor = UIColor(white: 1.0, alpha: 0.7)
        self.titleLabelNode!.horizontalAlignmentMode = .center
        self.titleLabelNode!.verticalAlignmentMode = .center
        
        self.update(animated: false)
        
        self.addChild(titleLabelNode!)
    }
    
    // MARK: - Configuration
    
    func setLifePoints(_ points: Int, animated: Bool) {
        self.lifePoints = points
        
        self.update(animated: animated)
    }
    
    fileprivate func update(animated: Bool) {
        self.titleLabelNode!.text = "\(lifePoints)"
        
        let blendColor = lifeBallColor()
        let blendFactor: CGFloat = 1.0
        
        if animated {
            let colorizeAction = SKAction.colorize(with: blendColor, colorBlendFactor: blendFactor, duration: 0.2)
            let scaleUpAction = SKAction.scale(by: 1.2, duration: 0.2)
            let scaleActionSequence = SKAction.sequence([scaleUpAction, scaleUpAction.reversed()])
            
            self.titleLabelNode!.color = blendColor
            self.titleLabelNode!.colorBlendFactor = blendFactor
            
            self.run(SKAction.group([colorizeAction, scaleActionSequence]))
        } else {
            self.color = blendColor
            self.colorBlendFactor = blendFactor
            self.titleLabelNode!.color = blendColor
            self.titleLabelNode!.colorBlendFactor = blendFactor
        }
    }
    
    fileprivate func lifeBallColor() -> UIColor {
        var fullBarColorR: CGFloat = 0.0, fullBarColorG: CGFloat = 0.0, fullBarColorB: CGFloat = 0.0, fullBarColorAlpha: CGFloat = 0.0
        var emptyBarColorR: CGFloat = 0.0, emptyBarColorG: CGFloat = 0.0, emptyBarColorB: CGFloat = 0.0, emptyBarColorAlpha: CGFloat = 0.0
        
        UIColor.green.getRed(&fullBarColorR, green: &fullBarColorG, blue: &fullBarColorB, alpha: &fullBarColorAlpha)
        UIColor.red.getRed(&emptyBarColorR, green: &emptyBarColorG, blue: &emptyBarColorB, alpha: &emptyBarColorAlpha)
        
        let resultColorR = emptyBarColorR + CGFloat(self.lifePoints)/100 * (fullBarColorR - emptyBarColorR)
        let resultColorG = emptyBarColorG + CGFloat(self.lifePoints)/100 * (fullBarColorG - emptyBarColorG)
        let resultColorB = emptyBarColorB + CGFloat(self.lifePoints)/100 * (fullBarColorB - emptyBarColorB)
        
        return UIColor(red: resultColorR, green: resultColorG, blue: resultColorB, alpha: 1.0)
    }
    
}
