local AnimationManager={}
AnimationManager.__index=AnimationManager

function AnimationManager:marioAnimLeft()
    local frames={}
    for i=9,0,-1 do
        local frame=cc.SpriteFrame:create("walkLeft.png",cc.rect(18*i,0,18,32))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.03)   
    return animation
end

function AnimationManager:marioAnimRight()
    local frames={}
    for i=0,9 do
        local frame=cc.SpriteFrame:create("walkRight.png",cc.rect(18*i,0,18,32))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.03)   
    return animation
end

function AnimationManager:marioAnimSmallLeft()
    local frames={}
    for i=9,0,-1 do
        local frame=cc.SpriteFrame:create(pic_mario_small_left,cc.rect(14*i,0,14,16))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.03)   
    return animation
end

function AnimationManager:marioAnimSmallRight()
    local frames={}
    for i=0,9 do
        local frame=cc.SpriteFrame:create(pic_mario_small_right,cc.rect(14*i,0,14,16))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.03)   
    return animation
end


function AnimationManager:initAnimations()
    --self:marioAnimLeft()
    --self:marioAnimRight()
    local animCache=cc.AnimationCache:getInstance()
    animCache:addAnimation(self:marioAnimSmallLeft(),AnimType.SMALL_LEFT)
    animCache:addAnimation(self:marioAnimSmallRight(),AnimType.SMALL_RIGHT)
end

function AnimationManager:createAnimate(type)
	
end