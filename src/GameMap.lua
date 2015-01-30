local GameMap=class("GameMap",function (tmxFile)
    return cc.TMXTiledMap:create(tmxFile)
end)

GameMap.tileSize=nil
GameMap.mapSize=nil
GameMap.cloudLayer=nil
GameMap.blockLayer=nil
GameMap.pipeLayer=nil
GameMap.landLayer=nil
GameMap.trapLayer=nil
GameMap.objectLayer=nil
GameMap.coinLayer=nil
GameMap.flagpoleLayer=nil


function GameMap.create(tmxFile)
    local gameMap=GameMap.new(tmxFile)
    gameMap:extraInit()
    return gameMap
end

function GameMap:extraInit()
    self.tileSize=self:getTileSize()
    self.mapSize=self:getMapSize()
    cclog("tile:%d,%d,map:%d,%d",self.tileSize.width,self.tileSize.height,self.mapSize.width,self.mapSize.height)

    --just for easy coding -.-||
    --map=cc.TMXTiledMap:new()
    self.cloudLayer=self:getLayer("cloud")
    self.blockLayer=self:getLayer("block")
    self.pipeLayer=self:getLayer("pipe")
    self.landLayer=self:getLayer("land")
    self.trapLayer=self:getLayer("trap")
    self.objectLayer=self:getObjectGroup("objects")
    self.coinLayer=self:getLayer("coin")
    self.flagpoleLayer=self:getLayer("flagpole")    
    cclog("%s,%s,%s,%s",type(self.cloudLayer),type(self.blockLayer),type(self.pipeLayer),type(self.landLayer))
    cclog("%s,%s,%s,%s",type(self.trapLayer),type(self.objectLayer),type(self.coinLayer),type(self.flagpoleLayer))
    self:initObjects()

end

function GameMap:initObjects()
	local objects=self.objectLayer:getObjects()
	cclog("objects type:%s",type(objects))
    cclog("object count:%d",#objects)
	for i,v in ipairs(objects) do
	   cclog("object type:%s",type(v))
	   if v~=nil then
	       --cclog("name:%s,type:%s",v.name,v.type)
	       --cclog("x:%d,y:%d",v.x,v.y)
	       --cclog("width:%d,height:%d",v.width,v.height)
	       if v.name=="enemy" then
                if v.type=="mushroom" then
                    
                end
	       end
	   end
	end
end

return GameMap