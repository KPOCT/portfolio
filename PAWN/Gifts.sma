/*=======================================ИНКЛЮДЫ================================*/
#include <amxmodx>
#include <amxmisc>
#include <fakemeta_util>
#include <hamsandwich>
#include <fun>
#include <cstrike>
#include <surf>
/*=====================================КОНЕЦ: ИНКЛЮДЫ=============================*/
/*========================================ДЕФАЙНЫ================================*/
#define PLUGIN "Gifts"
#define VERSION "1.0"
#define AUTHOR "Psycrow && KP0CT"
#define PREFIX "^1[^4Подарки^1]"
#define is_entity_player(%1)   (1<=%1<=get_maxplayers())
#define PRESENT_CLASSNAME   "next21_gift"
#define MODEL_PRESENT       "models/Divine-Games/Polet_v_kosmos/Gifts/gifts.mdl"
#define MODEL_SKINS       3
#define MODEL_SUBMODELS    5
#define SVC_DIRECTOR_ID 51
#define SVC_DIRECTOR_STUFFTEXT_ID 10

///Время появления подарка
#define TIMER 30.0

///Флаг доступа
#define FLAG_ACCESS "l"

///Броня
#define ADD_ARMOR_MIN 20 // Начальное число
#define ADD_ARMOR_MAX 100  // Финишное число

///HP
#define ADD_HEALTH_MIN 10  // Начальное число
#define ADD_HEALTH_MAX 60   // Финишное число

///Деньги 
#define MAX_MONEY       16000
#define ADD_MONEY_MIN 1000
#define ADD_MONEY_MAX 4000

///Поинты
#define ADD_POINTS_MIN 1
#define ADD_POINTS_MAX 25

///Скорость
#define ADD_SPEED_MIN 75.0
#define ADD_SPEED_MAX 150.0
#define MAX_SPEED 700.0

///Гравитация
#define DECREASE_GRAVITY_MIN (100.0/800.0)
#define DECREASE_GRAVITY_MAX (200.0/800.0)
#define MIN_GRAVITY (200.0/800.0) // Минимальное значение гравитации игрока

/// Гранаты
#define OFFSET_FLASH_AMMO 387
#define OFFSET_HE_AMMO 388
#define HE_AMMO 1               // Сколько взрывных гранат выдаст игроку
#define FLASH_AMMO 2        // Сколько слеповых гранат выдаст игроку
 /*===================================КОНЕЦ: ДЕФАЙНЫ==========================*/
/*=================================ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ========================*/
new
   Float:fUserSpeed[33],
   Float:fUnits = 10.0,
   g_infoTarget,
   g_menuId = -1, 
   bool: g_registration,
   g_totalGifts,                                   //Кол-во загруженных подарков на карте
   bool: g_have_speed[33],               //Имеет ли игрок добавленную скорость
   bool: g_have_gravity[33],            //Имеет ли игрок добавленную гравитацию
   bool:bHaveVip[33],
   bool:bHaveHook[33],
   bool: g_save_cpl,                    //Изменения в расположении подарков
 
   Array:g_gift_id,                   //Индексы подарков
   Array:g_gift_x,
   Array:g_gift_y,
   Array:g_gift_z;
/*==============================КОНЕЦ: ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ=====================*/
public plugin_precache()
{
   precache_model(MODEL_PRESENT)
}

public plugin_init()
{
   register_plugin(PLUGIN, VERSION, AUTHOR)
   register_clcmd("gifts", "gift_menu")
   g_infoTarget = engfunc(EngFunc_AllocString, "info_target")
}
 
public plugin_cfg()
{
   new map[32]
   get_mapname(map, charsmax(map))
   formatex(map, charsmax(map),"%s.ini",map)
    
   new cfgDir[64], iDir, iFile[128]
   get_configsdir(cfgDir, charsmax(cfgDir))
   formatex(cfgDir, charsmax(cfgDir), "%s/Gifts", cfgDir)
    
   iDir = open_dir(cfgDir, iFile, charsmax(iFile))
    
   if(iDir)
   {
      while(next_file(iDir, iFile, charsmax(iFile)))
      {
         if (iFile[0] == '.')
            continue
             
         if(equal(map, iFile))
         {
            format(iFile, 128, "%s/%s", cfgDir, iFile)
            get_gifts(iFile)
            break
         }
      }
   }
   else server_print("[%s] Gifts was not loaded", PLUGIN)   
}

