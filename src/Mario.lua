local Mario=class("Mario",function (picPath,rect)
	return cc.Sprite:create(picPath,rect)
end)

function Mario.create(picPath,rect)
    local sprite=Mario.new(picPath,rect)  
    return sprite
end

function Mario:animLeft()
    local frames={}
    for i=9,0,-1 do
        local frame=cc.SpriteFrame:create("walkLeft.png",cc.rect(18*i,0,18,32))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.03)   
    local animate=cc.Animate:create(animation)
    return animate
end

function Mario:animRight()
    local frames={}
    for i=0,9 do
        local frame=cc.SpriteFrame:create("walkRight.png",cc.rect(18*i,0,18,32))
        frames[#frames+1]=frame
    end 
    local animation=cc.Animation:createWithSpriteFrames(frames,0.03)   
    local animate=cc.Animate:create(animation)
    return animate
end



return Mario