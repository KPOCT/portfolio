#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <engine>
#include <surf>

new JETPACK_PMODEL[] 	= "models/Divine-Games/Polet_v_kosmos/Jetpack/p_longjump.mdl"

new cvar_cost
new cvar_thrust
new cvar_min_speed
new cvar_max_speed

new g_HasJetpack[33]
new g_JetpackEnt[33]

static const PLUGIN_NAME[] 	= "SyN Surf Jetpack"
static const PLUGIN_AUTHOR[] 	= "Cheap_Suit and KP0CT"
static const PLUGIN_VERSION[]	= "1.4"

public plugin_init()
{
	new mapName[33]
	get_mapname(mapName, 32)
	
	if(!equali(mapName, "surf_", 5))
	{
		new pluginName[33]
		format(pluginName, 32, "[Disabled] %s", PLUGIN_NAME)
		register_plugin(pluginName, PLUGIN_VERSION, PLUGIN_AUTHOR)
		pause("ade")
	}
	else
	{
		register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)
		register_cvar(PLUGIN_NAME, PLUGIN_VERSION, FCVAR_SPONLY|FCVAR_SERVER)
		
		register_clcmd("sjp_givesj" , 		"cmd_GiveSJ", 		ADMIN_BAN, "<userid> - Gives free surf jetpack")
		register_clcmd("sjp_stripsj" , 		"cmd_StripSJ", 		ADMIN_BAN, "<userid> - Strips users surf jetpack")
		
		register_clcmd("say /buyjetpack", 	"cmd_BuySurfJetpack", 0, "Buys surf jetpack")
		register_clcmd("say buy_jetpack", 	"cmd_BuySurfJetpack", 0, "Buys surf jetpack")
		register_concmd("buy_jetpack", 		"cmd_BuySurfJetpack", 0, "Buys surf jetpack")
		register_concmd("buyjetpack", 		"cmd_BuySurfJetpack", 0, "Buys surf jetpack")
		
		cvar_cost	= register_cvar("sjp_cost", "25")
		cvar_thrust 	= register_cvar("sjp_thrust", "10")
		cvar_min_speed 	= register_cvar("sjp_min_speed", "400")
		cvar_max_speed 	= register_cvar("sjp_max_speed", "1200")
		
		register_event("DeathMsg", 		"Event_DeathMsg", "a")
	}
}

public plugin_precache()
{
	precache_model(JETPACK_PMODEL)
}

public client_connect(id)
{
	g_HasJetpack[id] = 0
	_removeJetpackEnt(id)
}
	
public client_disconnect(id)
{
	g_HasJetpack[id] = 0
	_removeJetpackEnt(id)
}

public Event_DeathMsg()
{
	new id = read_data(2)

	g_HasJetpack[id] = 0
	_removeJetpackEnt(id)

	return PLUGIN_CONTINUE
}

public cmd_BuySurfJetpack(id)
{
	new iCost = get_pcvar_num(cvar_cost)
	
	if(!is_user_alive(id)) 
		ChatColor(id, "^1[^4ДжетПак^1] ^3Трупам летать не предстоит.")
	else if(g_HasJetpack[id])
		ChatColor(id, "^1[^4ДжетПак^1] ^3Ну и зачем Вам второй?..")
	else if(surf_get_user_points(id) < iCost)
		ChatColor(id, "^1[^4ДжетПак^1] ^3Поинтов маловато.. Нужно ещё ^4%d^3.", iCost - surf_get_user_points(id))
	else
	{
		_give_Jetpack(id)
		surf_del_user_points(id, iCost)
  	}
	return PLUGIN_HANDLED
}

public cmd_GiveSJ(id , level , cid) 
{
	if(!cmd_access(id , level , cid , 2))
		return PLUGIN_HANDLED
		
	new arg1[33]
	read_argv(1 , arg1 , 32)

	new target = cmd_target(id , arg1 , 0)
	if(!is_user_connected(target))
	{
		console_print(id, "[ДжетПак] ==========================")
		console_print(id, "[ДжетПак] Такого игрока нет. Даже гугл не нашел :(")
		console_print(id, "[ДжетПак] ==========================")
		return PLUGIN_HANDLED
	}

	new Name[33], Name2[33]
	get_user_name(id, Name, 32)
	get_user_name(target, Name2, 32)
	
	if(g_HasJetpack[target])
	{
		console_print(id, "[ДжетПак] =======================================")
		console_print(id, "[ДжетПак] У %s уже есть джетпак. Зачем ему ещё?", Name2)
		console_print(id, "[ДжетПак] =======================================")
		return PLUGIN_HANDLED
	}
	
	_give_Jetpack(target)
	
	console_print(id, "[ДжетПак] =======================================")
	console_print(id, "[ДжетПак] Вы дали игроку %s джетпак. Да воздастся тебе по делам твоим.", Name2)
	console_print(id, "[ДжетПак] =======================================")
	ChatColor(target, "^1[^4ДжетПак^1] ^3%s ^4дал Вам джетпак.", Name)
	
	return PLUGIN_HANDLED
}

