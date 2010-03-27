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

#ifndef __ACHIEVEMENTS_H__
#define __ACHIEVEMENTS_H__
#pragma once

class CAchievementSystem
{
public:
  CAchievementSystem();
  virtual ~CAchievementSystem();
  
  static void Reset();
  void Achieve(string Achievment, bool state);
  void UpAchievement(string Achievement);
  void GetAchievements();
private:
	// Achievements
	int KillAmount;
};

#endif // #ifndef __ACHIEVEMENTS_H__