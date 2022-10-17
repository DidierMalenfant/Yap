-- SPDX-FileCopyrightText: 2022-present Didier Malenfant <coding@malenfant.net>
--
-- SPDX-License-Identifier: MIT

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

    self.engine:loadLevel('assets/levels/level-one.tmj')

    self.engine:createPlayer(image_table_path, 'assets/sprites/player-states.json', aspen.PlayerPhysics())
    self.engine.player:setJumpSound('assets/sounds/jump')
    self.engine.player:setPos(70, 0)
    self.engine.player:setCenter(75, 90)

    -- This will be set based on the sprite animation frames eventually.
    self.engine.player:setCollideRect(64, 30, 20, 60)

    self.engine:setCameraYOffset(50)

    -- We can use this to put the game in slow-mo when debugging.
    --Plupdate.onlyUpdateOneFrameEvery(10)

    Plupdate.addPostCallback(function()
        playdate.drawFPS(385,0)
    end)
end

Main()
