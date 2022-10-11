-- SPDX-FileCopyrightText: 2022-present Didier Malenfant <coding@malenfant.net>
--
-- SPDX-License-Identifier: MIT

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/frameTimer"
import "CoreLibs/ui"
import "CoreLibs/object"

class('Plupdate', { }).extends()
class('CallbackInfo', { method = nil, arg1 = nil, arg2 = nil }, Plupdate).extends()

function Plupdate.CallbackInfo:init(callback, arg1, arg2)
	self.callback = callback
	self.arg1 = arg1
	self.arg2 = arg2
end

function Plupdate.CallbackInfo:call()
	self.callback(self.arg1, self.arg2)
end

local update_timers = false
local update_frame_timers = false
local update_sprites = false
local show_crank_indicator = false
local show_crank_indicator_init = false
local tick_counter = 0
local tick_counter_reset = 0

local update_callbacks = { }
local post_update_callbacks = { }
local check_is_in = false
local check_sprite = nil

function Plupdate.checkForOtherPlaydateUpdate()
	if check_is_in then
		return
	end

	-- This is hacky but the SDK does things like this too, so...
	-- We create a sprite with no graphics and use the draw method to make sure
	-- ou playdate.update() is the only one in town. If so, we delete the sprite.
	local check_sprite = playdate.graphics.sprite.new()
	check_sprite:setSize(playdate.display.getSize())
	check_sprite:setCenter(0, 0)
	check_sprite:moveTo(0, 0)
	check_sprite:setZIndex(32767)
	check_sprite:setIgnoresDrawOffset(true)
	check_sprite:setUpdatesEnabled(false)
	check_sprite.draw = function()
							assert(playdate.update == Plupdate.update, 'Plupdate found another playdate.update(). See https://github.com/DidierMalenfant/Plupdate#changes-in-your-code.')
							check_sprite:remove()
							check_sprite = nil
						end
	check_sprite:add()

	check_is_in = true
end

function Plupdate.iWillBeUsingTimers()
	Plupdate.checkForOtherPlaydateUpdate()
	update_timers = true
end

function Plupdate.iWillBeUsingFrameTimers()
	Plupdate.checkForOtherPlaydateUpdate()
	update_frame_timers = true
end

function Plupdate.iWillBeUsingSprites()
	Plupdate.checkForOtherPlaydateUpdate()
	update_sprites = true
end

function Plupdate.showCrankIndicator()
	Plupdate.checkForOtherPlaydateUpdate()
	
	if show_crank_indicator then
		return
	end

	if show_crank_indicator_init == false then
		playdate.ui.crankIndicator:start()
		update_timers = true
		show_crank_indicator_init = true
	end

	show_crank_indicator = true
end

function Plupdate.onlyUpdateOneFrameEvery(number_of_ticks)
	tick_counter = number_of_ticks
	tick_counter_reset = number_of_ticks
end

function Plupdate.updateEveryFrame()
	tick_counter = 0
	tick_counter_reset = 0
end

function Plupdate.addCallback(callback, arg1, arg2)
	Plupdate.checkForOtherPlaydateUpdate()
	
	-- Pre-update callbacks will be executed starting with the first one in
	table.insert(update_callbacks, Plupdate.CallbackInfo(callback, arg1, arg2))
end

function Plupdate.addPostCallback(callback, arg1, arg2)
	Plupdate.checkForOtherPlaydateUpdate()
	
	-- Post-update callbacks will be executed starting with the last one in
	table.insert(post_update_callbacks, 1, Plupdate.CallbackInfo(callback, arg1, arg2))
end

function Plupdate.update()
	if tick_counter > 0 then
		tick_counter -= 1
		return
	else
		tick_counter = tick_counter_reset
	end

	for _, callback in ipairs(update_callbacks) do
		callback:call()
	end

	-- Update all the playdate SDK sub-systems.
	if update_sprites then
		playdate.graphics.sprite.update()
	end
	
	if show_crank_indicator then
		playdate.ui.crankIndicator:update()
		show_crank_indicator = false
	else
		show_crank_indicator_init = false
	end
	
	if update_timers then
		playdate.timer.updateTimers()
	end
	
	if update_frame_timers then
		playdate.frameTimer.updateTimers()
	end
	
	for _, callback in ipairs(post_update_callbacks) do
		callback:call()
	end
end

playdate.update = Plupdate.update
