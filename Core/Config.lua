-- Config.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 8/31/2019, 7:22:32 PM

---@type ns
local ns = select(2, ...)
---@type L
local L = ns.L

---- WOW
local GetSpellInfo = GetSpellInfo
local GetItemClassInfo = GetItemClassInfo
local GetItemSubClassInfo = GetItemSubClassInfo

local function Rule(name, icon, rule, c)
    local children
    if c then
        children = {}
        local exists = {}
        for i, v in ipairs(c) do
            local isAdv = ns.IsAdvanceRule(v)
            if isAdv and not exists[v.rule] then
                tinsert(children, v)
                exists[v.rule] = true
            end
            if not isAdv then
                tinsert(children, v)
            end
        end
    end
    return {rule = rule, comment = name, icon = icon, children = children}
end

local function Group(name, icon, children)
    return Rule(name, icon, nil, children)
end

local function Type(type, icon, children)
    local name = GetItemClassInfo(type)
    return Rule(name, icon, 'type:' .. name, children)
end

local function SubType(type, subType, icon, children)
    local name = GetItemSubClassInfo(type, subType)
    return Rule(name, icon, 'type:' .. name, children)
end

local function Weapon(subType, icon, children)
    return SubType(LE_ITEM_CLASS_WEAPON, subType, icon, children)
end

local function Slot(name, icon, children)
    return Rule(name, icon, 'slot:' .. name, children)
end

local function TipLocale(key, icon, children)
    return Rule(L['COMMENT_' .. key], icon, 'tip:' .. L['KEYWORD_' .. key], children)
end

local function Tip(tip, icon, children)
    return Rule(tip, icon, 'tip:' .. tip, children)
end

local function Spell(id, icon, children)
    local spellName = GetSpellInfo(id)
    if not spellName then
        spellName = "spell: " .. id
    end
    return Rule(spellName, icon, 'spell:' .. spellName, children)
end

local KEYS = GetItemClassInfo(LE_ITEM_CLASS_KEY) -- 钥匙
local ARMOR = GetItemClassInfo(LE_ITEM_CLASS_ARMOR) -- 装备
local WEAPON = GetItemClassInfo(LE_ITEM_CLASS_WEAPON) -- 装备
-- local GEMS = GetItemClassInfo(LE_ITEM_CLASS_GEM) -- 宝石
local QUEST = GetItemClassInfo(LE_ITEM_CLASS_QUESTITEM) -- 任务
local CONSUMABLE = GetItemClassInfo(LE_ITEM_CLASS_CONSUMABLE) -- 消耗品
local MISC = GetItemClassInfo(LE_ITEM_CLASS_MISCELLANEOUS) -- 其它
local MAGIC_ITEMS = "魔法物品" -- 魔法物品

