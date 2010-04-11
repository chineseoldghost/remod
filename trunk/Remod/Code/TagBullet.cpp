#include "StdAfx.h"
#include "Game.h"
#include "TagBullet.h"
#include "GameRules.h"
#include <IEntitySystem.h>
#include "HUD/HUD.h"
#include "AmmoParams.h"

IEntityClass* CTagBullet::EntityClass = 0;

CTagBullet::CTagBullet(void)
{
}

CTagBullet::~CTagBullet(void)
{
}

void CTagBullet::HandleEvent(const SGameObjectEvent &event)
{
	FUNCTION_PROFILER(GetISystem(), PROFILE_GAME);

	CProjectile::HandleEvent(event);

	if (event.event == eGFE_OnCollision)
	{
		if (m_destroying)
			return;

		EventPhysCollision *pCollision = reinterpret_cast<EventPhysCollision *>(event.ptr);
		if (!pCollision)
			return;

		IEntity *pTarget = pCollision->iForeignData[1]==PHYS_FOREIGN_ID_ENTITY ? (IEntity*)pCollision->pForeignData[1]:0;
		if (pTarget)
		{
			EntityId targetId = pTarget->GetId();

			CHUD *pHUD = g_pGame->GetHUD();
			pHUD->AddToRadar(targetId);

			SimpleHitInfo info(m_ownerId, targetId, m_weaponId, 0); // 0=tag,1=tac
			info.remote=IsRemote();

			g_pGame->GetGameRules()->ClientSimpleHit(info);
		}

		Destroy();
	}
}