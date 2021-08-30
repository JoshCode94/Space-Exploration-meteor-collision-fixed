local data_util = require("data_util")
local sounds = require("__base__.prototypes.entity.sounds")

--[[
meteors
projectile falls from the sky
shadow moves sideways
projectile causes explosion and spawns a rock
]]--

-- Now includes precise calculations for the selection and collision boxes.
local meteors = {
  ["meteor-01"] = {209,138,  {{-2,   -1},   {2,   1.3}}},
  ["meteor-02"] = {165,129,  {{-1.7, -1},   {1.4, 1.3}}},
  ["meteor-03"] = {151,139,  {{-1.3, -1},   {1.3, 1.6}}},
  ["meteor-04"] = {216,110,  {{-2,   -1.1}, {1.6, 1.1}}},
  ["meteor-05"] = {154,147,  {{-1.9, -1},   {2.2, 1.4}}},
  ["meteor-06"] = {154,132,  {{-1.6, -1},   {1.7, 1.6}}},
  ["meteor-07"] = {193,120,  {{-2.1, -0.6}, {2.1, 1.4}}},
  ["meteor-08"] = {136,117,  {{-1.7, -0.6}, {1.3, 1.4}}},
  ["meteor-09"] = {157,115,  {{-1.8, -0.8}, {2.2, 1.3}}},
  ["meteor-10"] = {198,153,  {{-1.9, -1},   {2,   1.7}}},
  ["meteor-11"] = {190,115,  {{-2,   -1},   {2.2, 1.4}}},
  ["meteor-12"] = {229,126,  {{-2.4, -1},   {1.9, 1.4}}},
  ["meteor-13"] = {151,125,  {{-1.8, -1}, 	{2.3, 1.4}}},
  ["meteor-14"] = {137,117,  {{-1.6, -1}, 	{1.4, 1.3}}},
  ["meteor-15"] = {201,141,  {{-2.2, -1}, 	{2.5, 1.7}}},
  ["meteor-16"] = {209,154,  {{-2.3, -1.2}, {1.8, 1.8}}}
}

local tint = {r = 0.5, g = 0.5, b = 0.5}

for name, meteor in pairs(meteors) do
  local width = meteor[1]
  local height = meteor[2]
  local shadow_width = meteor[1]
  local shadow_height = meteor[2]
  local scale = 0.75
  local picture_offset = width / 32 / 16
  local meteorBox = meteor[3]
  data:extend({
    {
      type = "projectile",
      name = data_util.mod_prefix.."falling-" .. name,
      acceleration = 0,
      rotatable = false,
      animation = {
        filename = "__space-exploration-graphics__/graphics/entity/meteor/hr-"..name..".png",
        frame_count = 1,
        width = width,
        height = height,
        line_length = 1,
        priority = "high",
        shift = { picture_offset, 0 },
        tint=tint,
        scale = scale,
      },
      action = {
        action_delivery = {
          target_effects = {
            {
              action = {
                action_delivery = {
                  target_effects = {
                    {
                      damage = {
                        amount = 20,
                        type = "meteor"
                      },
                      type = "damage"
                    },
                  },
                  type = "instant"
                },
                radius = 10,
                type = "area"
              },
              type = "nested-result"
            },
            {
              action = {
                action_delivery = {
                  target_effects = {
                    {
                      damage = {
                        amount = 100,
                        type = "meteor"
                      },
                      type = "damage"
                    },
                  },
                  type = "instant"
                },
                radius = 4,
                type = "area"
              },
              type = "nested-result"
            },
            {
              action = {
                action_delivery = {
                  target_effects = {
                    {
                      damage = {
                        amount = 200,
                        type = "meteor"
                      },
                      type = "damage"
                    },
                  },
                  type = "instant"
                },
                radius = 2,
                type = "area"
              },
              type = "nested-result"
            },
            {
              action = {
                action_delivery = {
                  target_effects = {
                    {
                      damage = {
                        amount = 10000,
                        type = "meteor"
                      },
                      type = "damage"
                    },
                  },
                  type = "instant"
                },
                radius = 1,
                type = "area"
              },
              type = "nested-result"
            },
            {
              type = "create-entity",
              entity_name = data_util.mod_prefix.."meteor-explosion",
            },
            {
              type = "create-entity",
              check_buildability = false,
              entity_name = data_util.mod_prefix.."static-"..name,
            },
            {
              type = "create-entity",
              entity_name = data_util.mod_prefix .. "trigger-movable-debris",
              trigger_created_entity = true,
            },
          },
          type = "instant"
        },
        type = "direct"
      },
      flags = { "not-on-map" },
      light = { intensity = 1, size = 5, color={r=1,g=0.7,b=0.3}},
      smoke = {
        {
          deviation = {
            0.15,
            0.15
          },
          frequency = 1,
          --name = "smoke-fast",
          --name = "smoke-explosion-particle",
          name = "soft-fire-smoke", -- lasts longer
          position = {0,0},
          slow_down_factor = 1,
          starting_frame = 3,
          starting_frame_deviation = 5,
          starting_frame_speed = 0,
          starting_frame_speed_deviation = 5
        }
      },
    },
    {
      type = "projectile",
      name = data_util.mod_prefix.."shadow-" .. name,
      acceleration = 0,
      rotatable = false,
      animation = {
        draw_as_shadow = true,
        filename = "__space-exploration-graphics__/graphics/entity/meteor/shadows/hr-"..name..".png",
        frame_count = 1,
        width = shadow_width,
        height = shadow_height,
        line_length = 1,
        priority = "high",
        shift = { picture_offset, 0 },
        tint=tint,
        scale = scale,
      },
      flags = { "not-on-map" },
    },
    {
      type = "simple-entity",
      name = data_util.mod_prefix.."static-"..name,
      icon = "__space-exploration-graphics__/graphics/icons/astronomic/asteroid-belt.png",
      icon_size = 64,
      flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
      subgroup = "wrecks",
      order = "d[remnants]-d[ship-wreck]-c[small]-a",
      max_health = 1000,
      minable = {
        mining_time = 1,
        results={
          {name = "stone", amount_min = 9, amount_max = 31},
          {name = "iron-ore", amount_min = 0, amount_max = 30},
          {name = "copper-ore", amount_min = 0, amount_max = 30},
          {name = "uranium-ore", amount_min = 0, amount_max = 30, probability = 0.1},
        }
      },
      resistances =
      {
        { type = "fire", percent = 100 },
        { type = "poison", percent = 100 }
      },
      -- All the collision and selection boxes are now precisely calculated for each meteor variant.
      collision_box = meteorBox,
      -- Meteors are now solid and cannot be walked or driven straight through. Nor can entities be built underneath as if the meteor wasn't there.
      -- This comes with the complication that any entity ghosts which would ordinarily be created in the destroyed entity's place are also destroyed.
      -- I have added three function to 'meteor.lua' in the 'scripts' folder.
      -- The meteors are marked for deconstruction and then the destroyed ghosts are replaced! This is a hack, but it works.
      collision_mask = {
      					"transport-belt-layer",
      					"rail-layer",
      					"train-layer",
      					"player-layer",
      					"object-layer"
      					},
      selection_box = meteorBox,
      selection_priority = 2,
      count_as_rock_for_filtered_deconstruction = true,
      vehicle_impact_sound = sounds.car_stone_impact,
      picture =
      {
        layers = {
          {
            filename = "__space-exploration-graphics__/graphics/entity/meteor/hr-"..name..".png",
            width = width,
            height = height,
            shift = { picture_offset, 0 },
            tint=tint,
            scale = scale,
          },
          {
            draw_as_shadow = true,
            filename = "__space-exploration-graphics__/graphics/entity/meteor/shadows/hr-"..name..".png",
            width = shadow_width,
            height = shadow_height,
            shift = { picture_offset, 0 },
            tint=tint,
            scale = scale,
          }
        }
      },
      render_layer = "object",
      localised_name = {"entity-name.meteorite"}
    },

  })
