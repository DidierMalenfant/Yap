-- SPDX-FileCopyrightText: 2022-present Didier Malenfant <coding@malenfant.net>
--
-- SPDX-License-Identifier: MIT

import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/frameTimer"
import "CoreLibs/object"

import "../toyboxes/toyboxes.lua"

class('Main', { engine = nil }).extends()

function Main:init()
    Main.super.init(self)

    self.engine = aspen.Engine()
    self.engine:setBackgroundImage('assets/backgrounds/night-sky')

    local image_table_path = 'assets/sprites/player'
    if playdate.file.exists('assets.private/sprites/player.pdt') then
        -- If we found the private version of the player, we replace the placeholder one.
        image_table_path = 'assets.private/sprites/player'
    end
    
    -- We want player's update() to be called before the level's, so add it here first.
    self.engine:createPlayer(image_table_path, 'assets/sprites/player-states.json', aspen.PlayerPhysics())
    self.engine.player:moveTo(20, 50)
    self.engine.player:setJumpSound('assets/sounds/jump')
    -- This will be set based on the sprite animation frames eventually.
    self.engine.player:setCollideRect(64, 30, 20, 59)

    self.engine:loadLevel('assets/levels/level-one.tmj')    
end

local main = Main()

function playdate.update()
    -- Update the engine.
    main.engine:update()

    -- Update all the playdate SDK systems.
    playdate.graphics.sprite.update()
    playdate.timer.updateTimers()
    playdate.frameTimer.updateTimers()

    playdate.drawFPS(385,0)
end
