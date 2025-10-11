-- For decorations, biomes, etc.
-- https://rubenwardy.com/minetest_modding_book/en/advmap/biomesdeco.html

-- If you want a node to be used for base map generation
-- (e.g. stone, water sources, etc.), you can register aliases
-- core.register_alias("mapgen_stone", "base:smoke_stone")

-- Biome list for Minetest:

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

core.register_decoration({
    deco_type = "simple",
    place_on = {
        "default:dirt",
        "default:dirt_with_snow",
        "default:dirt_with_grass",
        "default:dry_dirt_with_dry_grass",
        "default:snowblock",
        "default:stone",
        "default:sand"
    },
    sidelen = 16,
    fill_ratio = 0.001,
    -- biomes = {"desert"},  -- Any biome
    y_max = 200,
    y_min = 1,
    place_offset_y = 1, -- above ground
    decoration = "lmgjam_appalachian_plants:pokeweed",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})