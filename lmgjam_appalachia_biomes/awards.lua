-- clear out non-appalachia awards
-- todo: move this to a modpack or game mod
if core.get_modpath("awards") then
    -- This ensures the following code is executed after all items have been registered
    -- a few awards are registered this way at time 0,
    core.after(1, function()
        -- remove all non lmgjam awards
        local keep_awards = {}
        for name, def in pairs(awards.registered_awards) do
            if string.find(name, "lmgjam") then
                keep_awards[name] = def
            end
        end
        awards.registered_awards = keep_awards
    end)

    awards.register_award("lmgjam_appalachia_biomes:pawpaw", {
        description = "Pick 5 Pawpaw Fruits",
        title =  "Pick 5 Pawpaw Fruits",
        trigger = {
            type   = "dig",
            node   = "lmgjam_appalachia_biomes:pawpaw",
            target = 5,
        },
        icon = "lmgjam_appalachia_biomes_pawpaw.png"
    })

    awards.register_award("lmgjam_appalachia_biomes:mineshaft", {
        description = "Find a surface mineshaft and dig 5 blocks of coal.",
        title =  "Surface Mineshaft",
        trigger = {
            type   = "dig",
            node   = "default:coalblock",
            target = 5,
        },
        icon = "default_coal_block.png"
    })

    awards.register_award("lmgjam_appalachia_biomes:geode", {
        description = "Find a large geode underground",
        title =  "Find Geode",
        trigger = {
            type   = "dig",
            node   = "lmgjam_appalachia_biomes:geode",
            target = 1,
        },
        icon = "notloc_geode_award.png"
    })

    awards.register_award("lmgjam_appalachia_biomes:read_book", {
        description = "Read a written book",
        title =  "Read a written book",
        type = "custom",
        icon = "default_book_written.png"
    })

    -- create a hook around using a book
    local book_def = core.registered_craftitems["default:book_written"]
    local old_on_use = book_def.on_use
    book_def.on_use = function(itemstack, user)
        local player_name = user:get_player_name()
        awards.unlock(player_name, "lmgjam_appalachia_biomes:read_book")
        return old_on_use(itemstack, user)
    end

    if core.get_modpath("lmg_jam_suzanna") then
        awards.register_award("lmgjam_appalachia_biomes:su_banjo", {
            description = "Play a Banjo Block",
            title =  "Play a Banjo Block",
            type = "custom",
            icon = "lmg_jam_banjo.png"
        })
        -- hook around rightclicking the banjo block
        local banjo_def = core.registered_nodes["lmg_jam_suzanna:su_banjo"]
        local old_on_rightclick = banjo_def.on_rightclick
        banjo_def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            local player_name = clicker:get_player_name()
            awards.unlock(player_name, "lmgjam_appalachia_biomes:su_banjo")
            return old_on_rightclick(pos, node, clicker, itemstack, pointed_thing)
        end
    end

    if core.get_modpath("hidebehind") then
        awards.register_award("lmgjam_appalachia_biomes:hidebehind", {
            description = "Fight back against a HideBehind",
            title =  "Hit HideBehind",
            type = "custom",
            icon = "hide_behind_award.png"
        })

        local hide_behind_def = core.registered_entities["hidebehind:hidebehind"]
        local old_on_punch = hide_behind_def.on_punch
        hide_behind_def.on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
            local player_name = puncher:get_player_name()
            awards.unlock(player_name, "lmgjam_appalachia_biomes:hidebehind")
            return old_on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
        end
    end

    if core.get_modpath("fart_dirt") then
        awards.register_award("lmgjam_appalachia_biomes:fart_dirt", {
            description = "Was that a bullfrog I heard while digging dirt?",
            title =  "Find 5 fart blocks",
            trigger = {
                type   = "dig",
                node   = "fart_dirt:fart_dirt",
                target = 5,
            },
            icon = "default_dirt.png"
        })
    end

    -- create a hook around registered entities
    if core.get_modpath("lmgjam_notloc_alpac_alachia") then
        awards.register_award("lmgjam_appalachia_biomes:alpaca", {
            description = "Pet or feed an alpaca (with right click!)",
            title =  "Pet or feed an alpaca",
            type = "custom",
            icon = "pet_alpaca_award.png"
        })

        local entity_def = core.registered_entities["lmgjam_notloc_alpac_alachia:alpaca"]
        local old_on_rightclick = entity_def.on_rightclick
        entity_def.on_rightclick = function(self, clicker)
            local player_name = clicker:get_player_name()
            awards.unlock(player_name, "lmgjam_appalachia_biomes:alpaca")
        end
    end

end
