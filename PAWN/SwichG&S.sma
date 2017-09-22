#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <colorchat>

#define PLUGIN "SwitchG&S"
#define VERSION "1.0"
#define AUTHOR "KPOCT"
#define SVC_DIRECTOR_ID 51 
#define SVC_DIRECTOR_STUFFTEXT_ID 10
#define STANDARD_GRAVITY_IN_DECIMAL 1.0
#define STANDARD_GRAVITY 800.0
#define STANDARD_SPEED 250.0

new bool:g_freezetime;
new Float:OldGrav[33], Float:OldSpeed[33];

public plugin_init()
{
	register_plugin("PLUGIN","VERSION","AUTHOR");
	register_clcmd("switchgravity","SwitchingGravity");
	register_clcmd("switchspeed","SwitchingSpeed");
	register_event("HLTV", "New_Round", "a", "1=0", "2=0");
	register_logevent("Start_Round", 2, "1=Round_Start");
	RegisterHam(Ham_Spawn, "player", "ReInitOld");
	new const szWeaponName[][] = 
	{
		"weapon_p228","weapon_scout","weapon_hegrenade","weapon_xm1014","weapon_c4","weapon_mac10",
		"weapon_aug","weapon_smokegrenade","weapon_elite","weapon_fiveseven","weapon_ump45","weapon_sg550",
		"weapon_galil","weapon_famas","weapon_usp","weapon_glock18","weapon_awp","weapon_mp5navy","weapon_m249",
	 "weapon_m3","weapon_m4a1","weapon_tmp","weapon_g3sg1","weapon_flashbang","weapon_deagle","weapon_sg552",
		"weapon_knife","weapon_p90", "weapon_ak47"
	};
	for(new i = 0; i < sizeof szWeaponName; i++)
	{
  RegisterHam(Ham_Item_Deploy, szWeaponName[i], "GetSpeed", true);
  RegisterHam(Ham_Item_Deploy, szWeaponName[i], "SetSpeed", false);
	}
}

public SwitchingGravity(id)
{
	if(pev(id, pev_gravity) != STANDARD_GRAVITY_IN_DECIMAL)
	{
		pev(id, pev_gravity, OldGrav[id]);
		set_pev(id, pev_gravity, STANDARD_GRAVITY_IN_DECIMAL);
		client_print_color(id, Red, "^4Ваша гравитация:^1 %.1f ^4ups.", (STANDARD_GRAVITY_IN_DECIMAL * STANDARD_GRAVITY));
	}
	else
	{
		set_pev(id, pev_gravity, OldGrav[id]);
		client_print_color(id, Red, "^4Ваша гравитация:^1 %.1f ^4ups.", (OldGrav[id] * STANDARD_GRAVITY));
	}
	return PLUGIN_HANDLED;
}

public SwitchingSpeed(id)
{
	if(g_freezetime)
	{
		client_print_color(id, Red, "^3Дождитесь старта раунда!");
	}
	else
	{
		if(pev(id, pev_maxspeed) != STANDARD_SPEED)
		{
			GetSpeed(id);
			SetSpeed(id);
			client_print_color(id, Red, "^4Ваша скорость:^1 %.1f ^4ups.", STANDARD_SPEED);
		}
		else
		{
			SetSpeed(id);
			client_print_color(id, Red, "^4Ваша скорость:^1 %.1f ^4ups.", OldSpeed[id]);
		}
	}
	return PLUGIN_HANDLED;
}

public GetSpeed(id)
{
	 pev(id, pev_maxspeed, OldSpeed[id]);
}

public SetSpeed(id)
{
 if(g_freezetime)
 {
  return;
 }
 else
 {
		set_pev(id, pev_maxspeed, OldSpeed[id]);
	}
}

public New_Round()
{
	g_freezetime = true;
}

public Start_Round()
{
	g_freezetime = false;
}

public ReInitOld(id)
{
	OldGrav[id] = STANDARD_GRAVITY_IN_DECIMAL;
	OldSpeed[id] = STANDARD_SPEED;
}

public client_connect(id)
{
	ReInitOld(id);

	new pCmd[50];
	
	pCmd = "cl_forwardspeed 9999";
	SVC_DIRECTOR_STUFFTEXT_CMD(id, pCmd);
	
	pCmd = "cl_backspeed 9999";
	SVC_DIRECTOR_STUFFTEXT_CMD(id, pCmd);
	
	pCmd = "cl_sidespeed 9999";
	SVC_DIRECTOR_STUFFTEXT_CMD(id, pCmd);
}

stock SVC_DIRECTOR_STUFFTEXT_CMD(id=0, text[]) 
{ 
	if ( !id || is_user_connected(id)) 
	{ 
		message_begin( MSG_ONE, SVC_DIRECTOR_ID, _, id ) 
		write_byte( strlen(text) + 2 ) 
		write_byte( SVC_DIRECTOR_STUFFTEXT_ID ) 
		write_string( text ) 
		message_end() 
	}
} 