public client_putinserver(id)
{
   set_task(5.0, "send_maxspeed", id); 
}

public drop_weapon(id)
{
   set_task(1.0, "CurWeapon", id); 
}

public send_maxspeed(id)
{
	new pCmd[50];
	
	pCmd = "cl_forwardspeed 9999";
	STUFFTEXT_CMD(id, pCmd);
	
	pCmd = "cl_backspeed 9999";
	STUFFTEXT_CMD(id, pCmd);
	
	pCmd = "cl_sidespeed 9999";
	STUFFTEXT_CMD(id, pCmd);
}

public fw_PlayerSpawn(id)
{      
   if(g_have_gravity[id])
   {
      if(is_user_alive(id) && is_user_connected(id))
      {
         set_user_gravity(id, 1.0)
      }
      g_have_gravity[id] = false
   }
   if(g_have_speed[id])
   {
      fUserSpeed[id] = 250.0;
      if(is_user_alive(id) && is_user_connected(id))
      {
         set_user_maxspeed(id, fUserSpeed[id]);
      }
      g_have_speed[id] = false
   }
}
 
public CurWeapon(id)
{
   if(g_have_speed[id])
      set_user_maxspeed(id, fUserSpeed[id])
}

public client_disconnect(id)
{
   bHaveHook[id] = false;
   bHaveVip[id] = false;
}
 
public fw_TouchGift(ent, id)
{   
   if(!is_entity_player(id))
      return

   if(!is_user_alive(id) || !pev_valid(ent))
      return

   static className[32]
   pev(ent, pev_classname, className, 31)
   if(!equal(className, PRESENT_CLASSNAME))
      return

   engfunc(EngFunc_SetModel, ent, MODEL_PRESENT)
   set_pev(ent, pev_skin, random_num(0, MODEL_SKINS - 1))
   set_pev(ent, pev_body, random_num(0, MODEL_SUBMODELS - 1))

   hide_gift(ent)
   give_gift(id)
}

public set_gift()
{
   if(!g_totalGifts) return
       
   new valid_gifts_count = 0
   new ent;
   while((ent = fm_find_ent_by_class(ent, PRESENT_CLASSNAME)))
   {      
      if(pev(ent, pev_solid) != SOLID_NOT)
         valid_gifts_count++
   }            
       
   if(valid_gifts_count == g_totalGifts) return
    
   new bool: check = false, id
   while(check == false)
   {
      id = random_num(0, g_totalGifts - 1)
      ent = ArrayGetCell(g_gift_id ,id)
      if(pev(ent, pev_solid) == SOLID_NOT && iNumGifts(2) < 5)
      {
         set_pev(ent, pev_solid, SOLID_TRIGGER)         
         unhide_gift(ent)
         check = true
         ChatColor(0, "%s ^3Подарок появился!", PREFIX);
         iNumGifts(1);
      }
      else break;
   }
}

public iNumGifts(iOperation)
{
   static iNumGifts = 0;
   if(iOperation == 1)
   {
      iNumGifts++;
   }
   else if(!iOperation)
   {
      iNumGifts--;
   }
   return iNumGifts;
}
 
