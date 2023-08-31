local LightEnemySprite, super = Class(Object)

function LightEnemySprite:init(actor)
    if type(actor) == "string" then
        actor = Registry.createActor(actor)
    end

    super.init(self)

    self.actor = actor
    self.parts = self.actor.light_battler_parts
    
    for _,part in pairs(self.parts) do
        if part.sprite then
            local sprite
            if type(part.sprite) == "string" then
                sprite = Sprite(part.sprite)
            elseif type(part.sprite) == "function" then
                if type(part.sprite()) == "string" then
                    sprite = Sprite(part.sprite())
                elseif part.sprite():includes(Sprite) then
                    sprite = part:sprite()
                end
            end
            self:addChild(sprite)
        else
            local sprite
            if self.actor:getDefaultAnim() then
                sprite = Sprite(self.actor:getPath() .. "/" .. self.actor:getDefaultAnim())
            elseif self.actor:getDefaultSprite() then
                sprite = Sprite(self.actor:getPath() .. "/" .. self.actor:getDefaultSprite())
            else
                sprite = Sprite((self.actor:getPath() .. "/" .. self.actor:getDefault()))
            end
            self:addChild(sprite)
        end

        part:init()
    end

    if actor then
        actor:onSpriteInit(self)
    end

    self:resetSprite()
end

function LightEnemySprite:setActor(actor)
    if type(actor) == "string" then
        actor = Registry.createActor(actor)
    end

    if self.actor and self.actor.id == actor.id then
        return
    end

    for _,child in ipairs(self.children) do
        self:removeChild(child)
    end

    self.actor = actor
    self.parts = self.actor.light_battler_parts

    self.width = actor:getWidth()
    self.height = actor:getHeight()
    self.path = actor:getSpritePath()

    actor:onSpriteInit(self)
    self:resetSprite()

end

function LightEnemySprite:resetSprite(ignore_actor_callback)
    if not ignore_actor_callback and self.actor:preResetSprite(self) then
        return
    end

    for _,part in pairs(self.parts) do
        if part.sprite then
            local sprite
            if type(part.sprite) == "string" then
                sprite = Sprite(part.sprite)
            elseif type(part.sprite) == "function" then
                if type(part.sprite()) == "string" then
                    sprite = Sprite(part.sprite())
                elseif part.sprite():includes(Sprite) then
                    sprite = part:sprite()
                end
            end
            self:addChild(sprite)
        else
            local sprite
            if self.actor:getDefaultAnim() then
                sprite = Sprite(self.actor:getPath() .. "/" .. self.actor:getDefaultAnim())
            elseif self.actor:getDefaultSprite() then
                sprite = Sprite(self.actor:getPath() .. "/" .. self.actor:getDefaultSprite())
            else
                sprite = Sprite((self.actor:getPath() .. "/" .. self.actor:getDefault()))
            end
            self:addChild(sprite)
        end
    end

    self.actor:onResetSprite(self)
end

function LightEnemySprite:update()
    if self.run_away then
        self.run_away_timer = self.run_away_timer + DTMULT
    end

    for _,part in pairs(self.parts) do
        if part.update then
            part:update(part.sprite)
        end
    end

    super.update(self)

    self.actor:onSpriteUpdate(self)
end

function LightEnemySprite:draw()
    if self.actor:preSpriteDraw(self) then
        return
    end

    if self.texture and self.run_away then
        local r,g,b,a = self:getDrawColor()
        for i = 0, 80 do
            local alph = a * 0.4
            Draw.setColor(r,g,b, ((alph - (self.run_away_timer / 8)) + (i / 200)))
            Draw.draw(self.texture, i * 2, 0)
        end
        return
    end

    super.draw(self)
end

return LightEnemySprite