public cmd_StripSJ(id , level , cid) 
{
	if(!cmd_access(id , level , cid , 2))
		return PLUGIN_HANDLED
		
	new arg1[33]
	read_argv(1 , arg1 , 32)

	new target = cmd_target(id , arg1 , 0)
	if(!is_user_connected(target))
	{
		console_print(id, "[ДжетПак] ==========================")
		console_print(id, "[ДжетПак] Такого игрока нет. Даже гугл не нашел :(")
		console_print(id, "[ДжетПак] ==========================")
		return PLUGIN_HANDLED
	}

	new Name[33], Name2[33]
	get_user_name(id, Name, 32)
	get_user_name(target, Name2, 32)
	
	if(!g_HasJetpack[target])
	{
		console_print(id, "[ДжетПак] =======================================")
		console_print(id, "[ДжетПак] У игрока %s и так джетпака нет. Ещё квартиру у него забери...", Name2)
		console_print(id, "[ДжетПак] =======================================")
		return PLUGIN_HANDLED
	}
	
	g_HasJetpack[id] = 0
	_removeJetpackEnt(id)

	
	console_print(id, "[ДжетПак] =======================================")
	console_print(id, "^1[^4ДжетПак^1] Вы забрали джетпак у игрока %s. Сердца у Вас нет...", Name2)
	console_print(id, "[ДжетПак] =======================================")
	ChatColor(target, "^1[^4ДжетПак^1] ^4%s ^3забрал у Вас джетпак. Сердца у него нет...", Name)
	
	return PLUGIN_HANDLED
}

public _give_Jetpack(id)
{
	g_HasJetpack[id] = 1
	ChatColor(id, "^1[^4ДжетПак^1] ^4Вы купили джетпак.")
	
	if(g_JetpackEnt[id] < 1)
	{
		g_JetpackEnt[id] = create_entity("info_target")
		if(is_valid_ent(g_JetpackEnt[id]))
		{
			entity_set_model(g_JetpackEnt[id], JETPACK_PMODEL)
			entity_set_int(g_JetpackEnt[id], EV_INT_movetype, MOVETYPE_FOLLOW)
			entity_set_edict(g_JetpackEnt[id], EV_ENT_aiment, id)
		}
	}
}

public _removeJetpackEnt(id)
{
	if(g_JetpackEnt[id] > 0)
		remove_entity(g_JetpackEnt[id])
	g_JetpackEnt[id] = 0
}

public client_PreThink(id)
{
	if(!is_user_alive(id) || !g_HasJetpack[id])
		return PLUGIN_CONTINUE
		
	if(get_user_speed(id) < get_pcvar_num(cvar_min_speed))
		return PLUGIN_CONTINUE	
		
	new Button = get_user_button(id)
	if(Button & IN_MOVELEFT || Button & IN_MOVERIGHT || Button & IN_BACK || Button & IN_FORWARD)
	{		
		_jetThrust(id)
	}
	return PLUGIN_CONTINUE
}

public _jetThrust(id)
{	
	new Float:fVelocity[3]
	entity_get_vector(id, EV_VEC_velocity, fVelocity)
	new Float:fAngle[3]
	entity_get_vector(id, EV_VEC_angles, fAngle)
	engfunc(EngFunc_MakeVectors, fAngle)
	fVelocity[0] += fVelocity[0]/floatsqroot(fVelocity[0]*fVelocity[0] + fVelocity[1]*fVelocity[1])*get_pcvar_num(cvar_thrust)
	fVelocity[1] += fVelocity[1]/floatsqroot(fVelocity[0]*fVelocity[0] + fVelocity[1]*fVelocity[1])*get_pcvar_num(cvar_thrust)
	if(get_user_speed(id) < get_pcvar_num(cvar_max_speed))
		entity_set_vector(id, EV_VEC_velocity, fVelocity)
	return PLUGIN_CONTINUE
}

stock get_user_speed(id)
{
	new Float:fVelocity[3]
	entity_get_vector(id, EV_VEC_velocity, fVelocity)
	
	new iVelocity[3]
	FVecIVec(fVelocity, iVelocity)
	
	new iVelocity0 = iVelocity[0] * iVelocity[0]
	new iVelocity1 = iVelocity[1] * iVelocity[1]
	
	return sqroot(iVelocity0 + iVelocity1)
}

stock ChatColor(const id, const input[], any:...)
{
   new count = 1, players[32]
   static msg[191]
   vformat(msg, 190, input, 3)
   replace_all(msg, 190, "!g", "^4") // Green Color
   replace_all(msg, 190, "!y", "^1") // Default Color
   replace_all(msg, 190, "!t", "^3") // Team Color
   replace_all(msg, 190, "!t2", "^0") // Team2 Color
   if (id) players[0] = id; else get_players(players, count, "ch")
   {
      for (new i = 0; i < count; i++)
      {
         if (is_user_connected(players[i]))
         {
            message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
            write_byte(players[i]);
            write_string(msg);
            message_end();
         }
      }
   }
}