public gift_menu(id)
{
   if(!is_user_access(id))
   {
      ChatColor(id, "%s ^3Недостаточно прав!", PREFIX)
      return
   }
    
   new menu_name[100];
   format(menu_name, 99, "\rРасстановка подарков^n\dТекущий подарок: %d^nСтр. ", g_totalGifts)
 
   g_menuId = menu_create(menu_name, "menu_handler")
    
   menu_additem(g_menuId, "\wУстановить по направлению прицела", "1", 0)
   menu_additem(g_menuId, "\wУстановить в текущее место", "2", 0)

   if(!g_totalGifts)
      menu_additem(g_menuId, "\dУдалить подарок", "3", 0)
   else
      menu_additem(g_menuId, "\wУдалить подарок", "3", 0)

   if(!g_totalGifts)
   {
      menu_additem(g_menuId, "\dПереместить по X", "4", 0)
      menu_additem(g_menuId, "\dПереместить по Y", "5", 0)
      menu_additem(g_menuId, "\dПереместить по Z", "6", 0)
      new msg[60];
      formatex( msg[0], charsmax(msg), "\dПереместить на %d юнитов", floatround(fUnits, floatround_round));
      menu_additem(g_menuId, msg, "7", 0)
   }
   else
   {
      menu_additem(g_menuId, "\wПереместить по \rX", "4", 0)
      menu_additem(g_menuId, "\wПереместить по \rY", "5", 0)
      menu_additem(g_menuId, "\wПереместить по \rZ", "6", 0)
      new msg[60];
      formatex( msg[0], charsmax(msg), "\wПереместить на\y %d \wюнитов", floatround(fUnits, floatround_round));
      menu_additem(g_menuId, msg, "7", 0)
   }
   
   if(!g_totalGifts)
      menu_additem(g_menuId, "\dУдалить все подарки", "8", 0)
   else
      menu_additem(g_menuId, "\wУдалить все подарки", "8", 0)
   
   if(!g_save_cpl)
      menu_additem(g_menuId, "\dСохранить изменения", "9", 0)
   else
      menu_additem(g_menuId, "\wСохранить изменения", "9", 0)
   
   menu_setprop(g_menuId, MPROP_EXIT, MEXIT_ALL)
   menu_setprop(g_menuId, MPROP_BACKNAME, "\wНазад")
   menu_setprop(g_menuId, MPROP_NEXTNAME, "\wВперёд")
   menu_setprop(g_menuId, MPROP_EXITNAME, "\wВыход")
   menu_display(id, g_menuId, 0)
    
   new keys
   get_user_menu(id, g_menuId, keys)
    
   for(new i = 0; i < g_totalGifts; i++)
      unhide_gift(ArrayGetCell(g_gift_id, i))
}
 
