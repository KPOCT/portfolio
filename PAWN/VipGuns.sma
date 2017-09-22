#include <amxmodx>
#include <amxmisc>
#include <fakemeta_util>
#include <cstrike>

#if AMXX_VERSION_NUM < 183
	#include <colorchat>
#endif

new const PLUGIN[] = "VIP Guns", VERSION[] = "1.0", AUTHOR[] = "KPOCT";
/* ========================= НАСТРОЙКИ ===================== */
	const ACCESS_FLAG = ADMIN_LEVEL_H; // Флаг доступа. Менять значение после знака "равно".
	const KEYS = MENU_KEY_1 | MENU_KEY_2 | MENU_KEY_3 | MENU_KEY_4 | MENU_KEY_5 | MENU_KEY_6 | MENU_KEY_7 | MENU_KEY_8 | MENU_KEY_9 | MENU_KEY_0; // Клавиши для меню.
	const TIMES_PER_ROUND = 3; // Сколько раз можно воспользоваться привилегиями за один раунд.
	const MAP_STRLEN = 32;
	const MENU_STRLEN = 512; // Длина всего меню.
	const MENU_ITEM_STRLEN = 64; // Длина пункта в меню.
	const WEAPON_NAME_STRLEN = 20; // Здесь
	const AMMO_NAME_STRLEN = 16; // и здесь не трогать. Стоит ровно то значение, сколько нужно. Поставите больше - будет выделена лишняя память, меньше - может возникнуть ошибка.
	#if !defined MAX_PLAYERS
		const MAX_PLAYERS = 32; // Максимальное количество игроков
	#endif
	const TASK_ID = 121; // Любое значение можно использовать. Желательно отличное от нуля.
	new const START_ROUND = 2; // Раунд, начиная с которого можно пользоваться привилегиями. new здесь нужно, чтобы компилятор не выдавал предупреждение о том, что рез-тат условия очевиден. Можно и убрать, ничего не случится.
	new const DISABLED_MAPS[][] = // Карты, на которых привилегии не будут работать
	{
		"awp_", // Можно указывать как префикс карт,
		"scoutzknivez", // так и полное название определённой карты.
		"35hp_", // Другого не дано: либо префикс, либо полное название.
		"he_", // К примеру, у Вас есть набор карт с разными префиксами, но с одинаковым названием.
		"aim_", // И Вам их нужно запретить.
		"scout_" // Нельзя их все запретить, указав их общую часть, если у них разное начало. Придётся указывать их все отдельно.
	}
	/* ======================== МЕНЮ ======================= */
		enum _:WEAPON_DATA // Перечисление
		{
			sWpnName[WEAPON_NAME_STRLEN], // Для названия оружия
			sItemName[MENU_ITEM_STRLEN] // Для названия пункта меню
		}
		new const NUMBER_COLOR[] = "\y"; // Цвет номеров пунктов. "\r" - красный, "\y" - желтый, "\w" - белый, "\d" - серый.
		new const MENU_NAME[] = "\yVIP-меню оружия \d(ещё %d %s)^n^n"; // Название меню. ^n - переход на новую строку, ^t - табуляция. %d, %s - спецификаторы, их не трогать.
		new const WEAPON_LIST[][WEAPON_DATA] = // Массив перечислений
		{
			{"weapon_galil", "\wВзять \yGalil"}, // А тут (и ниже, соответственно) уже заполняем наши перечисления.
			{"weapon_famas", "\wВзять \yFamas"}, // Как видно из комментариев к перечислению, первый элемент - название оружия, с которым работают функции
			{"weapon_ak47", "\wВзять \yAK-47"}, // (с полным списком этих названий можно ознакомиться тут https://wiki.alliedmods.net/CS_Weapons_Information),
			{"weapon_m4a1", "\wВзять \yM4A1"}, // а второй элемент - это название пункта меню, отвечающего за оружие, которое указано в первом элементе.
			{"weapon_m249", "\wВзять \yM249"},
			{"weapon_scout", "\wВзять \yScout"},
			{"weapon_awp", "\wВзять \yAWP"}
		};
		new const GIVE_DEAGLE[] = "\wБрать дигл";
		new const SAVE_CHOOSE[] = "\wСохранить выбор";
		new const ON[] = "\d[\yВКЛ\d]";
		new const OFF[] = "\d[ВЫКЛ]";
		new const EXIT[] = "\wВыход";
	/* ==================== КОНЕЦ: МЕНЮ ==================== */

	/* =================== ЧАТ-СООБЩЕНИЯ =================== */
		new const PREFIX[] = "^1[^4VIP^1]"; // Префикс для сообщений, выводящихся в чат. ^1 - стандартный цвет, ^3 - цвет команды, ^4 - зелёный цвет.
		new const AVAILABLE_SINCE_N_ROUND[] = "%s ^3Доступно %s ^4%d ^3раунда!"; // Будет выведено "<PREFIX> Доступно с/со <START_ROUND> раунда!".
		new const YOU_ALREADY_TOOK[] = "%s ^3Вы уже брали оружие ^4%d ^3%s."; // Будет выведено "<PREFIX> Вы уже брали оружие <TIMES_PER_ROUND> раз."
		new const YOUR_CHOOSE_SAVED[] = "^3Ваш выбор успешно сохранён.";
		new const YOU_DEAD[] = "^3Вы не можете сейчас получить оружие, ибо мертвы.";
		new const NO_ACCESS[] = "^3Недостаточно прав."; // (тут можно инфу по поводу доната влепить, если чё :) )
		new const MAP_IS_DISABLED[] = "^3На этой карте нельзя брать оружие.";
	/* =============== КОНЕЦ: ЧАТ-СООБЩЕНИЯ ================ */
