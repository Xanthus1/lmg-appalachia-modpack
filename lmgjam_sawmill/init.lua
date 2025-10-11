lmgjam_sawmill_tickrate = 1
lmgjam_sawmill_water_wheel_power = 8
lmgjam_sawmill_saw_yield = 4

lmgjam_sawmill_current_second = core.get_gametime()
lmgjam_sawmill_cut_this_second = 0

if awards then
    awards.register_award("lmgjam_sawmill:sawmill_award", {
        title = "Bane of Lumber",
        description = "Create a sawmill that automatically produces 1,000 wood per minute.",
        icon = "sawmill_award.png",
    })
end

core.register_node("lmgjam_sawmill:stripped_log", {
    description = "Stripped Log",
    drawtype = "nodebox",
    tiles = {"default_tree_top.png","default_tree_top.png","default_tree.png","default_tree.png","default_tree.png","default_tree.png"},
	groups = {tree = 1, choppy = 1, oddly_breakable_by_hand = 1},
    node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
})

core.register_node("lmgjam_sawmill:water_wheel_inactive", {
    description = "Water Wheel",
    drawtype = "torchlike",
    visual_scale = 1.5,
    tiles = {"water_wheel1.png"},
    wield_image = "water_wheel1.png",
    inventory_image = "water_wheel1.png",
    groups = {choppy=1,oddly_breakable_by_hand=1},
    stack_max = 1,
    walkable = false,

    on_construct = function(pos) core.get_meta(pos):set_int("power",0) core.get_node_timer(pos):start(lmgjam_sawmill_tickrate) end,

    on_timer = function(pos, elapsed, node, timeout)

        for i=1,3 do
            for o=-1,1,2 do
                local vec={0,0,0}
                vec[i]=o
                local neighbor_pos=vector.add(pos,vector.new(unpack(vec)))
                if core.get_item_group(core.get_node(neighbor_pos).name,"water") > 0 then
                    core.set_node(pos,{name="lmgjam_sawmill:water_wheel_active"})
                end
            end
        end

        core.get_node_timer(pos):start(lmgjam_sawmill_tickrate)
    end,
})
core.register_node("lmgjam_sawmill:water_wheel_active", {
    description = "Water Wheel (Active)",
    drawtype = "torchlike",
    visual_scale = 1.5,
    tiles = {{
		name = "water_wheel_animation.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1
		}}
	},
    wield_image = "water_wheel1.png",
    inventory_image = "water_wheel1.png",
    groups = {choppy=1,oddly_breakable_by_hand=1,not_in_creative_inventory=1},
    stack_max = 1,
    walkable = false,
    drop = "lmgjam_sawmill:water_wheel_inactive",

    on_construct = function(pos) core.get_meta(pos):set_int("power",lmgjam_sawmill_water_wheel_power) core.get_node_timer(pos):start(lmgjam_sawmill_tickrate) end,

    on_timer = function(pos, elapsed, node, timeout) 

        local some_water = false

        for i=1,3 do
            for o=-1,1,2 do
                local vec={0,0,0}
                vec[i]=o
                local neighbor_pos=vector.add(pos,vector.new(unpack(vec)))
                
                if core.get_item_group(core.get_node(neighbor_pos).name,"water") > 0 then
                    some_water=true
                end
            end
        end

        if some_water == false then 
            core.set_node(pos,{name="lmgjam_sawmill:water_wheel_inactive"})
        end
        core.get_node_timer(pos):start(lmgjam_sawmill_tickrate) 
    end,
})


