-- SPDX-FileCopyrightText: 2022-present Didier Malenfant <coding@malenfant.net>
--
-- SPDX-License-Identifier: MIT

import "CoreLibs/graphics"
import "CoreLibs/object"

import 'Level'
import 'Player'

dm = dm or {}
dm.aspen = dm.aspen or {}

class('Engine', { background_image = nil, level = nil, player = nil, camera_y_offset = 0 }, dm.aspen).extends()

local gfx <const> = playdate.graphics
local aspen <const> = dm.aspen
local Engine <const> = dm.aspen.Engine
local Plupdate <const> = dm.Plupdate
local FontSample <const> = dm.FontSample

local display_width <const>, display_height <const> = playdate.display.getSize()

function Engine:init()
    -- Call our parent init() method.
    Engine.super.init(self)

    FontSample.setFont()

    Plupdate.iWillBeUsingSprites()
end

function Engine:createPlayer(image_table_path, states_path, physics)
    self.player = aspen.Player(image_table_path, states_path, physics)
    assert(self.player, 'Error loading character.')

    self.player.level_height = self.level.height

    self.player:setPlayerMovedCallback(function(x, y)
        -- If we have a level loaded, when the player moves we update the level position
        if self.level == nil then
            return
        end

        self.level:updateCameraPosition(x - (display_width / 2), y + (display_height / 2) + self.camera_y_offset)
    end)
end

function Engine:loadLevel(level_path)
    self.level = aspen.Level(level_path)
    assert(self.level, 'Error loading level.')
end

function Engine:setBackgroundImage(image_path)
    self.background_image = gfx.image.new(image_path)
    assert(self.background_image, 'Error loading background image.')

    gfx.sprite.setBackgroundDrawingCallback(function(_x, _y, _width, _height)
        -- _x, _y, _width, _height is the updated area in sprite-local coordinates
        -- The clip rect is already set to this area, so we don't need to set it ourselves
        gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)
        self.background_image:draw(0, 0)
    end)
end

function Engine:setCameraYOffset(offset)
    self.camera_y_offset = offset
end
