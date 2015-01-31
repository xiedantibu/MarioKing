local Mario=class("Mario",function ()
	return cc.Node:create()
end)

Mario.mainBody=nil
Mario.mainTemp=nil
Mario.normalSize=nil
Mario.smallSize=nil
Mario.curSize=nil
Mario.bodyType=nil
Mario.state=nil
Mario.preState=nil
Mario.face=nil
Mario.isDead=nil
--kinds of body sprites
Mario.normalJumpLeft=nil
Mario.normalLeft=nil
Mario.normalJumpRight=nil
Mario.normalRight=nil

Mario.smallJumpLeft=nil
Mario.smallLeft=nil
Mario.smallJumpRight=nil
Mario.smallRight=nil



function Mario:ctor()
	cclog("Mario ctor")
	self.normalSize=cc.size(18,32)
    self.smallSize=cc.size(14,16)
	self.curSize=self.smallSize
	self.state=M_NORMAL_RIGHT
    self.preState=M_NORMAL_RIGHT
    self.face=M_RIGHT
    self.bodyType=M_BODY_SMALL
    self.isDead=false
    self:initBodySprites()
end

function Mario:initBodySprites(parameters)
	self.normalJumpLeft=cc.Sprite:create(pic_mario_normal_left,cc.rect(18*10,0,18,32))
	self.normalLeft=cc.Sprite:create(pic_mario_normal_left,cc.rect(0,0,18,32))
	self.normalJumpRight=cc.Sprite:create(pic_mario_normal_right,cc.rect(18*10,0,18,32))
	self.normalRight=cc.Sprite:create(pic_mario_normal_right,cc.rect(0,0,18,32))
	
    self.smallJumpLeft=cc.Sprite:create(pic_mario_small_left,cc.rect(14*10,0,14,16))
    self.smallLeft=cc.Sprite:create(pic_mario_small_left,cc.rect(0,0,14,16))
    self.smallJumpRight=cc.Sprite:create(pic_mario_small_right,cc.rect(14*10,0,14,16))
    self.smallRight=cc.Sprite:create(pic_mario_small_right,cc.rect(0,0,14,16))
    
    --init mainBody
    self.mainBody=self.smallRight
    self.mainBody:setAnchorPoint(0,0)
    
end

function Mario.create()
    local node=Mario.new()
    node:addChild(node.mainBody) 
    return node
end





return Mario