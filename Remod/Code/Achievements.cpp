/*************************************************************************
Dead by Dawn Source File.
Copyright (C), Dead by Dawn, 2010.
-------------------------------------------------------------------------
$Id$
$DateTime$
Description: 

-------------------------------------------------------------------------
History:
- 25:03:2010   : Created by Filip 'i59' Lundgren

*************************************************************************/

#include "StdAfx.h"
#include "Achievements.h"
#include "HUD/HUD.h"

CAchievementSystem::CAchievementSystem()
{
}

CAchievementSystem::~CAchievementSystem()
{
}

void CAchievementSystem::Reset()
{

}

void CAchievementSystem::Achieve(string Achievement, bool state)
{
}

void CAchievementSystem::UpAchievement(string Achievement)
{
	if (Achievement == "Kills")
	{
		if(KillAmount==5)
		{	
			CryLogAlways("ACHIEVEMENT '5 KILLS' ACHIEVED!");
			g_pGame->GetHUD()->ShowWarningMessage(EHUD_ACHIEVEMENT, "Achievement '5 Kills' earned!");
			g_pGame->
		}
	}
}