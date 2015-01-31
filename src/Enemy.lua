local Enemy=class("Enemy",function ()
	return cc.Node:create()
end)

Enemy.type=nil
Enemy.name=nil
Enemy.position=nil
Enemy.visible=nil
Enemy.body=nil
Enemy.lifeOver=nil
Enemy.startFace=nil
Enemy.moveOffset=nil
Enemy.ccMoveOffset=nil
Enemy.jumpOffset=nil
Enemy.ccJumpOffset=nil
Enemy.state=nil

function Enemy:ctor()
    --cclog("Enemy ctor")
    self.startFace=M_LEFT
    self.moveOffset=0.0
    self.ccMoveOffset=0.6
    self.jumpOffset=0.0
    self.ccJumpOffset=0.3
    self.state=E_STATE_NONACTIVE
end

function Enemy.create()
	local node=Enemy.new()
	Enemy:createMushRoom()
	node:addChild(Enemy.body)
	node:setContentSize(16,16)
	node:setAnchorPoint(cc.p(0.5,0))
	return node
end

function Enemy:createMushRoom()
    --cclog("Enemy createMushRoom")
    self.type="mushroom"
	self.body=cc.Sprite:create(pic_mushroom,cc.rect(0,0,16,16))
    self.body:setAnchorPoint(cc.p(0,0))
    self.lifeOver=cc.Sprite:create(pic_mushroom,cc.rect(32,0,16,16))
end

return Enemy