-- 
-- Abstract: Tutorial file documenting how to put together an 'Angry Birds'/'Hot Cross Bunnies' elastic catapult in CoronaSDK.
-- Visit: http://www.fixdit.com regarding support and more information on this tutorial.
-- Hot Cross Bunnies is now available in the iTunes App Store: http://itunes.apple.com/app/hot-cross-bunnies/id432734772?mt=8
--
-- Version: 1.0
-- 
-- Copyright (C) 2011 FIXDIT Ltd. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

-- main.lua (Tutorial file documenting how to put together an 'Angry Birds'/'Hot Cross Bunnies' elastic catapult in CoronaSDK.)

-- Global vars set up
_W = display.contentWidth;
_H = display.contentHeight;

display.setStatusBar( display.HiddenStatusBar )

m = {}
m.random = math.random;

local state = display.newGroup();

-- Imports
local movieclip = require("movieclip");
local physics = require("physics");
physics.start();
-- Import projectile classes
local projectile = require("projectile");

-- Variables setup
local projectiles_container = nil;
local force_multiplier = 10;
local velocity = m.random(50,100);

-- Visible groups setup
local background = display.newGroup();
local slingshot_container = display.newGroup();

-- Build the catapult
-- Front strut
local slingshot_strut_front = display.newImage("images/slingshot_strut_front.png",true);
slingshot_strut_front.x = 210;
slingshot_strut_front.y = _H - 25;
-- Back strut
local slingshot_strut_back = display.newImage("images/slingshot_strut_back.png",true);
slingshot_strut_back.x = 210;
slingshot_strut_back.y = _H - 25;

-- Animated bunny eyes
bunny_eyes = movieclip.newAnim{"images/bunny-eyes-1.png", "images/bunny-eyes-2.png", "images/bunny-eyes-3.png"};
bunny_eyes.x = 228;
bunny_eyes.y = _H + 10;

-- Move catapult up
slingshot_container.y = -25;

local state_value = nil;

-- Audio
local shot = audio.loadSound("sounds/band-release.aif");
local band_stretch = audio.loadSound("sounds/stretch-1.aif");

-- Transfer variables to the projectile classes
projectile.shot = shot;
projectile.band_stretch = band_stretch;

-- Background image
local bg_image = display.newImage("images/bg-default.png",true);
background:insert(bg_image);

