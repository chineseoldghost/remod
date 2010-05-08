Sniper = {
	health = 100.0,
	normalSpeed = 1.3,
	maxSpeed = 3.0,
	characterModel = "objects/characters/human/us/nanosuit/nanosuit_us_multiplayer.cdf",
	handsModel = "objects/weapons/arms_global/arms_nanosuit_us.chr",
	mass = 90,
	sprintMultiplier = 1.8,
	jumpHeight = 0.5,
}

function Sniper:Activate()
	self.actor:SetHealth(Sniper.health);
end