-- 
-- Abstract: Part of a tutorial documenting how to put together an 'Angry Birds'/'Hot Cross Bunnies' elastic catapult in CoronaSDK.
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

-- main.lua (Part of a tutorial documenting how to put together an 'Angry Birds'/'Hot Cross Bunnies' elastic catapult in CoronaSDK.)

module(..., package.seeall)

-- Pass state reference
state = {};
-- Bullet starts off in-active
ready = false;
-- Pass audio references
shot = {};
band_stretch = {};

function newProjectile()

	-- Import easing plugin
	local easingx  = require("easing");
	
	-- Bullet properties
	local bun_bullet = {
		name = "bun",
		type = "bullet",
		density=0.15,
		friction=0.2,
		bounce=0.5,
		size = 20,
		rotation = 100
	}
	
	-- Init bullet
	local bullet = display.newImage("images/ammo/" .. bun_bullet.name .. ".png");
	-- Place bullet
	bullet.x = 170; bullet.y = _H + 20;
	-- Set up physical properties	
	physics.addBody(bullet, "kinematic", {density=bun_bullet.density, friction=bun_bullet.friction, bounce=bun_bullet.bounce, radius=bun_bullet.size});
	
	bullet.linearDamping = 0.3;
	bullet.angularDamping = 0.8;
	bullet.isBullet = true;
	bullet.isSensor = true;
	-- Transition the bullet into position each time it's spawned	
	transition.to(bullet, {time=600, y=_H - 140, transition = easingx.easeOutElastic});
	
	return bullet;
	
end