--[[

projectile TOUCH FUNCTION

]]--
local function projectileTouchListener(e)
	-- The current projectile on screen
	local t = e.target;
	-- If the projectile is 'ready' to be used
	if(t.ready) then
		-- if the touch event has started...
		if(e.phase == "began") then
			-- Play the band stretch
			audio.play(band_stretch);
			-- Set the stage focus to the touched projectile
			display.getCurrentStage():setFocus( t );
			t.isFocus = true;
			t.bodyType = "kinematic";
			
			-- Stop current physics motion, if any
			t:setLinearVelocity(0,0);
			t.angularVelocity = 0;
			
			-- Init the elastic band.
			local myLine = nil;
			local myLineBack = nil;
			
			-- Bunny eyes animation
			bunny_eyes:stopAtFrame(2);
		
		-- If the target of the touch event is the focus...
		elseif(t.isFocus) then
			-- If the target of the touch event moves...
			if(e.phase == "moved") then
				
				-- If the band exists... refresh the drawing of the line on the stage.
				if(myLine) then
					myLine.parent:remove(myLine); -- erase previous line
					myLineBack.parent:remove(myLineBack); -- erase previous line
					myLine = nil;
					myLineBack = nil;
				end
							
				-- If the projectile is in the top left position
				if(t.x < 105 and t.y < _H - 165)then
					myLineBack = display.newLine(t.x - 30, t.y, 196, _H - 165);
					myLine = display.newLine(t.x - 30, t.y, 120, _H - 152);
				-- If the projectile is in the top right position
				elseif(t.x > 105 and t.y < _H - 165)then
					myLineBack = display.newLine(t.x + 10, t.y - 25, 196, _H - 165);
					myLine = display.newLine(t.x + 10, t.y - 25, 120, _H - 152);
				-- If the projectile is in the bottom left position
				elseif(t.x < 105 and t.y > _H - 165)then
					myLineBack = display.newLine(t.x - 25, t.y + 20, 196, _H - 165);
					myLine = display.newLine(t.x - 25, t.y + 20, 120, _H - 152);
				-- If the projectile is in the bottom right position
				elseif(t.x > 105 and t.y > _H - 165)then
					myLineBack = display.newLine(t.x - 15, t.y + 30, 196, _H - 165);
					myLine = display.newLine(t.x - 15, t.y + 30, 120, _H - 152);
				else
				-- Default position (just in case).
					myLineBack = display.newLine(t.x - 25, t.y, 196, _H - 165);
					myLine = display.newLine(t.x - 25, t.y, 120, _H - 152);
				end
				
				-- Set the elastic band's visual attributes
				myLineBack:setColor(214,184,130);
				myLineBack.width = 8;
				
				myLine:setColor(243,207,134);
				myLine.width = 10;
				
				-- Insert the components of the catapult into a group.
				slingshot_container:insert(slingshot_strut_back);
				slingshot_container:insert(myLineBack);
				slingshot_container:insert(t);
				slingshot_container:insert(myLine);
				slingshot_container:insert(slingshot_strut_front);
				slingshot_container:insert(bunny_eyes);
				
				-- Boundary for the projectile when grabbed			
				local bounds = e.target.stageBounds;
				bounds.xMax = 200;
				bounds.yMax = _H - 250;
				
				if(e.y > bounds.yMax) then
					t.y = e.y;
				else
				
				end
				
				if(e.x < bounds.xMax) then
					t.x = e.x;
				else
					-- Do nothing
				end
			
			-- If the projectile touch event ends (player lets go)...
			elseif(e.phase == "ended" or e.phase == "cancelled") then
			
				-- Open bunny eyes
				bunny_eyes:stopAtFrame(3);
				-- Remove projectile touch so player can't grab it back and re-use after firing.
				projectiles_container:removeEventListener("touch", projectileTouchListener);
				-- Reset the stage focus
				display.getCurrentStage():setFocus(nil);
				t.isFocus = false;
				
				-- Play the release sound
				audio.play(shot);
				
				-- Remove the elastic band
				if(myLine) then
					myLine.parent:remove(myLine); -- erase previous line
					myLineBack.parent:remove(myLineBack); -- erase previous line
					myLine = nil;
					myLineBack = nil;
				end
				
				-- Launch projectile
				t.bodyType = "dynamic";
				t:applyForce((160 - e.x)*force_multiplier, (_H - 160 - e.y)*force_multiplier, t.x, t.y);
				t:applyTorque( 100 )
				t.isFixedRotation = false;
								
				-- Wait a second before the catapult is reloaded (Avoids conflicts).
				t.timer = timer.performWithDelay(1000, function(e)
				state:dispatchEvent({name="change", state="fire"});
				
				if(e.count == 1) then
					timer.cancel(t.timer);
					t.timer = nil;
				end
				
				end, 1)
					
			end
		
		end
	
	end

end

--[[

SPAWN projectile FUNCTION

]]--
local function spawnProjectile()

	-- If there is a projectile available then...
	if(projectile.ready)then
	
		projectiles_container = projectile.newProjectile();
		-- Flag projectiles for removal
		projectiles_container.ready = true;
		projectiles_container.remove = true;
		
		-- Reset the indexing for the visual attributes of the catapult.
		slingshot_container:insert(slingshot_strut_back);
		slingshot_container:insert(projectiles_container);
		slingshot_container:insert(slingshot_strut_front);
		slingshot_container:insert(bunny_eyes);
		-- Reset bunny eyes animation
		bunny_eyes:stopAtFrame(1);
		
		-- Add an event listener to the projectile.
		projectiles_container:addEventListener("touch", projectileTouchListener);
		
	end

end
--[[

GAME STATE CHANGE FUNCTION

]]--
function state:change(e)

	if(e.state == "fire") then
	
		-- You fired...
		-- new projectile please
		spawnProjectile();
			
	end

end

-- Tell the projectile it's good to go!
projectile.ready = true;
-- Spawn the first projectile.
spawnProjectile();
-- Create listnener for state changes in the game
state:addEventListener("change", state);
