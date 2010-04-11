#ifndef __TAGBULLET_H__
#define __TAGBULLET_H__

#if _MSC_VER > 1000
# pragma once
#endif

#include "Projectile.h"

class CTagBullet : public CProjectile
{
public:
	CTagBullet();
	virtual ~CTagBullet();

	// CProjectile
	virtual void HandleEvent(const SGameObjectEvent &);

	static IEntityClass*	EntityClass;
};

#endif // __TAGBULLET_H__