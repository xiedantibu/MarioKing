local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)

GameScene.player=nil
GameScene.mainMap=nil

function GameScene.create()
    local scene = GameScene.new()
    scene:addChild(scene:createLayerFarm())
    return scene
end



function GameScene:createLayerFarm()
    local layer=cc.Layer:create()
    
    self:initMap()
    layer:addChild(self.mainMap)
     
    return layer
end

function GameScene:initMap()
	local gameMap=require("GameMap")
	self.mainMap=gameMap.create(tmx_map_1)
end

function GameScene:playBgMusic()
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("OnLand.wma")
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath,true)
end

return GameScene