end

data:extend({
  {
    animation = {
      direction_count = 1,
      frame_count = 1,
      filename = "__base__/graphics/entity/scorchmark/small-scorchmark.png",
      width = 128,
      height = 92,
      line_length = 4,
      shift = util.by_pixel(0, 2),
      variation_count = 4,
      hr_version =
      {
        direction_count = 1,
        frame_count = 1,
        filename = "__base__/graphics/entity/scorchmark/hr-small-scorchmark.png",
        width = 256,
        height = 182,
        line_length = 4,
        shift = util.by_pixel(0, 2),
        variation_count = 4,
        scale = 0.5,
      }
    },
    collision_box = {
      {
        -1.5,
        -1.5
      },
      {
        1.5,
        1.5
      }
    },
    collision_mask = {
      "doodad-layer",
      "not-colliding-with-itself"
    },
    final_render_layer = "ground-patch-higher2",
    flags = {
      "placeable-neutral",
      "not-on-map",
      "placeable-off-grid"
    },
    ground_patch =
    {
      sheet =
      {
        filename = "__base__/graphics/entity/scorchmark/small-scorchmark.png",
        width = 128,
        height = 92,
        line_length = 4,
        shift = util.by_pixel(0, 2),
        variation_count = 4,
        hr_version =
        {
          filename = "__base__/graphics/entity/scorchmark/hr-small-scorchmark.png",
          width = 256,
          height = 182,
          line_length = 4,
          shift = util.by_pixel(0, 2),
          variation_count = 4,
          scale = 0.5,
        }
      }
    },
    ground_patch_higher =
    {
      sheet =
      {
        filename = "__base__/graphics/entity/scorchmark/small-scorchmark-top.png",
        width = 34,
        height = 28,
        line_length = 4,
        variation_count = 4,
        shift = util.by_pixel(0, -2),
        hr_version =
        {
          filename = "__base__/graphics/entity/scorchmark/hr-small-scorchmark-top.png",
          width = 68,
          height = 54,
          line_length = 4,
          shift = util.by_pixel(0, -2),
          variation_count = 4,
          scale = 0.5,
        }
      }
    },
    icon = "__base__/graphics/icons/small-scorchmark.png",
    icon_size = 64,
    name = data_util.mod_prefix.."meteor-scorchmark",
    order = "d[remnants]-b[scorchmark]-a[small]",
    remove_on_entity_placement = false,
    remove_on_tile_placement = true,
    selectable_in_game = false,
    selection_box = {
      {
        -1,
        -1
      },
      {
        1,
        1
      }
    },
    subgroup = "remnants",
    time_before_removed = 36000,
    type = "corpse"
  },

})
