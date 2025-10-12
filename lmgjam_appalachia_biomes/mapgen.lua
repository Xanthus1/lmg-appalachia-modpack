-- For decorations, biomes, etc.
-- https://rubenwardy.com/core_modding_book/en/advmap/biomesdeco.html

-- If you want a node to be used for base map generation
-- (e.g. stone, water sources, etc.), you can register aliases
-- core.register_alias("mapgen_stone", "base:smoke_stone")

-- Biome list for core:

--[[ Examples:`
core.register_decoration({
    deco_type = "simple",
    place_on = {"base:dirt_with_grass"},
    sidelen = 16,
    fill_ratio = 0.1,
    biomes = {"grassy_plains"}, -- if none are specified, spawns in all biomes
    y_max = 200,
    y_min = 1,
    decoration = "plants:grass",
})

core.register_decoration({
    deco_type = "schematic",
    place_on = {"base:desert_sand"},
    sidelen = 16,
    fill_ratio = 0.0001,
    biomes = {"desert"}, -- if none are specified, spawns in all biomes
    y_max = 200,
    y_min = 1,
    schematic = core.get_modpath("plants") .. "/schematics/cactus.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})
]]

-- Decorations can be defined and will spawn in biomes
-- you can specify different deco_type, "simple" for a single node
-- decoration, or "schematic" for a multiple node structure.
-- core.register_decoration({
--     deco_type = "schematic",
--     place_on = {
--         "default:dirt",
--         "default:dirt_with_snow",
--         "default:dirt_with_grass",
--         "default:dry_dirt_with_dry_grass",
--         "default:snowblock",
--         "default:stone",
--         "default:sand"
--     },
--     sidelen = 16,
--     fill_ratio = 0.001,
--     -- biomes = {"desert"},  -- Any biome
--     y_max = 200,
--     y_min = 1,
--     place_offset_y = 1, -- above ground
--     schematic = core.get_modpath("lmgjam_example") .. "/schematics/lmg_arch.mts",
--     flags = "place_center_x, place_center_z",
--     rotation = "random",
-- })


-- for testing
-- core.register_on_joinplayer(function(player_obj)
--     local player_name = player_obj:get_player_name()
--     core.chat_send_player(player_name, "--new decorations--")
--     for name, decoration_def in pairs(new_decorations) do
--         core.chat_send_player(player_name, name)
--     end
-- end)


local function register_mushroom(mushroom_name)
	core.register_decoration({
		name = "flowers:"..mushroom_name,
		deco_type = "simple",
		place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.006,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"appalachia_deciduous_forest", "appalachia_grassland" },
		y_max = 31000,
		y_min = 1,
		decoration = "flowers:"..mushroom_name,
	})
end

function register_appalachian_decorations()
    register_mushroom("mushroom_brown")
	register_mushroom("mushroom_red")

    core.register_decoration({
		name = "default:apple_log",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		place_offset_y = 1,
		sidelen = 16,
		noise_params = {
			offset = 0.0012,
			scale = 0.0007,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"appalachia_deciduous_forest", "appalachia_grassland"},
		y_max = 31000,
		y_min = 1,
		schematic = core.get_modpath("default") .. "/schematics/apple_log.mts",
		flags = "place_center_x",
		rotation = "random",
		spawn_by = "default:dirt_with_grass",
		num_spawn_by = 8,
	})

    core.register_decoration({
		name = "lmgjam_appalachia_biomes:apple_tree_tall",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.005,
			scale = 0.0005,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"appalachia_deciduous_forest", "appalachia_grassland"},
		y_max = 31000,
		y_min = 1,
		schematic = core.get_modpath("lmgjam_appalachia_biomes") .. "/schematics/apple_tree_tall.mts",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

    core.register_decoration({
		name = "lmgjam_appalachia_biomes:apple_tree_reduced_apple",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.024,
			scale = 0.015,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"appalachia_deciduous_forest", "appalachia_grassland"},
		y_max = 31000,
		y_min = 1,
		schematic = core.get_modpath("lmgjam_appalachia_biomes") .. "/schematics/apple_tree_reduced_apple.mts",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

	core.register_decoration({
		name = "lmgjam_appalachia_biomes:pawpaw_tree",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.0003,
			scale = 0.005,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"appalachia_deciduous_forest", "appalachia_grassland"},
		y_max = 31000,
		y_min = 1,
		place_offset_y = 1,
		schematic = core.get_modpath("lmgjam_appalachia_biomes") .. "/schematics/pawpaw_tree.mts",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

    core.register_decoration({
		name = "default:blueberry_bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass", "default:dirt_with_snow"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 697,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"appalachia_grassland"},
		y_max = 31000,
		y_min = 1,
		place_offset_y = 1,
		schematic = core.get_modpath("default") .. "/schematics/blueberry_bush.mts",
		flags = "place_center_x, place_center_z",
	})

	core.register_decoration({
		name = "lmgjam_appalachia_biomes:coal_cabin",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		place_offset_y = 1,
		sidelen = 16,
		noise_params = {
			offset = 0.0003,
			scale = 0.0003,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"appalachia_deciduous_forest", "appalachia_grassland"},
		y_max = 31000,
		y_min = 1,
		schematic = core.get_modpath("lmgjam_appalachia_biomes") .. "/schematics/coal_cabin.mts",
		flags = "place_center_x, force_placement",
		rotation = "random",
		spawn_by = "default:dirt_with_grass",
		num_spawn_by = 8,
	})

	core.register_decoration({
		name = "lmgjam_appalachia_biomes:coal_shaft",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass","default:stone","default:dirt"},
		place_offset_y = -7,
		sidelen = 16,
		noise_params = {
			offset = 0.00006,
			scale = 0.0007,
			spread = {x = 250, y = 250, z = 250},
			seed = 1337,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"appalachia_deciduous_forest", "appalachia_grassland"},
		y_max = 31000,
		y_min = -30000,
		schematic = core.get_modpath("lmgjam_appalachia_biomes") .. "/schematics/coal_shaft.mts",
		flags = "place_center_x, force_placement, all_floors",
		rotation = "random",
	})

	-- underground chests
	core.register_decoration({
		decoration = "lmgjam_appalachia_biomes:chest_coal_building",
		deco_type = "simple",
		place_on = {"default:stone"},
		place_offset_y = 0,
		sidelen = 16,
		noise_params = {
			offset = 0.01,
			scale = 0.0007,
			spread = {x = 250, y = 250, z = 250},
			seed = 1337,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"appalachia_under"},
		y_max = 0,
		y_min = -30000,
		flags = "all_floors",
		rotation = "random",
	})

	-- underground goedes
	core.register_decoration({
		decoration = "lmgjam_appalachia_biomes:geode",
		deco_type = "simple",
		place_on = {"default:stone"},
		place_offset_y = 0,
		sidelen = 16,
		noise_params = {
			offset = 0.01,
			scale = 0.0007,
			spread = {x = 250, y = 250, z = 250},
			seed = 13371337,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"appalachia_under"},
		y_max = 0,
		y_min = -30000,
		flags = "all_floors",
		rotation = "random",
	})
end


function register_appalachian_biome()
    core.register_biome({
        name = "appalachia_deciduous_forest",
        node_top = "default:dirt_with_grass",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 3,
        node_riverbed = "default:sand",
        depth_riverbed = 2,
        node_dungeon = "default:cobble",
        node_dungeon_alt = "default:mossycobble",
        node_dungeon_stair = "stairs:stair_cobble",
        y_max = 31000,
        y_min = 1,
        heat_point = 60,
        humidity_point = 68,
    })

    -- from grassland
    core.register_biome({
		name = "appalachia_grassland",
		node_top = "default:dirt_with_grass",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 1,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 31000,
		y_min = 6,
		heat_point = 50,
		humidity_point = 35,
        weight = 0.5
	})

	core.register_biome({
		name = "appalachia_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 0,
		y_min = -31000,
		heat_point = 60,
		humidity_point = 68,
	})
end

register_appalachian_biome()
register_appalachian_decorations()

-- registering Chests that can be placed by
-- schematics to have a written book
-- as well as fixing the furnaces to be usable
-- (metadata isn't initialized when placed by schematic)

-- don't run if schematic editor is active (so you can place coal_chest and save schematic)
if core.get_modpath('schemedit') == nil then
	local furnace_def = core.registered_nodes["default:furnace"]
	core.register_abm({
		nodenames = {"lmgjam_appalachia_biomes:chest_coal_building"},
		interval = 1,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			-- todo: get param2 from existing node, so it's rotated correctly
			local orig_meta = core.get_meta(pos)
			-- core.debug("Orig param2: "..  orig_meta:get_int("param2"))
			-- core.set_node(pos, {name="default:chest", param2 = core.dir_to_facedir({x=0,y=0,z=-1})})
			core.set_node(pos, {name="default:chest"})
			local meta = core.get_meta(pos)
			local inv = meta:get_inventory()

			local new_stack = ItemStack("default:book_written")

			-- random books (use position as a seed to determine the book)
			math.randomseed(pos.x*1000+pos.y*10+pos.z)
			local random_book_index = math.random(#appalachia_book_data)
			local fields_data = appalachia_book_data[random_book_index]
			local data = {
				-- description = "The Miner Story",
				fields = fields_data
			}
			new_stack:get_meta():from_table(data)

			local inv = meta:get_inventory()

			if (math.random(10)>5) then
				local new_stack = ItemStack("farming:seed_wheat")
				new_stack:set_count(math.random(10))
				inv:add_item("main", new_stack)

				local new_stack = ItemStack("farming:wheat")
				new_stack:set_count(math.random(5))
				inv:add_item("main", new_stack)
			end
			if (math.random(10)>5) then
				local new_stack = ItemStack("farming:cotton")
				new_stack:set_count(math.random(3)+1)
				inv:add_item("main", new_stack)

				local new_stack = ItemStack("farming:seed_cotton")
				new_stack:set_count(math.random(3)+1)
				inv:add_item("main", new_stack)
			end
			if (math.random(10)>7) then
				inv:add_item("main", "lmgjam_appalachia_biomes:pawpaw")
			end
			inv:add_item("main", new_stack)

			-- add coal if underground
			-- todo: different stories for coal mining underground?
			if pos.y < 0 then
				--core.debug("Underground Chest at "..pos.x..', '..pos.y..', '..pos.z)

				local new_stack = ItemStack("default:coal_lump")
				new_stack:set_count(math.random(20))
				inv:add_item("main", new_stack)

				if (math.random(10)>7) then
					inv:add_item("main", "default:pick_diamond")
				end
			else
				-- only get boomshine above ground
				if core.get_modpath("lmgjam_boomshine") then
					if (math.random(10)>7) then
						inv:add_item("main", "lmgjam_boomshine:raw_boomshine")
					end
				end
			end

			-- also updates nearby furnaces to have metadata
			-- (they don't when generated by schematics/decorations)
			local furnace_position = core.find_node_near(pos, 8, "default:furnace")
			if furnace_position ~= nil then
				furnace_def.on_construct(furnace_position)
			end
		end,
	})
end

-- Only keep appalachia biomes / decorations
-- keep_biomes = {
-- 	"appalachia_deciduous_forest",
-- 	"appalachia_grasslands",
-- 	"appalachia_under"
-- }
-- core.register_on_mods_loaded(function()
--     for name, biomedef in pairs(core.registered_biomes) do
--         local found = false
--         for _,value in ipairs(keep_biomes) do
--             if value == name then
--                 found = true
--             end
--         end
--         if found == false then
--             core.unregister_biome(name)
--         else
--             local new_biome_def = table.copy(biomedef)
--             core.unregister_biome(name)
--             core.register_biome(new_biome_def)
--         end
--     end
--     register_appalachian_biome()

--     -- clear all decorations and register appalachia decorations
--     core.clear_registered_decorations()
--     register_appalachian_decorations()
-- end)
