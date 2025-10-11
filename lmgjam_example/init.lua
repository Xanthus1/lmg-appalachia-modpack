print("This file will be run at load time!")

-- nodes (blocks)
dofile(core.get_modpath("lmgjam_example") .. "/nodes.lua")

-- decorations (structures that generate), biomes, map generation
dofile(core.get_modpath("lmgjam_example") .. "/mapgen.lua")

-- crafting (recipes)
dofile(core.get_modpath("lmgjam_example") .. "/crafting.lua")
