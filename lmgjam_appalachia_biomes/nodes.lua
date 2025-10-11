-- Blocks
-- https://rubenwardy.com/minetest_modding_book/en/items/nodes_items_crafting.html

--[[ Example:
core.register_node("mymod:diamond", {
    description = "Alien Diamond",
    tiles = {"mymod_diamond.png"},
    is_ground_content = true,
    groups = {cracky=3, stone=1}
})

minetest.register_node("my_test_mod:glass_wz", {
	description = "Glass WZ", -- "S("Glass WZ")",  todo: for string translations?
	drawtype = "allfaces",
	tiles = {
        "default_glass.png",    -- y+ up
        "default_glass.png",  -- y- down
        "default_glass.png", -- x+ right
        "default_glass.png",  -- x- left
        "my_test_mod_glass_wz.png",  -- z+ back
        "my_test_mod_glass_wz.png", -- z- front
    },
	use_texture_alpha = "clip", -- only needed for stairs API
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	_tnt_loss = 2,
})

]]

minetest.register_node("lmgjam_appalachia_biomes:pawpaw_tree_stem", {
	description = "Pawpaw Tree Stem",
	drawtype = "plantlike",
	visual_scale = 1.41,
	tiles = {"default_bush_stem.png"},
	inventory_image = "default_bush_stem.png",
	wield_image = "default_bush_stem.png",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16},
	},
})

minetest.register_node("lmgjam_appalachia_biomes:pawpaw_sapling", {
	description = "Pawpaw Tree Sapling",
	drawtype = "plantlike",
	tiles = {"default_bush_sapling.png"},
	inventory_image = "default_bush_sapling.png",
	wield_image = "default_bush_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 2 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"lmgjam_appalachia_biomes:pawpaw_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			{x = -1, y = 0, z = -1},
			{x = 1, y = 1, z = 1},
			-- maximum interval of interior volume check
			2)

		return itemstack
	end,
})
default.register_sapling_growth(
    "lmgjam_appalachia_biomes:pawpaw_sapling", -- Name of the sapling
    {
        can_grow = default.can_grow, -- Function called to determine whether the sapling can grow, should return a boolean
        on_grow_failed = default.on_grow_failed, -- Function called when the growth fails
        grow = function(pos)
            chat_send_all("Pawpaw tried to grow!")
            local path = core.get_modpath("lmgjam_appalachia_biomes").."/schematics/pawpaw_tree.mts"
            core.place_schematic({x = pos.x - 1, y = pos.y, z = pos.z - 1},
		        path, "0", nil, false)
        end -- Function called when the growth has success. This should replace the sapling with a tree.
    }
)

minetest.register_node("lmgjam_appalachia_biomes:pawpaw", {
	description = "Pawpaw",
	drawtype = "plantlike",
	tiles = {"lmgjam_appalachia_biomes_pawpaw.png"},
	inventory_image = "lmgjam_appalachia_biomes_pawpaw.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1, food_apple = 1},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = function(pos, placer, itemstack)
		minetest.set_node(pos, {name = "lmgjam_appalachia_biomes:pawpaw", param2 = 1})
	end,

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		if oldnode.param2 == 0 then
			minetest.set_node(pos, {name = "lmgjam_appalachia_biomes:pawpaw_mark"})
			minetest.get_node_timer(pos):start(math.random(300, 1500))
		end
	end,
})


minetest.register_node("lmgjam_appalachia_biomes:pawpaw_leaves", {
	description = "Bush Leaves",
	drawtype = "allfaces_optional",
	tiles = {"default_leaves_simple.png"},
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"lmgjam_appalachia_biomes:pawpaw_sapling"}, rarity = 5},
			{items = {"lmgjam_appalachia_biomes:pawpaw_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves,
})

minetest.register_node("lmgjam_appalachia_biomes:pawpaw_mark", {
	description = "Pawpaw marker",
	inventory_image = "default_apple.png^default_invisible_node_overlay.png",
	wield_image = "default_apple.png^default_invisible_node_overlay.png",
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	groups = {not_in_creative_inventory = 1},
	on_timer = function(pos, elapsed)
		if not minetest.find_node_near(pos, 1, "lmgjam_appalachia_biomes:pawpaw_leaves") then
			minetest.remove_node(pos)
		elseif minetest.get_node_light(pos) < 11 then
			minetest.get_node_timer(pos):start(200)
		else
			minetest.set_node(pos, {name = "lmgjam_appalachia_biomes:pawpaw"})
		end
	end
})

minetest.register_node("lmgjam_appalachia_biomes:geode", {
	description = "Geode",
	drawtype = "mesh",
	visual_scale = .4,
	tiles = {"notloc_geode.png"},
	mesh = "notloc_geode.glb",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {cracky= 2, falling_node=1},
	sounds = default.node_sound_stone_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16},
	},
})

-- node that will be replaced with a chest and written book
-- minetest.register_node("lmgjam_appalachia_biomes:chest_coal_building", {
-- 	description = "Chest for Coal Building",
--     drawtype = "airlike",
--     paramtype = "light",
--     sunlight_propagates = true,

--     walkable     = false, -- Would make the player collide with the air node
--     pointable    = false, -- You can't select the node
--     diggable     = false, -- You can't dig the node
--     buildable_to = true,  -- Nodes can be replace this node.
--                           -- (you can place a node and remove the air node
--                           -- that used to be there)
--     drop = "",
--     -- groups = {not_in_creative_inventory=1}
-- })

default.chest.register_chest("lmgjam_appalachia_biomes:chest_coal_building",{
	description = "Chest for Coal Building",
	tiles = {
		"default_chest_top.png",
		"default_chest_top.png",
		"default_chest_side.png",
		"default_chest_side.png",
		"default_chest_front.png",
		"default_chest_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
