
--[[
core.register_craftitem("lmgjam_steamengine:boomshine", {
    description = "Boomshine",
    inventory_image = ""
    groups = {cracky = 1}
})
]]

if awards then
    core.chat_send_all("AWARDS IS TRUE")
    if awards.registered_awards["lmgjam_boomshine:boom_award"]==nil then
        awards.register_award("lmgjam_boomshine:boom_award", {
            title = "BOOM!",
            description = "Drink homemade Appalachian Boomshine.",
            icon = "boomshine_award.png",
        })
    end
end

core.register_craftitem("lmgjam_boomshine:raw_boomshine", {
    description = "Raw Boomshine",
    inventory_image = "raw_boomshine.png"
})

core.register_craft({
    type = "shapeless",
    output = "lmgjam_boomshine:raw_boomshine 1",
    recipe = { "bucket:bucket_water", "farming:flour" },
})

local function boomshine_boom(itemstack, user, pointed_thing)

    user:set_armor_groups({immortal=1}) --make player invunrable to explosions
    tnt.boom(user:get_pos(),{radius=4}) --explode
    user:set_armor_groups({immortal=nil}) --make player vunrable

    --don't leave fire
    local nearFirePos=core.find_node_near(user:get_pos(),4,{"fire:basic_flame"},true)
    while nearFirePos~=nil do
        core.remove_node(nearFirePos)
        nearFirePos=core.find_node_near(user:get_pos(),4,{"fire:basic_flame"},true)
    end

    --if awards then
        --awards.unlock(user:get_player_name(),"lmgjam_boomshine:boom_award")
    --end

    if awards then

        local players = core.get_connected_players()
        for _,user in ipairs(players) do
            awards.unlock(user:get_player_name(),"lmgjam_boomshine:boom_award")
        end
    end

    itemstack:take_item() --remove item
    return itemstack
end

core.register_craftitem("lmgjam_boomshine:boomshine", {
    description = "Boomshine",
    inventory_image = "boomshine.png",
    on_use = boomshine_boom,
})

core.register_craft({
    type = "cooking",
    output = "lmgjam_boomshine:boomshine 1",
    recipe = "lmgjam_boomshine:raw_boomshine",
    cooktime = 10,
})