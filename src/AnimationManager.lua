local AnimationManager=AnimationManager or {}

s_animMgr=AnimationManager

function AnimationManager:marioAnimLeft()
    local frames={}
    for i=9,0,-1 do
        local frame=cc.SpriteFrame:create("walkLeft.png",cc.rect(18*i,0,18,32))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.03)   
    local animate=cc.Animate:create(animation)
    return animate
end

function AnimationManager:marioAnimRight()
    local frames={}
    for i=0,9 do
        local frame=cc.SpriteFrame:create("walkRight.png",cc.rect(18*i,0,18,32))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.03)   
    local animate=cc.Animate:create(animation)
    return animate
end


function AnimationManager:createAnimate(type)
	
end