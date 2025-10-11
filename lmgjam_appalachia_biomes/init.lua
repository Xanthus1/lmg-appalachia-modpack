print("This file will be run at load time!")

-- various written books
dofile(core.get_modpath("lmgjam_appalachia_biomes") .. "/book_data.lua")

-- nodes (blocks)
dofile(core.get_modpath("lmgjam_appalachia_biomes") .. "/nodes.lua")

-- decorations (structures that generate), biomes, map generation
dofile(core.get_modpath("lmgjam_appalachia_biomes") .. "/mapgen.lua")

-- crafting (recipes)
-- dofile(core.get_modpath("lmgjam_appalachia_biomes") .. "/crafting.lua")

dofile(core.get_modpath("lmgjam_appalachia_biomes") .. "/awards.lua")