core.register_node("lmgjam_sawmill:conveyor_inactive", {
    description = "Conveyor",
    tiles = {"conveyor.png","conveyor_wall.png","conveyor_wall.png","conveyor_wall.png","conveyor_upsidedown.png","conveyor.png"},
    groups = {choppy=1,oddly_breakable_by_hand=1},
    stack_max = 99,
    paramtype2 = "4dir",

    on_construct = function(pos) core.get_meta(pos):set_int("power",0) core.get_node_timer(pos):start(lmgjam_sawmill_tickrate) end,

    on_timer = function(pos,elapsed,node,timeout)

        local power=0

        for i=1,3 do
            for o=-1,1,2 do
                local vec={0,0,0}
                vec[i]=o
                local neighbor_pos=vector.add(pos,vector.new(unpack(vec)))
                

                local neighbor_power = core.get_meta(neighbor_pos):get_int("power")
                if neighbor_power-1>power then
                    power=neighbor_power-1
                end
            end
        end

        local param2=core.get_node(pos).param2
        if power>0 then
            core.set_node(pos,{name="lmgjam_sawmill:conveyor_active",param2=param2})
        end
        core.get_meta(pos):set_int("power",power)

        core.get_node_timer(pos):start(lmgjam_sawmill_tickrate)
    end,
})
core.register_node("lmgjam_sawmill:conveyor_active", {
    description = "Conveyor (Active)",
    tiles = {
        {
		name = "conveyor_animation.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1.5
		}},
    "conveyor_wall.png",
    "conveyor_wall.png",
    "conveyor_wall.png",
        {
		name = "conveyor_animation_upsidedown.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1.5
		}},
        {
		name = "conveyor_animation.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1.5
		}},
        },
    groups = {choppy=1,oddly_breakable_by_hand=1,not_in_creative_inventory=1},
    stack_max = 99,
    paramtype2 = "4dir",
    drop = "lmgjam_sawmill:conveyor_inactive",
    
    on_construct = function(pos) core.get_meta(pos):set_int("power",0) core.get_node_timer(pos):start(lmgjam_sawmill_tickrate) end,

    on_timer = function(pos,elapsed,node,timeout)


        local power=0

        local function set_neighbors_0(self_pos)
            core.get_node_timer(self_pos):set(lmgjam_sawmill_tickrate,0)
            for i=1,3 do
                for o=-1,1,2 do
                    local vec={0,0,0}
                    vec[i]=o
                    local neighbor_pos=vector.add(self_pos,vector.new(unpack(vec)))
                    if core.get_node_timer(self_pos):get_elapsed() ~= core.get_node_timer(neighbor_pos):get_elapsed() then
                        set_neighbors_0(neighbor_pos)
                    end
                end
            end
        end

        set_neighbors_0(pos)

        for i=1,3 do
            for o=-1,1,2 do
                local vec={0,0,0}
                vec[i]=o
                local neighbor_power = core.get_meta(vector.add(pos,vector.new(unpack(vec)))):get_int("power")
                if neighbor_power-1>power then
                    power=neighbor_power-1
                end
            end
        end

        local param2=core.get_node(pos).param2
        if power==0 then
            core.set_node(pos,{name="lmgjam_sawmill:conveyor_inactive",param2=param2})
        end
        core.get_meta(pos):set_int("power",power)

        --move blocks
        --IMPROVEMENT: Iterate over each and activate them from front to back?
        local back = core.facedir_to_dir(param2)
        local front = vector.multiply(back,-1)
        local up,down = vector.new(0,1,0),vector.new(0,-1,0)

        local moves={vector.add(pos,vector.add(front,down)),vector.add(pos,front),vector.add(pos,vector.add(front,up)),vector.add(pos,up),vector.add(pos,vector.add(back,up)),vector.add(pos,back),vector.add(pos,vector.add(back,down))}
        for i=1,#moves-1 do
            if core.get_node(moves[i]).name=="air" and core.get_node_group(core.get_node(moves[i+1]).name,"tree") > 0 and core.get_meta(moves[i+1]):get_int("time_moved") ~= core.get_gametime() then
                core.swap_node(moves[i],core.get_node(moves[i+1]))
                core.get_meta(moves[i]):set_int("time_moved",core.get_gametime())

                core.remove_node(moves[i+1])
            end
        end

        core.get_node_timer(pos):start(lmgjam_sawmill_tickrate)
    end,
})

core.register_node("lmgjam_sawmill:head_saw_inactive", {
    description = "Head Saw",
    drawtype = "torchlike",
    visual_scale = 1.5,
    tiles = {"saw.png"},
    wield_image = "saw.png",
    inventory_image = "saw.png",
    groups = {choppy=1,oddly_breakable_by_hand=1},
    stack_max = 1,
    walkable = false,
    move_resistance = 4,
    damage_per_second = 1,


    on_construct = function(pos) core.get_meta(pos):set_int("power",0) core.get_node_timer(pos):start(lmgjam_sawmill_tickrate) end,

    on_timer = function(pos, elapsed, node, timeout)

        local power=0

        for i=1,3 do
            for o=-1,1,2 do
                local vec={0,0,0}
                vec[i]=o
                local neighbor_power = core.get_meta(vector.add(pos,vector.new(unpack(vec)))):get_int("power")
                if neighbor_power-1>power then
                    power=neighbor_power-1
                end
            end
        end

        if power > 0 then
            core.set_node(pos,{name = "lmgjam_sawmill:head_saw_active"})
        end
        core.get_meta(pos):set_int("power",power)

        core.get_node_timer(pos):start(lmgjam_sawmill_tickrate)
    end,
})