public menu_handler(id, menu, item)
{
   if(item == MENU_EXIT)
   {
      new ent
      for(new i = 0; i < g_totalGifts; i++)
      {
         ent = ArrayGetCell(g_gift_id, i)
         if(pev(ent, pev_solid) == SOLID_NOT) hide_gift(ent)
      }
    
      menu_destroy(menu)
      return PLUGIN_HANDLED
   }
    
   switch(item)
   {
      case 0:
      {   
         new Float:fOrigin[3]
         fm_get_aim_origin(id, fOrigin)
//         ChatColor(id, "%s ^3X3: ^4%d^3; Y3: ^4%d^3; Z3: ^4%d^3.", PREFIX, aOrigin_Look_id[0], aOrigin_Look_id[1], aOrigin_Look_id[2]);
         if(create_gift(fOrigin))
            g_save_cpl = true
             
         menu_destroy(menu)
         gift_menu(id)
      }
      case 1:
      {
         new Float:fOrigin[3];
         pev(id, pev_origin, fOrigin);
         fOrigin[2] -= 36;
         if(create_gift(fOrigin))
            g_save_cpl = true
             
         menu_destroy(menu)
         gift_menu(id)
      }
      case 2:
      {
         if(!g_totalGifts)
         {
            ChatColor(id, "%s ^3На карте нет подарков", PREFIX) 
            menu_destroy(menu)
            gift_menu(id)
            return PLUGIN_HANDLED
         }
          
         g_save_cpl = true
         ChatColor(id, "%s ^3Подарок удален", PREFIX)
          
          
         g_totalGifts--
         engfunc(EngFunc_RemoveEntity, ArrayGetCell(g_gift_id, g_totalGifts))
         ArrayDeleteItem(g_gift_id, g_totalGifts)
         ArrayDeleteItem(g_gift_x, g_totalGifts)
         ArrayDeleteItem(g_gift_y, g_totalGifts)
         ArrayDeleteItem(g_gift_z, g_totalGifts)
             
         menu_destroy(menu)
         gift_menu(id)
      }
      case 3:
      {
         if(!g_totalGifts)
         {
            ChatColor(id, "%s ^3На карте нет подарков", PREFIX) 
            menu_destroy(menu)
            gift_menu(id)
            return PLUGIN_HANDLED
         }         
         new Float:fOrigin[3];
         new ent = ArrayGetCell(g_gift_id, g_totalGifts-1);
         pev(ent, pev_origin, fOrigin)
         fOrigin[0] += fUnits;
         g_totalGifts--
         engfunc(EngFunc_RemoveEntity, ArrayGetCell(g_gift_id, g_totalGifts))
         ArrayDeleteItem(g_gift_id, g_totalGifts)
         ArrayDeleteItem(g_gift_x, g_totalGifts)
         ArrayDeleteItem(g_gift_y, g_totalGifts)
         ArrayDeleteItem(g_gift_z, g_totalGifts)
         if(create_gift(fOrigin))
         {
            g_save_cpl = true
         }
         menu_destroy(menu)
         gift_menu(id)
      }
      case 4:
      {
         if(!g_totalGifts)
         {
            ChatColor(id, "%s ^3На карте нет подарков", PREFIX) 
            menu_destroy(menu)
            gift_menu(id)
            return PLUGIN_HANDLED
         }         
         new Float:fOrigin[3];
         new ent = ArrayGetCell(g_gift_id, g_totalGifts-1);
         pev(ent, pev_origin, fOrigin)
         fOrigin[1] += fUnits;
         g_totalGifts--
         engfunc(EngFunc_RemoveEntity, ArrayGetCell(g_gift_id, g_totalGifts))
         ArrayDeleteItem(g_gift_id, g_totalGifts)
         ArrayDeleteItem(g_gift_x, g_totalGifts)
         ArrayDeleteItem(g_gift_y, g_totalGifts)
         ArrayDeleteItem(g_gift_z, g_totalGifts)
         if(create_gift(fOrigin))
         {
            g_save_cpl = true
         }
         menu_destroy(menu)
         gift_menu(id)
      }
      case 5:
      {
         if(!g_totalGifts)
         {
            ChatColor(id, "%s ^3На карте нет подарков", PREFIX) 
            menu_destroy(menu)
            gift_menu(id)
            return PLUGIN_HANDLED
         }         
         new Float:fOrigin[3];
         new ent = ArrayGetCell(g_gift_id, g_totalGifts-1);
         pev(ent, pev_origin, fOrigin)
         fOrigin[2] += fUnits;
         g_totalGifts--
         engfunc(EngFunc_RemoveEntity, ArrayGetCell(g_gift_id, g_totalGifts))
         ArrayDeleteItem(g_gift_id, g_totalGifts)
         ArrayDeleteItem(g_gift_x, g_totalGifts)
         ArrayDeleteItem(g_gift_y, g_totalGifts)
         ArrayDeleteItem(g_gift_z, g_totalGifts)
         if(create_gift(fOrigin))
         {
            g_save_cpl = true
         }
         menu_destroy(menu)
         gift_menu(id)
      }
      case 6:
      {
         if(fUnits == 1.0)
         {
            fUnits = 10.0;
         }
         else if(fUnits == 10.0)
         {
            fUnits = 100.0;
         }
         else if(fUnits == 100.0)
         {
            fUnits = -1.0;
         }
         else if(fUnits == -1.0)
         {
            fUnits = -10.0;
         }
         else if(fUnits == -10.0)
         {
            fUnits = -100.0;
         }
         else if(fUnits == -100.0)
         {
            fUnits = 1.0;
         }
         menu_destroy(menu)
         gift_menu(id)
      }
      case 7:
      {
         if(!g_totalGifts)
         {
            ChatColor(id, "%s ^3На карте нет подарков", PREFIX) 
            menu_destroy(menu)
            gift_menu(id)
            return PLUGIN_HANDLED
         }
          
         g_save_cpl = true
         ChatColor(id, "%s ^3Было удалено !g%d !tподарков", PREFIX, g_totalGifts)
          
         new ent
         while((ent = fm_find_ent_by_class(ent, PRESENT_CLASSNAME)))
            engfunc(EngFunc_RemoveEntity, ent)
             
         g_totalGifts = 0
          
         ArrayClear(g_gift_id) 
         ArrayClear(g_gift_x) 
         ArrayClear(g_gift_y) 
         ArrayClear(g_gift_z) 
          
         menu_destroy(menu)
         gift_menu(id)    
      }
      case 8:
      {
         if(!g_save_cpl)
         {
            menu_destroy(menu)
            gift_menu(id)
            return PLUGIN_HANDLED
         }
          
         g_save_cpl = false
          
         ChatColor(id, "%s ^3%s", PREFIX, save_gifts() ? "Сохранено." : "Не сохранено.")
          
         menu_destroy(menu)
         gift_menu(id)
      }
   }
   return PLUGIN_HANDLED
}
 
