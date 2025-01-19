local spell, super = Class("pacify", true)

function spell:init()
    super.init(self)
    
    self.check = "Spare a tired enemy by putting them to sleep."
end

function spell:onLightCast(user, target)
    if target.tired then
        Assets.playSound("spell_pacify")

        target:spare(true)

        local pacify_x, pacify_y = target:getRelativePos(target.width/2, target.height/2)
        local z_count = 0
        local z_parent = target.parent
        Game.battle.timer:every(1/15, function()
            z_count = z_count + 1
            local z = SpareZ(z_count * -40, pacify_x, pacify_y)
            z.layer = BATTLE_LAYERS["above_bullets"] + 1
            z_parent:addChild(z)
        end, 8)
    else
        local recolor = target:addFX(RecolorFX())
        Game.battle.timer:during(8/30, function()
            recolor.color = Utils.lerp(recolor.color, {0, 0, 1}, 0.12 * DTMULT)
        end, function()
            Game.battle.timer:during(8/30, function()
                recolor.color = Utils.lerp(recolor.color, {1, 1, 1}, 0.16 * DTMULT)
            end, function()
                target:removeFX(recolor)
            end)
        end)
    end
end

function spell:getLightCastMessage(user, target)
    local message = super.getLightCastMessage(self, user, target)
    if target.tired then
        return message
    elseif target.mercy < 100 then
        return message.."\n[wait:0.25s]* But the enemy wasn't [color:blue]TIRED[color:reset]..."
    else
        return message.."\n[wait:0.25s]* But the foe wasn't [color:blue]TIRED[color:reset]... try\n[color:"..Utils.rgbToHex(MagicalGlassLib.spare_color).."]SPARING[color:reset]."
    end
end

return spell