ns.DEFAULT_CUSTOM_ORDER = {
    HEARTHSTONE_ITEM_ID, -- 炉石
    TipLocale('MOUNT', 132261), -- 坐骑
    Rule(KEYS, 134237, 'type:' .. KEYS, {
        Type(LE_ITEM_CLASS_KEY, 134237), -- 钥匙
    }), -- 钥匙gz_magegz
    Group(L['Tools'], 134065, {
        5060, -- 潜行者工具
        2901, -- 矿工锄
        5956, -- 铁匠锤
        7005, -- 剥皮刀
        Weapon(LE_ITEM_WEAPON_FISHINGPOLE, 132932), -- 鱼竿
    }), -- 工具物品
    Rule(ARMOR, 132722, 'type:' .. ARMOR, {
        Slot(INVTYPE_HEAD, 133136), -- 头部
        Slot(INVTYPE_NECK, 133294), -- 颈部
        Slot(INVTYPE_SHOULDER, 135033), -- 肩部
        Slot(INVTYPE_CLOAK, 133768), -- 背部
        Slot(INVTYPE_CHEST, 132644), -- 胸部
        Slot(INVTYPE_ROBE, 132644), -- 胸部
        Slot(INVTYPE_WRIST, 132608), -- 手腕
        Slot(INVTYPE_HAND, 132948), -- 手
        Slot(INVTYPE_WAIST, 132511), -- 腰部
        Slot(INVTYPE_LEGS, 134588), -- 腿部
        Slot(INVTYPE_FEET, 132541), -- 脚
        Slot(INVTYPE_FINGER, 133345), -- 手指
        Slot(INVTYPE_TRINKET, 134010), -- 饰品
        Slot(INVTYPE_BODY, 135022), -- 衬衣
        Slot(INVTYPE_TABARD, 135026), -- 战袍
    }), -- 装备
    Rule(WEAPON, 132722, 'type:' .. WEAPON, {
        Slot(INVTYPE_2HWEAPON, 135324), -- 双手
        Slot(INVTYPE_WEAPONMAINHAND, 133045), -- 主手
        Slot(INVTYPE_WEAPON, 135641), -- 单手
        Slot(INVTYPE_SHIELD, 134955), -- 副手盾
        Slot(INVTYPE_WEAPONOFFHAND, 134955), -- 副手
        Slot(INVTYPE_HOLDABLE, 134333), -- 副手物品
        Slot(INVTYPE_RANGED, 135498), -- 远程
        Weapon(LE_ITEM_WEAPON_GUNS, 135610), -- 枪
        Weapon(LE_ITEM_WEAPON_CROSSBOW, 135533), -- 弩
        Weapon(LE_ITEM_WEAPON_THROWN, 135427), -- 投掷武器
        Weapon(LE_ITEM_WEAPON_WAND, 135427), -- 魔杖
        Slot(INVTYPE_RELIC, 134915), -- 圣物
    }), -- 武器
    Type(LE_ITEM_CLASS_CONTAINER, 133652), -- 容器
    Type(LE_ITEM_CLASS_RECIPE, 134939), -- 配方
    Type(LE_ITEM_CLASS_TRADEGOODS, 132905, {
        TipLocale('CLASS', 132273), -- 职业
    }), -- 商业物品
    Rule(CONSUMABLE, 134829, 'type:' .. CONSUMABLE .. ' & tip:!' .. QUEST, {
        TipLocale('CLASS', 132273), -- 职业
        Spell(746, 133685), -- 急救
        Spell(439, 134830), -- 治疗药水
        Spell(438, 134851), -- 法力药水
    }), -- 消耗品
    -- Type(LE_ITEM_CLASS_GEM, 133587), -- 宝石
    Type(LE_ITEM_CLASS_REAGENT, 133587), -- 材料
    Rule(MISC, 134400, 'type:!' .. QUEST .. ' & tip:!' .. QUEST, {
        Type(LE_ITEM_CLASS_MISCELLANEOUS, 134400), -- 其它
    }), -- 杂项
    Type(LE_ITEM_CLASS_QUIVER, 134407), -- 箭袋
    Type(LE_ITEM_CLASS_PROJECTILE, 132382), -- 弹药
    Rule(QUEST, 133469, 'type:' .. QUEST .. ' | tip:' .. QUEST, {
        Tip(ITEM_STARTS_QUEST, 132836), -- 触发任务的物品
    }), -- 任务物品
    Rule(MAGIC_ITEMS, 132794, 'type:' .. CONSUMABLE .. ' | tip:!' .. QUEST, {
        Rule(nil, 133942, 'spell'), -- 法术产物
        Spell(433, 133945), -- 食物
        Spell(430, 132794), -- 水
        -- Spell(5699, 9421), -- 治疗石
        -- Spell(759, 5514), -- 法力玛瑙
        -- Spell(3552, 5513), -- 法力翡翠
        -- Spell(10053, 8007), -- 魔法黄水晶
        -- Spell(10054, 8008), -- 魔法红宝石
        -- Spell(6265, 6265), -- 魔法红宝石
    }), -- 魔法物品
}