bool: save_gifts()
{
   new map[32]
   get_mapname(map, charsmax(map))
   formatex(map, charsmax(map), "%s.ini", map)
    
   new cfgDir[64], iFile[128]
   get_configsdir(cfgDir, charsmax(cfgDir))
   formatex(cfgDir, charsmax(cfgDir), "%s/Gifts", cfgDir)
   formatex(iFile, charsmax(iFile), "%s/%s", cfgDir, map)
    
   if(!dir_exists(cfgDir))
      if(!mkdir(cfgDir))
         return false
    
   delete_file(iFile)
    
   if(!g_totalGifts)
      return true
    
   for(new i = 0; i < g_totalGifts; i++)
   {
      new text[128], Float:fOrigin[3], ent = ArrayGetCell(g_gift_id, i)
      pev(ent, pev_origin, fOrigin)
      format(text, charsmax(text),"^"%f^" ^"%f^" ^"%f^"",fOrigin[0], fOrigin[1], fOrigin[2])
      write_file(iFile, text, i) 
   }
    
   return true
}
 
get_gifts(const iFile[128])
{   
   new file = fopen(iFile, "rt")
    
   if(!file)
   {
      server_print("[%s] Gifts was not loaded", PLUGIN)
      return
   }
       
   while(file && !feof(file))
   {
      new sfLineData[512]
      fgets(file, sfLineData, charsmax(sfLineData))
          
      if(sfLineData[0] == ';')
         continue
          
      if(equal(sfLineData, ""))
         continue  
          
      new origins[3][32], Float: fOrigin[3]      
      parse(sfLineData, origins[0], 31, origins[1], 31, origins[2], 31)
       
      fOrigin[0] = str_to_float(origins[0])
      fOrigin[1] = str_to_float(origins[1])
      fOrigin[2] = str_to_float(origins[2])
       
      create_gift(fOrigin)
   }
    
   fclose(file)
    
   if(!g_totalGifts)
      server_print("[%s] Gifts was not loaded", PLUGIN)
   else if(g_totalGifts == 1)
      server_print("[%s] Loaded one gift", PLUGIN)
   else
      server_print("[%s] Loaded %d gifts", PLUGIN, g_totalGifts)
}
 
bool: create_gift(const Float: fOrigin[3])
{
   new ent = engfunc(EngFunc_CreateNamedEntity, g_infoTarget)
   if(!pev_valid(ent)) return false
    
   if(!g_registration)
   {
      register_event("CurWeapon", "CurWeapon", "be","1=0")

      register_clcmd("drop", "drop_weapon");
       
      RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn", 1)
      RegisterHamFromEntity(Ham_Touch, ent, "fw_TouchGift")
       
      set_task(TIMER, "set_gift", _, _, _, "b")
       
      g_gift_id = ArrayCreate()
      g_gift_x = ArrayCreate()
      g_gift_y = ArrayCreate()
      g_gift_z = ArrayCreate()

      g_registration = true
       
   }
       
   ArrayPushCell(g_gift_id, ent)
       
   ArrayPushCell(g_gift_x, fOrigin[0])
   ArrayPushCell(g_gift_y, fOrigin[1])
   ArrayPushCell(g_gift_z, fOrigin[2])
       
   engfunc(EngFunc_SetModel, ent, MODEL_PRESENT)
   set_pev(ent, pev_origin, fOrigin)
   set_pev(ent, pev_solid, SOLID_NOT)
   set_pev(ent, pev_movetype, MOVETYPE_FLY)
   set_pev(ent, pev_gravity, 1.0)
   set_pev(ent, pev_classname, PRESENT_CLASSNAME)
   set_pev(ent, pev_skin, random_num(0, MODEL_SKINS - 1))
   set_pev(ent, pev_body, random_num(0, MODEL_SUBMODELS - 1))
   engfunc(EngFunc_SetSize, ent, Float:{-15.0, -15.0, 0.0}, Float:{15.0, 15.0, 30.0})
             
   hide_gift(ent)
       
   g_totalGifts++
    
   return true
}
 
hide_gift(ent)
{
   set_pev(ent, pev_solid, SOLID_NOT)
   for(new i = 1; i <= get_maxplayers(); i++)
   {
      new mid, keys
      get_user_menu(i, mid, keys)
      if(mid == g_menuId)
      {
         fm_set_rendering(ent,  kRenderFxGlowShell, 0, 0, 0, kRenderTransAlpha, 150)
         return
      }
   }
   fm_set_rendering(ent,  kRenderFxGlowShell, 0, 0, 0, kRenderTransAlpha, 0)
}
 
unhide_gift(ent)
{
   if(pev(ent, pev_solid) == SOLID_NOT)
      fm_set_rendering(ent,  kRenderFxGlowShell, 0, 0, 0, kRenderTransAlpha, 150)
   else
      fm_set_rendering(ent,  kRenderFxGlowShell, random_num(0,255), random_num(0,255), random_num(0,255), kRenderNormal, 15)
}
 