/* ===================== КОНЕЦ: НАСТРОЙКИ ================== */

new g_iRoundNumber;
new g_iUsages[MAX_PLAYERS + 1];

new bool:g_bGiveDeagle[MAX_PLAYERS + 1];
new bool:g_bSaveChoose[MAX_PLAYERS + 1];

new iSavedWpnID[MAX_PLAYERS + 1];
new sSavedWpnName[MAX_PLAYERS + 1][WEAPON_NAME_STRLEN];

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	register_logevent("LogEventRestartGame", 2, "1=Game_Commencing", "1&Restart_Round_");
	register_logevent("event_new_round", 2, "1=Round_Start");
	register_clcmd("vip_guns", "mGuns");
	register_event("ResetHUD", "ResetHUD", "be");
	register_menucmd(register_menuid("GunsMenu"), KEYS, "mhGuns");
	register_clcmd("fullupdate", "clcmd_fullupdate");
	arrayset(g_bGiveDeagle, true, sizeof(g_bGiveDeagle)); // "Брать дигл [ВКЛ]" по умолчанию. Закомментируйте строку, если хотите установить по умолчанию значение "ВЫКЛ"
	if(is_map_disabled())
	{
		#pragma unused g_iRoundNumber
		#pragma unused g_iUsages
		#pragma unused g_bGiveDeagle
		#pragma unused g_bSaveChoose
		#pragma unused iSavedWpnID
		#pragma unused sSavedWpnName
		#pragma unused WEAPON_DATA
	}
}

public mGuns(id)
{
	if(!(get_user_flags(id) & ACCESS_FLAG))
	{
		client_print_color(id, print_team_red, "%s %s", PREFIX, NO_ACCESS);
		return PLUGIN_HANDLED;
	}
	if(is_map_disabled())
	{
		client_print_color(id, print_team_red, "%s %s", PREFIX, MAP_IS_DISABLED);
		return PLUGIN_HANDLED;
	}
	new sMenu[MENU_STRLEN], iLen;
	new sTimes[10];
	declension(TIMES_PER_ROUND - g_iUsages[id], sTimes, charsmax(sTimes));
	iLen = formatex(sMenu, charsmax(sMenu), MENU_NAME, TIMES_PER_ROUND - g_iUsages[id], sTimes);
	#pragma unused sTimes
	new iItemNumber;
	for (new i; i < sizeof(WEAPON_LIST); ++i)
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "%s%d. %s^n", NUMBER_COLOR, ++iItemNumber, WEAPON_LIST[i][sItemName]);
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n%s%d. %s %s", NUMBER_COLOR, ++iItemNumber, GIVE_DEAGLE, g_bGiveDeagle[id] ? ON : OFF);
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n%s%d. %s %s", NUMBER_COLOR, ++iItemNumber, SAVE_CHOOSE, g_bSaveChoose[id] ? ON : OFF);
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n%s0. %s", NUMBER_COLOR, EXIT);
	show_menu(id, KEYS, sMenu, -1, "GunsMenu");
	return PLUGIN_HANDLED;
}

