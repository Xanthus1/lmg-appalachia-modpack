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