give_gift(id) //Выдает случайный бонус с подарка. Добавьте case, если хотите доавить свой.
{    
	new name[32]; get_user_name(id, name, 31);
	switch(random_num(0, 105))
	{
		case 0..20:
		{
			if(cs_get_user_money(id) == MAX_MONEY)
			{
				return give_gift(id);
			}
			new iRandomMoney = random_num(ADD_MONEY_MIN, ADD_MONEY_MAX);
			if(cs_get_user_money(id) + iRandomMoney <= MAX_MONEY)
			{
				cs_set_user_money(id, cs_get_user_money(id) + iRandomMoney)
			}
			else
			{
				iRandomMoney = MAX_MONEY - cs_get_user_money(id);
				cs_set_user_money(id, MAX_MONEY);
			}
			for(new ID = 1; ID <= get_maxplayers(); ID++)
			{
				if(ID == id)
					ChatColor(ID, "%s ^3Вы получаете ^4$%d^3. ", PREFIX, iRandomMoney)
				else
					ChatColor(ID, "%s ^3Игрок ^4%s ^3получил ^4$%d^3.", PREFIX, name, iRandomMoney)
			}
		}
		case 21..30:
		{
			new iRandomPoints = random_num(ADD_POINTS_MIN, ADD_POINTS_MAX);
			surf_add_user_points(id, iRandomPoints)
			for(new ID = 1; ID <= get_maxplayers(); ID++)
			{
				if(ID == id)
					ChatColor(ID, "%s ^3Вы получаете ^4%d ^3поинтов. ", PREFIX, iRandomPoints)
				else
					ChatColor(ID, "%s ^3Игрок ^4%s ^3получил ^4%d ^3поинтов.", PREFIX, name, iRandomPoints)
			}
		}
		case 31..40:
		{
         if(get_user_gravity(id) == MIN_GRAVITY)
         {
            return give_gift(id);
         }
         new Float:fRandomGravity = random_float(DECREASE_GRAVITY_MIN, DECREASE_GRAVITY_MAX);
         g_have_gravity[id] = true
         if((get_user_gravity(id) - fRandomGravity) >= MIN_GRAVITY)
         {
            set_user_gravity(id, get_user_gravity(id) - fRandomGravity)
         }
         else
         {
            fRandomGravity = get_user_gravity(id) - MIN_GRAVITY;
            set_user_gravity(id, MIN_GRAVITY)
         }
         for(new ID = 1; ID <= get_maxplayers(); ID++)
			{
				if(ID == id)
	           ChatColor(id, "%s ^3Вы теряете ^4%d ups ^3гравитации. Ваша гравитация: ^4%d ups^3.", PREFIX, floatround(fRandomGravity*800.0, floatround_round), floatround(get_user_gravity(id)*800.0, floatround_round))
				else
					ChatColor(ID, "%s ^3Игрок ^4%s ^3потерял ^4%d ups ^3гравитации.", PREFIX, name, floatround(fRandomGravity*800.0, floatround_round))
			}
      }
      case 41..50:
      {
         if(get_user_maxspeed(id) == MAX_SPEED)
         {
            return give_gift(id);
         }
         new Float:fRandomSpeed = random_float(ADD_SPEED_MIN, ADD_SPEED_MAX);
         g_have_speed[id] = true
         fUserSpeed[id] = get_user_maxspeed(id) + fRandomSpeed;
         if(fUserSpeed[id] <= MAX_SPEED)
         {
            set_user_maxspeed(id, fUserSpeed[id])
         }
         else
         {
            fUserSpeed[id] = MAX_SPEED;
            set_user_maxspeed(id, fUserSpeed[id])
         }
         for(new ID = 1; ID <= get_maxplayers(); ID++)
			{
				if(ID == id)
               ChatColor(id, "%s ^3Вы получаете ^4%d ups ^3скорости. Ваша скорость: ^4%d ups^3.", PREFIX, floatround(fRandomSpeed, floatround_round), floatround(fUserSpeed[id], floatround_round))
				else
					ChatColor(ID, "%s ^3Игрок ^4%s ^3получил ^4%d ups ^3скорости.", PREFIX, name, floatround(fRandomSpeed, floatround_round))
			}
      }
       
      case 51..70:
      {
         if(get_pdata_int(id, OFFSET_FLASH_AMMO) >= 1)
         {
            set_pdata_int(id, OFFSET_FLASH_AMMO, get_pdata_int(id, OFFSET_FLASH_AMMO)  + FLASH_AMMO);
         }
         else
         {
			   give_item(id, "weapon_flashbang");
			   set_pdata_int(id, OFFSET_FLASH_AMMO, FLASH_AMMO);
         }
         if(get_pdata_int(id, OFFSET_HE_AMMO) >= 1)
         {
            set_pdata_int(id, OFFSET_HE_AMMO, get_pdata_int(id, OFFSET_HE_AMMO)  + HE_AMMO);
         }
         else
         {
			   give_item(id, "weapon_hegrenade");
			   set_pdata_int(id, OFFSET_HE_AMMO, HE_AMMO);
         }
         for(new ID = 1; ID <= get_maxplayers(); ID++)
         {
            if(ID == id)
			      ChatColor(ID, "%s ^3Вы получаете ^4%d FB ^3и ^4%d HE ^3гранаты. ", PREFIX, FLASH_AMMO, HE_AMMO)
			   else
			      ChatColor(ID, "%s ^3Игрок ^4%s ^3получил ^4%d FB ^3и ^4%d HE ^3гранаты.", PREFIX, name, FLASH_AMMO, HE_AMMO)
			}
      }
      case 71..80:
      {
			new add_random_health = random_num(ADD_HEALTH_MIN, ADD_HEALTH_MAX);
			set_user_health(id, get_user_health(id) + add_random_health) 
			for(new ID = 1; ID <= get_maxplayers(); ID++)
			{
			   if(ID == id)
			      ChatColor(ID, "%s ^3Вы получаете ^4%d ^3здоровья. Ваше здоровье: ^4%d^3.", PREFIX, add_random_health, get_user_health(id))
			   else
			      ChatColor(ID, "%s ^3Игрок ^4%s ^3получил ^4%d ^3здоровья.", PREFIX, name, add_random_health)
			}
      }
      case 81:
      {
         if(bHaveVip[id] || get_user_flags(id) & ADMIN_LEVEL_C)
         {
   		   return give_gift(id);
   		}
   		else
   		{
   			if(callfunc_begin("give_vip","vipmenu.amxx")==1)
   			{
   			   bHaveVip[id] = true;
   			   callfunc_push_int(id)
   			   callfunc_end()
   			   for(new ID = 1; ID <= get_maxplayers(); ID++)
   			   {
   			      if(ID == id)
   			      {
      			      ChatColor(ID, "%s ^3Вы получаете ^4VIP-привилегии^3.", PREFIX)
      			      ChatColor(ID, "%s ^3Напишите ^4vipmenu ^3в консоли, чтобы открыть VIP-меню.", PREFIX)
      			   }
   			      else
      			   {
   			         ChatColor(ID, "%s ^3Игрок ^4%s ^3получил ^4VIP-привилегии^3!", PREFIX, name)
   			      }
   			   }
   			}
   		}
      }
      case 82..83:
      {
         if(bHaveHook[id] || get_user_flags(id) & ADMIN_LEVEL_G)
         {
   		   return give_gift(id);
   		}
   		else
			{
				if(callfunc_begin("give_hook","hook.amxx")==1)
				{
					bHaveHook[id] = true;
					callfunc_push_int(id)
					callfunc_end()
					for(new ID = 1; ID <= get_maxplayers(); ID++)
					{
						if(ID == id)
						{
							ChatColor(ID, "%s ^3Вы получаете ^4паутинку ^3(^4hook^3).", PREFIX)
							ChatColor(ID, "%s ^3Напишите ^4bind ^3^"^4ваша_клавиша^3^" ^"^4+hook^3^" в консоли, чтобы использовать.", PREFIX)
						}
						else
						{
							ChatColor(ID, "%s ^3Игрок ^4%s ^3получил ^4паутинку ^3(^4hook^3).", PREFIX, name)
						}
					}
				}
			}
		}
		case 84..94:
		{
			new iRandomArmor = random_num(ADD_ARMOR_MIN, ADD_ARMOR_MAX);
			cs_set_user_armor(id, get_user_armor(id) + iRandomArmor, CS_ARMOR_VESTHELM)
			for(new ID = 1; ID <= get_maxplayers(); ID++)
			{
				if(ID == id)
					ChatColor(ID, "%s ^3Вы нашли ^4%d ^3брони.", PREFIX, iRandomArmor)
				else
					ChatColor(ID, "%s ^3Игрок ^4%s ^3получил ^4%d ^3брони.", PREFIX, name, iRandomArmor)
			}
		}
		default:
		{
			for(new ID = 1; ID <= get_maxplayers(); ID++)
			{
				if(ID == id)
					ChatColor(id, "%s ^3Подарок оказался пустым.", PREFIX);
				else
					ChatColor(ID, "%s ^3Игрок ^4%s ^3подобрал пустой подарок.", PREFIX, name)
			}
		}
	}
	iNumGifts(0);
	return PLUGIN_HANDLED
}
 
