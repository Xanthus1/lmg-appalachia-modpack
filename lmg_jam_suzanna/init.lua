print("This file will be run at load time!")

-- First node: Mine Blast
core.register_node("lmg_jam_suzanna:node", {
    description = "Oh Suzanna on Banjo Node",
    tiles = {"lmg_jam_lmg.png"},
    groups = {cracky = 1}
})

core.register_craft({
    type = "shapeless",
    output = "lmg_jam_suzanna:node 6",
    recipe = { "default:dirt", "default:stone" },
})

-- Second node: Banjo Block with Multiple Interaction Methods
core.register_node("lmg_jam_suzanna:su_banjo", {
    description = "Banjo Node (Right-click or punch to play!)",
    tiles = { "lmg_jam_banjo.png" },
    groups = { choppy = 2, oddly_breakable_by_hand = 1 },
    
    -- Play when placed
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        core.chat_send_all("Banjo block placed! Right-click or punch to play music!")
        -- Initialize metadata for cooldown
        local meta = core.get_meta(pos)
        meta:set_int("last_played", 0)
        return true
    end,
    
    -- RIGHT-CLICK to play sound
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local meta = core.get_meta(pos)
        local last_played = meta:get_int("last_played")
        local current_time = core.get_gametime()
        
        -- 3 second cooldown to prevent spam
        if current_time - last_played > 3 then
            core.chat_send_all(clicker:get_player_name() .. " activated the banjo!")
            local handle = core.sound_play("img_jam_suzanna", {
                pos,
                1.0,
                16,
            })
            meta:set_int("last_played", current_time)

            meta:set_int("sound_handle", handle)
            
            if not handle then
                core.chat_send_all("Sound failed to play!")
            end
        else
            core.chat_send_all("Banjo is still resonating... wait a moment!")
        end
        return itemstack
    end,
    
    -- PUNCH to play a shorter sound or stop
    on_punch = function(pos, node, puncher, pointed_thing)
        --core.chat_send_all(puncher:get_player_name() .. " punched the banjo!")
        -- Could play a different, shorter sound here
        core.sound_play("default_wood_footstep", {
            pos = pos,
            gain = 1.0,
            max_hear_distance = 8,
        })
    end,
    
    -- Cleanup when removed
    on_dig = function(pos, node, digger)
        --core.chat_send_all("Banjo block removed")
        
        local meta = core.get_meta(pos)
        local handle = meta:get_int("sound_handle")
        
        
        core.chat_send_all(tostring(handle))
        if handle and handle > 0 then
            core.sound_stop(handle)
            --core.chat_send_all("🛑 Banjo music stopped.")
        end
        core.node_dig(pos, node, digger)
    end,
})

-- Craft recipe for Banjo Block (using group:wood to accept any wood type)
core.register_craft({
    type = "shaped",
    output = "lmg_jam_suzanna:su_banjo 1",
    recipe = {
        {"", "group:wood",""},
        {"group:wood", "farming:cotton",  "group:wood"},
        {"group:wood", "farming:cotton",  "group:wood"}
    }
})


-- Debug command to test sound directly (type /test_banjo_sound in chat)
core.register_chatcommand("test_banjo_sound", {
    description = "Test the banjo sound directly",
    func = function(name, param)
        local player = core.get_player_by_name(name)
        if player then
            core.chat_send_all("Testing banjo sound for player: " .. name)
            local handle = core.sound_play("lmg_jam_suzanna_oh_suzanna", {
                to_player = name,
                gain = 1.0,
            })
            if handle then
                return true, "Sound test initiated! You should hear it now."
            else
                return false, "Sound failed to play. Check sounds folder and filename!"
            end
        end
    end,
})

-- Test with different sound playing methods
core.register_chatcommand("test_sound_methods", {
    description = "Test different ways to play sound",
    func = function(name, param)
        local player = core.get_player_by_name(name)
        if not player then
            return false, "Player not found!"
        end
        
        core.chat_send_all("=== Testing 4 different sound methods ===")
        
        -- Method 1: Global sound (everyone hears it)
        core.chat_send_all("Method 1: Global sound...")
        core.sound_play("default_dig_choppy", {
            gain = 2.0,
        })
        
        -- Wait a moment
        core.after(2, function()
            -- Method 2: Positional sound at player
            core.chat_send_all("Method 2: Positional at your location...")
            local pos = player:get_pos()
            core.sound_play("default_dig_choppy", {
                pos = pos,
                gain = 2.0,
                max_hear_distance = 100,
            })
        end)
        
        -- Method 3: Object sound (attached to player)
        core.after(4, function()
            core.chat_send_all("Method 3: Attached to player object...")
            core.sound_play("default_dig_choppy", {
                object = player,
                gain = 2.0,
            })
        end)
        
        -- Method 4: Simple call with just gain
        core.after(6, function()
            core.chat_send_all("Method 4: Simplest possible call...")
            core.sound_play("default_dig_choppy")
        end)
        
        return true, "Testing 4 methods over 6 seconds. Watch chat and listen!"
    end,
})

-- Test YOUR banjo sound with simple method
core.register_chatcommand("test_banjo_simple", {
    description = "Test banjo with simplest sound call",
    func = function(name, param)
        core.chat_send_all("Playing banjo sound with NO parameters...")
        local handle = core.sound_play("lmg_jam_suzanna_oh_suzanna")
        if handle then
            return true, "Banjo sound called with handle: " .. tostring(handle)
        else
            return false, "Banjo sound returned nil"
        end
    end,

     -- Stop the sound when the node is removed
    on_destruct = function(pos)
        local meta = core.get_meta(pos)
        local handle = meta:get_int("sound_handle")

        if handle and handle > 0 then
            core.sound_stop(handle)
            core.chat_send_all("🛑 Banjo music stopped.")
        end
    end,
})