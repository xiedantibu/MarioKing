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
Mario.isFlying=nil
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
    self.state=MarioState.NORMAL_RIGHT
    self.preState=MarioState.NORMAL_RIGHT
    self.face=MarioState.RIGHT
    self.bodyType=MarioBodyState.SMALL
    self.isDead=false
    self:initBodySprites()
end

function Mario.create()
    local node=Mario.new()
    node:addChild(node.mainBody) 
    return node
end

function Mario:initBodySprites()
	self.normalJumpLeft=cc.Sprite:create(pic_mario_normal_left,cc.rect(18*10,0,18,32))
	self.normalLeft=cc.Sprite:create(pic_mario_normal_left,cc.rect(0,0,18,32))
	self.normalJumpRight=cc.Sprite:create(pic_mario_normal_right,cc.rect(18*10,0,18,32))
	self.normalRight=cc.Sprite:create(pic_mario_normal_right,cc.rect(0,0,18,32))
	
    self.smallJumpLeft=cc.SpriteFrame:create(pic_mario_small_left,cc.rect(14*10,0,14,16))
    self.smallJumpLeft:retain()
    self.smallLeft=cc.SpriteFrame:create(pic_mario_small_left,cc.rect(0,0,14,16))
    self.smallLeft:retain()
    self.smallJumpRight=cc.SpriteFrame:create(pic_mario_small_right,cc.rect(14*10,0,14,16))
    self.smallJumpRight:retain()
    self.smallRight=cc.SpriteFrame:create(pic_mario_small_right,cc.rect(14*8,0,14,16))
    self.smallRight:retain()
    self.smallDie=cc.SpriteFrame:create(pic_mario_small_die,cc.rect(16,0,16,18))
    self.smallDie:retain()
    --init mainBody
    self:setContentSize(self.smallSize)
    self.mainBody=cc.Sprite:createWithSpriteFrame(self.smallRight)
    self.mainBody:setAnchorPoint(0,0)
    
end

function Mario:setMarioState(_state)
    if self.isDead or self.state==_state then
        return
    end
    self.preState=self.state
    self.state=_state
    self.mainBody:stopAllActions()
    if MarioState.NORMAL_RIGHT==_state then
        self.face=MarioState.RIGHT
        self.mainBody:setSpriteFrame(self.smallRight)
    elseif MarioState.NORMAL_LEFT==state then
        self.face=MarioState.LEFT
        self.mainBody:setSpriteFrame(self.smallLeft)
    elseif MarioState.RIGHT==_state then
        if not self.isFlying then
            self.mainBody:runAction(cc.RepeatForever:create(cc.Animate:create(self:marioAnimSmallRight())))
            self.face=MarioState.RIGHT
        end
   elseif MarioState.LEFT==_state then
        if not self.isFlying then
            self.mainBody:runAction(cc.RepeatForever:create(cc.Animate:create(self:marioAnimSmallLeft())))
            self.face=MarioState.LEFT
        end
    elseif MarioState.JUMP_LEFT==_state then
        self.face=MarioState.LEFT
        self.mainBody:setSpriteFrame(self.smallJumpLeft)
    elseif MarioState.JUMP_RIGHT==_state then
        self.face=MarioState.RIGHT
        self.mainBody:setSpriteFrame(self.smallJumpRight)
    else
    end
end


function Mario:dieForTrap()
	self.mainBody:stopAllActions()
	self.mainBody:setSpriteFrame(self.smallDie)
	self.mainBody:runAction(cc.Animate:create(self:marioAnimSmallDie()))
	
	local moveUp=cc.MoveBy:create(0.6,cc.p(0,32))
	local moveDown=cc.MoveBy:create(0.6,cc.p(0,-32))
	local delay=cc.DelayTime:create(0.2)
	
	local function reSetNonVisible()
		self.mainBody:stopAllActions()
		self:setVisible(false)
	end
	
    self:runAction(cc.Sequence:create(moveUp,delay,moveDown,cc.CallFunc:create(reSetNonVisible)))
end

function Mario:marioAnimSmallLeft()
    local frames={}
    for i=9,0,-1 do
        local frame=cc.SpriteFrame:create(pic_mario_small_left,cc.rect(14*i,0,14,16))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.03)   
    return animation
end

function Mario:marioAnimSmallRight()
    local frames={}
    for i=0,9 do
        local frame=cc.SpriteFrame:create(pic_mario_small_right,cc.rect(14*i,0,14,16))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.03)   
    return animation
end

function Mario:marioAnimSmallDie()
    local frames={}
    for i=0,7 do
        local frame=cc.SpriteFrame:create(pic_mario_small_die,cc.rect(16*i,0,16,18))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.1)   
    return animation
end

return Mario