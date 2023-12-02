local spell, super = Class("red_buster", true)

function spell:onLightCast(user, target)
    Game.battle.timer:after(15/30, function()
        Assets.playSound("rudebuster_swing")
        local x, y = (SCREEN_WIDTH/2), SCREEN_HEIGHT + 250
        local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
        local blast = LightRudeBusterBeam(true, x, y, tx, ty, function(pressed)
            local damage = self:getDamage(user, target, pressed)
            if pressed then
                Assets.playSound("scytheburst")
            end
            target:hurt(damage, user)
            Game.battle:finishAction()
        end)
        blast.layer = BATTLE_LAYERS["above_ui"]
        Game.battle:addChild(blast)
    end)
    return false
end

return spell