public mhGuns(const id, const iItem)
{
	switch(iItem)
	{
		case 7:
		{
			g_bGiveDeagle[id] = !g_bGiveDeagle[id];
			mGuns(id);
		}
		case 8:
		{
			g_bSaveChoose[id] = !g_bSaveChoose[id];
			iSavedWpnID[id] = 0;
			mGuns(id);
		}
		case 9:
		{
			return PLUGIN_HANDLED;
		}
		default:
		{
			if(g_iRoundNumber < START_ROUND)
			{
				client_print_color(id, print_team_red, AVAILABLE_SINCE_N_ROUND, PREFIX, START_ROUND == 2 ? "со" : "с", START_ROUND);
				return PLUGIN_HANDLED;
			}
			if(is_user_alive(id))
			{
				if(g_iUsages[id] < TIMES_PER_ROUND)
				{
					new const iWeaponID = get_weaponid(WEAPON_LIST[iItem][sWpnName]);
					save_choose(id, iItem);
					drop_weapon(id);
					fm_give_item(id, WEAPON_LIST[iItem][sWpnName]);
					set_user_bpammo(id, iWeaponID, get_max_ammo(iWeaponID));
					drop_weapon(id, true);
					give_pistol(id);
					fm_give_item(id, "weapon_hegrenade");
					fm_give_item(id, "weapon_smokegrenade");
					fm_give_item(id, "weapon_flashbang");
					fm_give_item(id, "weapon_flashbang");
					g_iUsages[id] += 1;
				}
				else
				{
					save_choose(id, iItem);
					new sTimes[10];
					declension(g_iUsages[id], sTimes, charsmax(sTimes));
					client_print_color(id, print_team_red, YOU_ALREADY_TOOK, PREFIX, g_iUsages[id], sTimes);
					return PLUGIN_HANDLED;
				}
			}
			else
			{	
				save_choose(id, iItem);
				client_print_color(id, print_team_red, "%s %s", PREFIX, YOU_DEAD);
				return PLUGIN_HANDLED;
			}
		}
	}
	return PLUGIN_HANDLED;
}

public event_new_round()
{
	g_iRoundNumber++;
	arrayset(g_iUsages, 0, sizeof(g_iUsages));
}

public LogEventRestartGame()
{
	g_iRoundNumber = 0;
}

stock get_max_ammo(const iWeaponID)
{
	switch (iWeaponID) 
	{
		case CSW_SCOUT, CSW_AK47, CSW_M4A1, CSW_GALIL, CSW_FAMAS : return 90;
		case CSW_USP, CSW_FIVESEVEN: return 100;
		case CSW_GLOCK18, CSW_ELITE: return 120;
		case CSW_AWP	: return 30;
		case CSW_M249	: return 200;
		case CSW_DEAGLE	: return 35;
		case CSW_P228	: return 13;
	}
	return -1;
}

public ResetHUD(id)
{
    set_task(0.5, "spawn_player", id + TASK_ID);
}

public spawn_player(id)
{
	id -= TASK_ID;
	if(get_user_flags(id) & ACCESS_FLAG && !is_map_disabled() && g_iRoundNumber >= START_ROUND)
	{
		if(g_iUsages[id] < TIMES_PER_ROUND && iSavedWpnID[id])
		{
			drop_weapon(id);
			fm_give_item(id, sSavedWpnName[id]);
			set_user_bpammo(id, iSavedWpnID[id], get_max_ammo(iSavedWpnID[id]));
			fm_give_item(id, "weapon_hegrenade");
			fm_give_item(id, "weapon_smokegrenade");
			fm_give_item(id, "weapon_flashbang");
			fm_give_item(id, "weapon_flashbang");
			cs_set_user_armor(id, 100, CS_ARMOR_VESTHELM);
			g_iUsages[id] += 1;
		}
		else
		{
			mGuns(id);
		}
		drop_weapon(id, true);
		give_pistol(id);
		if(_:cs_get_user_team(id) == 2)
		{
			cs_set_user_defuse(id, 1);
		}
	}
}

public clcmd_fullupdate(id)
{
   return PLUGIN_HANDLED;
}

bool:is_map_disabled()
{
	new sCurrentMap[MAP_STRLEN], sTempMap[MAP_STRLEN];
	get_mapname(sCurrentMap, charsmax(sCurrentMap));
	for(new i; i < sizeof(DISABLED_MAPS); ++i)
	{
		formatex(sTempMap, strlen(DISABLED_MAPS[i]), sCurrentMap);
		if(equal(sTempMap, DISABLED_MAPS[i]))
		{
			return true;
		}
	}
	return false;
}

save_choose(const id, const iItem)
{
	if(g_bSaveChoose[id])
	{
		iSavedWpnID[id] = get_weaponid(WEAPON_LIST[iItem][sWpnName]);
		formatex(sSavedWpnName[id], WEAPON_NAME_STRLEN - 1, WEAPON_LIST[iItem][sWpnName]);
		client_print_color(id, print_team_blue, "%s %s", PREFIX, YOUR_CHOOSE_SAVED);
	}
}