core.register_node("lmgjam_sawmill:head_saw_active", {
    description = "Head Saw",
    drawtype = "torchlike",
    visual_scale = 1.5,
    tiles = {{
		name = "saw_animation.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 0.33
		}}
	},
    wield_image = "saw.png",
    inventory_image = "saw.png",
    groups = {choppy=1,oddly_breakable_by_hand=1,not_in_creative_inventory=1},
    stack_max = 1,
    walkable = false,
    move_resistance = 4,
    damage_per_second = 4,


    on_construct = function(pos) core.get_meta(pos):set_int("power",0) core.get_node_timer(pos):start(lmgjam_sawmill_tickrate) end,

    on_timer = function(pos, elapsed, node, timeout)
        if awards then
            if core.get_gametime()~=lmgjam_sawmill_current_second then
                lmgjam_sawmill_current_second=core.get_gametime()

                if lmgjam_sawmill_cut_this_second>32 then
                    local players = core.get_connected_players()
                    for _,user in ipairs(players) do
                        awards.unlock(user:get_player_name(),"lmgjam_sawmill:sawmill_award")
                    end
                end
                lmgjam_sawmill_cut_this_second=0
            end
        end

        local power=0

        for i=1,3 do
            for o=-1,1,2 do
                local vec={0,0,0}
                vec[i]=o
                local neighbor_power = core.get_meta(vector.add(pos,vector.new(unpack(vec)))):get_int("power")
                if neighbor_power-1>power then
                    power=neighbor_power-1
                end
            end
        end

        if power == 0 then
            core.set_node(pos,{name = "lmgjam_sawmill:head_saw_inactive"})
        end
        core.get_meta(pos):set_int("power",power)

        --cutting tree
        local tree_pos=vector.add(pos,vector.new(0,1,0))
        if core.get_item_group(core.get_node(tree_pos).name,"tree") > 0 and core.get_meta(tree_pos):get_int("time_moved")~=core.get_gametime() then
            if core.get_node(tree_pos).name=="lmgjam_sawmill:stripped_log" then
                core.remove_node(tree_pos)
            else
                core.set_node(tree_pos,{name="lmgjam_sawmill:stripped_log"})
            end

            local near_chest=nil
            for i=1,3 do
                for o=-1,1,2 do
                    local vec={0,0,0}
                    vec[i]=o
                    if core.get_node(vector.add(pos,vector.new(unpack(vec)))).name=="default:chest" or core.get_node(vector.add(pos,vector.new(unpack(vec)))).name=="default:chest_open" then
                        near_chest = vector.add(pos,vector.new(unpack(vec)))
                    end
                end
            end

            
            lmgjam_sawmill_cut_this_second = lmgjam_sawmill_cut_this_second + 4

            if near_chest then
                local meta = core.get_meta(near_chest)
                local inv = meta:get_inventory()
                for i=1,lmgjam_sawmill_saw_yield do
                    inv:add_item("main", "default:wood")
                end
            end

        end

        core.get_node_timer(pos):start(lmgjam_sawmill_tickrate*2)
    end,
})


core.register_craft({
    output = "lmgjam_sawmill:water_wheel_inactive 1",
    recipe = {
{"group:wood","group:wood","group:wood"},
{"group:wood","group:tree","group:wood"},
{"group:wood","group:wood","group:wood"},
}
})

core.register_craft({
    output = "lmgjam_sawmill:conveyor_inactive 1",
    recipe = {
{"group:wood","default:ladder_steel","group:wood"},
{"group:wood","default:ladder_steel","group:wood"},
{"group:wood","default:ladder_steel","group:wood"},
}
})

core.register_craft({
    output = "lmgjam_sawmill:head_saw_inactive 1",
    recipe = {
{"default:steel_ingot","default:sword_steel","default:steel_ingot"},
{"default:sword_steel","",                   "default:sword_steel"},
{"default:steel_ingot","default:sword_steel","default:steel_ingot"},
}
})

core.register_craft({
    type = "shapeless",
    output = "default:wood 4",
    recipe = {"lmgjam_sawmill:stripped_log"},
})