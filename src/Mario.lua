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
Mario.isSafeTime=nil
--kinds of body sprites
Mario.normalJumpLeft=nil
Mario.normalLeft=nil
Mario.normalJumpRight=nil
Mario.normalRight=nil

Mario.smallJumpLeft=nil
Mario.smallLeft=nil
Mario.smallJumpRight=nil
Mario.smallRight=nil

Mario.lifeCnt=3



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
	self.normalJumpLeft:retain()
	self.normalLeft=cc.Sprite:create(pic_mario_normal_left,cc.rect(0,0,18,32))
	self.normalLeft:retain()
	self.normalJumpRight=cc.Sprite:create(pic_mario_normal_right,cc.rect(18*10,0,18,32))
	self.normalJumpRight:retain()
	self.normalRight=cc.Sprite:create(pic_mario_normal_right,cc.rect(0,0,18,32))
	self.normalRight:retain()
	self.normalDie=cc.SpriteFrame:create(pic_mario_normal_die ,cc.rect(24,0,24,34))
	self.normalDie:retain()
	
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
        if self.bodyType==MarioBodyState.NORMAL then
            self.mainBody:setSpriteFrame(self.normalRight) 
        else
            self.mainBody:setSpriteFrame(self.smallRight)
        end
    elseif MarioState.NORMAL_LEFT==state then
        self.face=MarioState.LEFT
        if self.bodyType==MarioBodyState.NORMAL then
            self.mainBody:setSpriteFrame(self.normalLeft)
        else
            self.mainBody:setSpriteFrame(self.smallLeft)
        end
    elseif MarioState.RIGHT==_state then
        if not self.isFlying then
            if self.bodyType==MarioBodyState.NORMAL then
                self.mainBody:runAction(cc.RepeatForever:create(cc.Animate:create(self:marioAnimNormalRight())))
            else
                self.mainBody:runAction(cc.RepeatForever:create(cc.Animate:create(self:marioAnimSmallRight())))
            end
            self.face=MarioState.RIGHT
        end
   elseif MarioState.LEFT==_state then
        if not self.isFlying then
            if self.bodyType==MarioBodyState.NORMAL then
                self.mainBody:runAction(cc.RepeatForever:create(cc.Animate:create(self:marioAnimNormalLeft())))
            else
                self.mainBody:runAction(cc.RepeatForever:create(cc.Animate:create(self:marioAnimSmallLeft())))
            end
            self.face=MarioState.LEFT
        end
    elseif MarioState.JUMP_LEFT==_state then
        self.face=MarioState.LEFT
        if self.bodyType==MarioBodyState.NORMAL then
            self.mainBody:setsetSpriteFrame(self.normalJumpLeft)
        else
            self.mainBody:setSpriteFrame(self.smallJumpLeft)
        end
    elseif MarioState.JUMP_RIGHT==_state then
        self.face=MarioState.RIGHT
        if self.bodyType==MarioBodyState.NORMAL then
            self.mainBody:setSpriteFrame(self.normalJumpRight)
        else
            self.mainBody:setSpriteFrame(self.smallJumpRight)
        end
    else
    end
end

function Mario:setBodyType(_type)
	self.bodyType=_type
	if _type==MarioBodyState.NORMAL then
	   self.curSize=self.normalSize
	   self.mainBody:setSpriteFrame(self.normalRight)
	elseif _type==MarioBodyState.SMALL then
	   self.curSize=self.smallSize
	   self.mainBody:setSpriteFrame(self.normalRight)
	else
	end
    self:setContentSize(self.curSize)
end

function Mario:changeForGotMushroom()
	if self.bodyType==MarioBodyState.SMALL then
	   self:setBodyTypeForNormal()
	   local blink=cc.Blink:create(1,5)
	   self:runAction(blink)
	elseif self.bodyType==MarioBodyState.NORMAL then
	   
	else
	end
end

function Mario:changeForGotEnemy()
    slef.isSafeTime=true
    local delay=cc.DelayTime:create(3.0)
    local function resetSafeTime()
    	self.isSafeTime=false
    end
    self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(resetSafeTime)))
    if self.bodyType==MarioBodyState.NORMAL then
        self:setBodyTypeForSmall()
        local blink=cc.Blink:create(3,15)
        self:runAction(blink)
    elseif self.bodyType==MarioBodyState.SMALL then
        self.mainBody:stopAllActions()
        self.mainBody:setSpriteFrame(self.smallDie)
        self.isDead=true
    else
    end
end

function Mario:setBodyTypeForNormal()
	self.bodyType=MarioBodyState.NORMAL
	if self.face==MarioState.LEFT then
	   self.mainBody:setSpriteFrame(self.normalLeft)
	elseif self.face==MarioState.RIGHT then
	   self.mainBody:setSpriteFrame(self.normalRight)
	else
	end
end

function Mario:setBodyTypeForSmall()
	self.bodyType=MarioBodyState.SMALL
	if self.face==MarioState.LEFT then
       self.mainBody:setSpriteFrame(self.smallLeft)
    elseif self.face==MarioState.RIGHT then
       self.mainBody:setSpriteFrame(self.smallRight)
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
    for i=0,10 do
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

function Mario:marioAnimNormalLeft()
    local frames={}
    for i=9,0,-1 do
        local frame=cc.SpriteFrame:create(pic_mario_normal_left,cc.rect(18*i,0,18,32))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.02)   
    return animation
end

function Mario:marioAnimNormalRight()
    local frames={}
    for i=0,10 do
        local frame=cc.SpriteFrame:create(pic_mario_normal_right,cc.rect(18*i,0,18,32))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.02)   
    return animation
end

function Mario:marioAnimNormalDie()
    local frames={}
    for i=0,7 do
        local frame=cc.SpriteFrame:create(pic_mario_normal_die,cc.rect(24*i,0,24,34))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.1)   
    return animation
end

return Mario