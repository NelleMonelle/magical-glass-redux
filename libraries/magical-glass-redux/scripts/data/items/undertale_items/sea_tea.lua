local item, super = Class(HealItem, "undertale/sea_tea")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Sea Tea"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "drink"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "drinks"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    self.heal_amount = 10

    -- Shop description
    self.shop = "SPEED\nup in\nbattle."
    -- Default shop price (sell price is halved)
    self.price = 18
    -- Default shop sell price
    self.sell_price = 5
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Made from glowing marshwater."

    -- Light world check text
    self.check = "Heals 10 HP\n* Made from glowing marshwater.\n* Increases SPEED for one battle."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false
    
end

function item:getLightBattleText(user, target, boost)
    return "* "..target.chara:getNameOrYou().." "..self:getUseMethod(target.chara).." the Sea Tea."..(boost and "\n* Your SPEED boosts!" or "")
end

function item:onLightBattleUse(user, target)
    local boost = false
    if Game.battle.soul_speed_bonus < 4 then
        Game.battle.soul_speed_bonus = Game.battle.soul_speed_bonus + 1
        Game.battle.soul.speed = Game.battle.soul.speed + 1
        boost = true
    end
    self:battleUseSound(user, target)

    local amount = self:getBattleHealAmount(target.chara.id)
    for _,equip in ipairs(user.chara:getEquipment()) do
        if equip.getHealBonus then
            amount = amount + equip:getHealBonus()
        end
    end
    target:heal(amount)
    Game.battle:battleText(self:getLightBattleText(user, target, boost).."\n"..self:getLightBattleHealingText(user, target, amount))
    return true
end

function item:onBattleUse(user, target)
    if Game.battle.soul_speed_bonus < 4 then
        Game.battle.soul_speed_bonus = Game.battle.soul_speed_bonus + 1
    end
    Assets.stopAndPlaySound("speedup")

    local amount = self:getBattleHealAmount(target.chara.id)
    for _,equip in ipairs(user.chara:getEquipment()) do
        if equip.getHealBonus then
            amount = amount + equip:getHealBonus()
        end
    end
    target:heal(amount)
    return true
end

function item:getBattleText(user, target)
    return super.getBattleText(self, user, target) .. (Game.battle.soul_speed_bonus < 4 and "\n* Your SPEED boosts!" or "")
end

function item:battleUseSound(user, target)
    Game.battle.timer:script(function(wait)
        Assets.stopAndPlaySound("swallow")
        wait(0.4)
        Assets.stopAndPlaySound("speedup")
    end)
end

function item:worldUseSound(target)
    Game.world.timer:script(function(wait)
        Assets.stopAndPlaySound("swallow")
        wait(0.4)
        Assets.stopAndPlaySound("speedup")
    end)
end

return item