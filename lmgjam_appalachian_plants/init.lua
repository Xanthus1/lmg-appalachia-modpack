print("This file will be run at load time!")

-- Global lmgjam_appalachian_plants namespace
lmgjam_appalachian_plants = {}
lmgjam_appalachian_plants.path = minetest.get_modpath("lmgjam_appalachian_plants")

-- nodes (blocks)
dofile(core.get_modpath("lmgjam_appalachian_plants") .. "/nodes.lua")

-- decorations (structures that generate), biomes, map generation
dofile(core.get_modpath("lmgjam_appalachian_plants") .. "/mapgen.lua")

-- crafting (recipes)
dofile(core.get_modpath("lmgjam_appalachian_plants") .. "/crafting.lua")

-- Pokeweed

farming.register_plant("lmgjam_appalachian_plants:pokeweed", {
	description = "Pokeweed Seed",
	harvest_description = "Pokeberries",
	paramtype2 = "meshoptions",
	inventory_image = "lmgjam_appalachian_plants_pokeweed_seeds.png",
	steps = 5,
	minlight = 11,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland","appalachia_deciduous_forest"},
	groups = {food_wheat = 1, flammable = 4},
	place_param2 = 0,
})