declension(const iNum, sOutput[], const iLen_sOutput)
{
	if ((iNum > 1 && iNum < 5) || ((iNum > 20) && (iNum % 10) > 1 && (iNum % 10) < 5))
	{
		add(sOutput, iLen_sOutput, "раза");
	}
	else
	{
		add(sOutput, iLen_sOutput, "раз");
	}
}

give_pistol(id)
{
	if(g_bGiveDeagle[id])
		{
			fm_give_item(id, "weapon_deagle");
			set_user_bpammo(id, CSW_DEAGLE, get_max_ammo(CSW_DEAGLE));
		}
		else
		{
			new iWeapons[32], iWeaponID, iCount;
			get_user_weapons(id, iWeapons, iCount);
			for(new i = 0; i < iCount; i++)
			{
				iWeaponID = iWeapons[i];
				switch(iWeaponID)
				{
					case CSW_GLOCK18:
					{
						fm_give_item(id, "weapon_glock18");
						set_user_bpammo(id, CSW_GLOCK18, get_max_ammo(CSW_GLOCK18));
					}
					case CSW_USP:
					{
						fm_give_item(id, "weapon_usp");
						set_user_bpammo(id, CSW_USP, get_max_ammo(CSW_USP));
					}
					case CSW_FIVESEVEN:
					{
						fm_give_item(id, "weapon_fiveseven");
						set_user_bpammo(id, CSW_FIVESEVEN, get_max_ammo(CSW_FIVESEVEN));
					}
					case CSW_ELITE:
					{
						fm_give_item(id, "weapon_elite");
						set_user_bpammo(id, CSW_ELITE, get_max_ammo(CSW_ELITE));
					}
					case CSW_P228:
					{
						fm_give_item(id, "weapon_p228");
						set_user_bpammo(id, CSW_P228, get_max_ammo(CSW_P228));
					}
					case CSW_DEAGLE:
					{
						fm_give_item(id, "weapon_deagle");
						set_user_bpammo(id, CSW_DEAGLE, get_max_ammo(CSW_DEAGLE));
					}
					default:
					{
						if(_:cs_get_user_team(id) == 2)
						{
							fm_give_item(id, "weapon_usp");
							set_user_bpammo(id, CSW_USP, get_max_ammo(CSW_USP));
						}
						else if(_:cs_get_user_team(id) == 1)
						{
							fm_give_item(id, "weapon_glock18");
							set_user_bpammo(id, CSW_GLOCK18, get_max_ammo(CSW_GLOCK18));
						}
					}
				}
			}
		}
}

stock set_user_bpammo(const id, const iWeapon, const iAmount)
{
	const OFFSET_AWP_AMMO = 377;
	const OFFSET_SCOUT_AMMO = 378;
	const OFFSET_M249_AMMO = 379;
	const OFFSET_FAMAS_AMMO = 380;
	const OFFSET_USP_AMMO = 382;
	const OFFSET_DEAGLE_AMMO = 384;
	const OFFSET_GLOCK_AMMO = 386;
	new iOffset;
	switch(iWeapon)
	{
		case CSW_AWP : iOffset = OFFSET_AWP_AMMO;
		case CSW_SCOUT, CSW_AK47 : iOffset = OFFSET_SCOUT_AMMO;
		case CSW_M249 : iOffset = OFFSET_M249_AMMO;
		case CSW_FAMAS, CSW_M4A1, CSW_GALIL : iOffset = OFFSET_FAMAS_AMMO;
		case CSW_USP : iOffset = OFFSET_USP_AMMO;
		case CSW_DEAGLE : iOffset = OFFSET_DEAGLE_AMMO;
		case CSW_GLOCK18 : iOffset = OFFSET_GLOCK_AMMO;
		default : return;
	}
	set_pdata_int(id, iOffset, iAmount);
}

stock drop_weapon(const id, const bool:bPistol = false)
{
	const primary_weapons_bit_sum = (1<<3|1<<5|1<<7|1<<8|1<<12|1<<13|1<<14|1<<15|1<<18|1<<19|1<<20|1<<21|1<<22|1<<23|1<<24|1<<27|1<<28|1<<30|1<<35);
	const secondary_weapons_bit_sum = (1<<1|1<<10|1<<11|1<<16|1<<17|1<<26|1<<35);
	new iWeapons[32], iWeaponID, iCount;
	get_user_weapons(id, iWeapons, iCount);
	for(new i = 0; i < iCount; i++)
	{
		iWeaponID = iWeapons[i];
		if(1<<iWeaponID & (bPistol ? secondary_weapons_bit_sum : primary_weapons_bit_sum))
		{
			fm_strip_user_gun(id, iWeaponID);
		}
	}
}