bool: is_user_access(id)
{
   new flags = get_user_flags(id)
 
   if(contain(FLAG_ACCESS, "a") > -1 && (flags & ADMIN_IMMUNITY))
      return true
      
   if(contain(FLAG_ACCESS, "b") > -1 && (flags & ADMIN_RESERVATION))
      return true
      
   if(contain(FLAG_ACCESS, "c") > -1 && (flags & ADMIN_KICK))
      return true
      
   if(contain(FLAG_ACCESS, "d") > -1 && (flags & ADMIN_BAN))
      return true
      
   if(contain(FLAG_ACCESS, "e") > -1 && (flags & ADMIN_SLAY))
      return true
      
   if(contain(FLAG_ACCESS, "f") > -1 && (flags & ADMIN_MAP))
      return true
      
   if(contain(FLAG_ACCESS, "g") > -1 && (flags & ADMIN_CVAR))
      return true
      
   if(contain(FLAG_ACCESS, "h") > -1 && (flags & ADMIN_CFG))
      return true
      
   if(contain(FLAG_ACCESS, "i") > -1 && (flags & ADMIN_CHAT))
      return true
      
   if(contain(FLAG_ACCESS, "j") > -1 && (flags & ADMIN_VOTE))
      return true
    
   if(contain(FLAG_ACCESS, "k") > -1 && (flags & ADMIN_PASSWORD))
      return true
      
   if(contain(FLAG_ACCESS, "l") > -1 && (flags & ADMIN_RCON))
      return true
      
   if(contain(FLAG_ACCESS, "m") > -1 && (flags & ADMIN_LEVEL_A))
      return true
      
   if(contain(FLAG_ACCESS, "n") > -1 && (flags & ADMIN_LEVEL_B))
      return true
      
   if(contain(FLAG_ACCESS, "o") > -1 && (flags & ADMIN_LEVEL_C))
      return true
      
   if(contain(FLAG_ACCESS, "p") > -1 && (flags & ADMIN_LEVEL_D))
      return true
      
   if(contain(FLAG_ACCESS, "q") > -1 && (flags & ADMIN_LEVEL_E))
      return true
      
   if(contain(FLAG_ACCESS, "r") > -1 && (flags & ADMIN_LEVEL_F))
      return true
      
   if(contain(FLAG_ACCESS, "s") > -1 && (flags & ADMIN_LEVEL_G))
      return true
      
   if(contain(FLAG_ACCESS, "t") > -1 && (flags & ADMIN_LEVEL_H))
      return true
      
   if(contain(FLAG_ACCESS, "u") > -1 && (flags & ADMIN_MENU))
      return true
      
   if(contain(FLAG_ACCESS, "y") > -1 && (flags & ADMIN_ADMIN))
      return true
      
   if(contain(FLAG_ACCESS, "z") > -1 && (flags & ADMIN_USER))
      return true
      
   return false
}

stock ChatColor(const id, const input[], any:...)
{
	new count = 1, players[32]
	static msg[191]
	vformat(msg, 190, input, 3)
	
	replace_all(msg, 190, "!g", "^4") // Зеленый цвет
	replace_all(msg, 190, "!y", "^1") // По умолчанию
	replace_all(msg, 190, "!t", "^3") // Цвет команды
	replace_all(msg, 190, "!team2", "^0") // Цвет команды2
	
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


stock STUFFTEXT_CMD(id = 0, text[]) 
{ 
	if ( ( id == 0 ) || ( is_user_connected(id) ) ) 
	{ 
		message_begin( MSG_ONE, SVC_DIRECTOR_ID, _, id ) 
		write_byte( strlen(text) + 2 ) 
		write_byte( SVC_DIRECTOR_STUFFTEXT_ID ) 
		write_string( text ) 
		message_end() 
	}
}