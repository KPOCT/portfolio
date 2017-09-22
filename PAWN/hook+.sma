#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <fakemeta>
#include <xs>
#include <cstrike>

#define PLUGIN "Hook+"
#define VERSION "1.1"
#define AUTHOR "KP0CT"
#define PREFIX "^1[^4Паутинка^1]"
#define MAPS_NOT_BLOCK_PATH "addons/amxmodx/configs/MapsNotBlock.ini"
#define SOUND_PATH "hook/hook.wav"
#define SPRITE_PATH "sprites/hook/hook.spr"
#define MAX_HOOK 15
#define A get_distance_f(aOrigin_id, aOrigin_Look_id)
#define B get_distance_f(aOrigin_id2, aOrigin_id)
#define C get_distance_f(aOrigin_Look_id, aOrigin_id2)
#define A2 get_distance_f(aOrigin_id, hookorigin[id])
#define B2 get_distance_f(hookorigin[id], aOrigin_id2)
#define C2 get_distance_f(aOrigin_id2, aOrigin_id)
#define COSALFA ((pow_f(B) + pow_f(C) - pow_f(A)) / (2.0 * B * C))
#define COSBETA ((pow_f(A2) + pow_f(C2) - pow_f(B2)) / (2.0 * A2 * C2))
#define D 150.0
#define A3 (C2 * xs_sqrt(1 - pow_f(cosa))) / cosa
#define C3 (B * xs_sqrt(1 - pow_f(cosb))) / cosb

new
      bool:bNotBlock,
      bool:bGift[33],
      bool:bIsHooked[33],
      bAtGunpoint[33],
      bIsNotItPossibleToAttack[33],
      blockhook[33],
      Float:hookorigin[33][3],
      iSprite;

public plugin_init()
{
   register_plugin(PLUGIN, VERSION, AUTHOR)
   RegisterHam(Ham_Spawn, "player", "Spawn_player", 1)
   RegisterHam(Ham_TakeDamage, "player", "Take_damage", 0)
   register_clcmd("+hook","hook_on")
   register_clcmd("-hook","hook_off")
}

public plugin_cfg()
{
   new file_MapsNotBlock = fopen(MAPS_NOT_BLOCK_PATH, "rt");
   if (!file_MapsNotBlock)
   {
      server_print("Failed to open file ^"%s^"", MAPS_NOT_BLOCK_PATH);
      return;
   }
   new szMapName[64] ; get_mapname(szMapName , charsmax(szMapName));
   new szBuffer[64]
   while(!feof(file_MapsNotBlock))
   {
      fgets(file_MapsNotBlock, szBuffer, charsmax( szBuffer ));
      trim(szBuffer);
      if(!szBuffer[0] || szBuffer[0] == '[' || szBuffer[0] == ']')
      {
         continue;
      }
      if (equal(szBuffer, szMapName))
      {
         bNotBlock = true
      }
   }
}

public plugin_precache()
{
   precache_sound(SOUND_PATH)
   iSprite = precache_model(SPRITE_PATH)
}

public Spawn_player(id)
{
   if(is_user_alive(id) && is_user_connected(id))
   {
      blockhook[id] = 0
      bAtGunpoint[id] = false;
   }
}

public client_disconnect(id)
{
   remove_hook(id)
   bGift[id] = false;
}

public client_putinserver(id)
{
   remove_hook(id)
}

public hook_on(id, level, cid)
{
   if(get_user_flags(id) & ADMIN_LEVEL_G || bGift[id]) /// Флаг s
   {
      if(!cmd_access(id, level, cid, 1, true))
      {
         return PLUGIN_HANDLED
      }
      if(!is_user_alive(id))
      {
         ChatColor(id, "%s ^3Нельзя использовать: Вы мертвы!", PREFIX)
         return PLUGIN_HANDLED
      }
      if(bNotBlock)
      {
         fm_get_aim_origin(id, hookorigin[id])
         set_task(0.1,"hook_task",id,"",0,"ab")
         if(hook_task(id) == -1)
         {
            return PLUGIN_HANDLED
         }
         bIsHooked[id] = true
         emit_sound(id, CHAN_STATIC, SOUND_PATH, 1.0, ATTN_NORM, 0, PITCH_NORM)
         return PLUGIN_HANDLED;
      }
      if(blockhook[id] < MAX_HOOK) /// Ограничение
      {
         fm_get_aim_origin(id, hookorigin[id])
         new Float:aOrigin_id[3];
         pev(id, pev_origin, aOrigin_id);
         for(new id2 = 1; id2 <= get_maxplayers(); id2++)
         {
               if(is_user_connected(id2) && is_user_alive(id2))
               {
                  if(cs_get_user_team(id) == CS_TEAM_T && cs_get_user_team(id2) == CS_TEAM_CT || cs_get_user_team(id) == CS_TEAM_CT && cs_get_user_team(id2) == CS_TEAM_T)
                  {
                     new Float:aOrigin_id2[3];
                     pev(id2, pev_origin, aOrigin_id2);
                     new Float:cosb = COSBETA;
                     new Float:c3 = C3;
                     if((0.0 < cosb < 1.0) && (D > c3))
                     {
///                     ChatColor(id,"%s ^3C3: ^4%.5f^3; cosb: ^4%.5f^3.", PREFIX, C3, cosb)
                        ChatColor(id,"%s ^3Нельзя подлетать к противнику.", PREFIX)
                        return PLUGIN_HANDLED
                     }
///                     ChatColor(id, "%s ^3Косинус угла: ^4%.5f ^3. ID1: ^4%d^3. ID2: ^4%d^3.", PREFIX, COSBETA, id, id2);
///                     ChatColor(id, "%s ^3X1: ^4%.1f^3; Y1: ^4%.1f^3; Z1: ^4%.1f^3.", PREFIX, aOrigin_id[0], aOrigin_id[1], aOrigin_id[2]);
///                     ChatColor(id, "%s ^3X2: ^4%.1f^3; Y2: ^4%.1f^3; Z2: ^4%.1f^3.", PREFIX, aOrigin_id2[0], aOrigin_id2[1], aOrigin_id2[2]);
///                     ChatColor(id, "%s ^3X3: ^4%.1f^3; Y3: ^4%.1f^3; Z3: ^4%.1f^3.", PREFIX, hookorigin[id][0], hookorigin[id][1], hookorigin[id][2]);
///                     ChatColor(id, "%s ^3A13: ^4%.1f^3; B12: ^4%.1f^3; C23: ^4%.1f^3.", PREFIX, A2, B, C2);
                  }
               }
         }
         set_task(0.1,"hook_task",id,"",0,"ab")
         if(hook_task(id) == -1)
         {
            return PLUGIN_HANDLED
         }
         bIsHooked[id] = true
         ++blockhook[id]
         emit_sound(id, CHAN_STATIC, SOUND_PATH, 1.0, ATTN_NORM, 0, PITCH_NORM)
         ChatColor(id,"%s ^3Вы использовали ^4%d ^3раз из ^4%d^3!", PREFIX, blockhook[id], MAX_HOOK)
      }
      else
      {
         ChatColor(id,"%s ^3Вы достигли лимита в этом раунде.", PREFIX)
         return PLUGIN_HANDLED
      }
   }
   else
   {
      ChatColor(id,"%s ^3У Вас нет паутинки. Напишите в чат ^4/adminka^3, чтобы узнать о покупке.", PREFIX)
      return PLUGIN_HANDLED
   }        
   return PLUGIN_HANDLED
}

public is_hooked(id)
{
   return bIsHooked[id]
}

public hook_off(id)
{
   if(get_user_flags(id) & ADMIN_LEVEL_G || bGift[id])
   {
      remove_hook(id)
   }
   else
   {
      return PLUGIN_HANDLED
   }
   return PLUGIN_HANDLED
}

public hook_task(id)
{
   if(!is_user_connected(id) || !is_user_alive(id))
   {
      ChatColor(id, "%s ^3Нельзя использовать: Вы мертвы!", PREFIX)
      return remove_hook(id)
   }
   new Float:aOrigin_id[3];
   pev(id, pev_origin, aOrigin_id);
   for(new id2 = 1; id2 <= get_maxplayers(); id2++)
   {
         if(is_user_connected(id2) && is_user_alive(id2))
         {
            if(cs_get_user_team(id) == CS_TEAM_T && cs_get_user_team(id2) == CS_TEAM_CT || cs_get_user_team(id) == CS_TEAM_CT && cs_get_user_team(id2) == CS_TEAM_T)
            {
               new Float:aOrigin_id2[3], Float:aOrigin_Look_id[3];
               pev(id2, pev_origin, aOrigin_id2);
               fm_get_aim_origin(id2, aOrigin_Look_id);
               if(get_distance_f(aOrigin_id, aOrigin_id2) <= 400.0)
               {
                  ChatColor(id, "%s ^3Нельзя использовать: рядом противник!", PREFIX);
                  return remove_hook(id);
               }
               new Float:cosa = COSALFA;
               new Float:a3 = A3;
               if((0.0 < cosa < 1.0) && (D > a3))
               {
///                 ChatColor(id,"%s ^3C3: ^4%.5f^3; cosb: ^4%.5f^3.", PREFIX, A3, cosa)
                     bAtGunpoint[id] = true;
                     remove_task(id+1);
                     set_task(3.0, "remove_bAtGunpoint", id+1);
               }
///               ChatColor(id, "%s ^3Косинус угла: ^4%.5f ^3. ID1: ^4%d^3. ID2: ^4%d^3.", PREFIX, COSALFA, id, id2);
///               ChatColor(id, "%s ^3X1: ^4%.1f^3; Y1: ^4%.1f^3; Z1: ^4%.1f^3.", PREFIX, aOrigin_id[0], aOrigin_id[1], aOrigin_id[2]);
///               ChatColor(id, "%s ^3X2: ^4%.1f^3; Y2: ^4%.1f^3; Z2: ^4%.1f^3.", PREFIX, aOrigin_id2[0], aOrigin_id2[1], aOrigin_id2[2]);
///               ChatColor(id, "%s ^3X3: ^4%.1f^3; Y3: ^4%.1f^3; Z3: ^4%.1f^3.", PREFIX, aOrigin_Look_id[0], aOrigin_Look_id[1], aOrigin_Look_id[2]);
///               ChatColor(id, "%s ^3A13: ^4%.1f^3; B12: ^4%.1f^3; C23: ^4%.1f^3.", PREFIX, A, B, C);
            }
         }
   }
   if(bAtGunpoint[id])
   {
      ChatColor(id, "%s ^3Нельзя использовать: Вы под прицелом!", PREFIX)
      return remove_hook(id)
   }
   new Float:velocity[3]
   pev(id, pev_origin, aOrigin_id)
   new Float:distance = get_distance_f(hookorigin[id], aOrigin_id);
   if(distance > 32.0)
   {
      bIsNotItPossibleToAttack[id] = true;
      remove_task(id+2);
      set_task(3.0, "remove_bIsNotItPossibleToAttack", id+2);
      remove_beam(id)
      draw_hook(id)
      velocity[0] = (hookorigin[id][0] - aOrigin_id[0]) * (2.0 * 300 / distance)
      velocity[1] = (hookorigin[id][1] - aOrigin_id[1]) * (2.0 * 300 / distance)
      velocity[2] = (hookorigin[id][2] - aOrigin_id[2]) * (2.0 * 300 / distance)
      set_pev(id,pev_velocity,velocity)
   }
   else
   {
      set_pev(id,pev_velocity,Float:{0.0,0.0,0.0})
      return remove_hook(id)
   }
   return PLUGIN_HANDLED;
}

public Take_damage(id, weapon, id2)
{
   if(is_user_connected(id) && is_user_connected(id2))
   {
      if(cs_get_user_team(id2) == CS_TEAM_CT && cs_get_user_team(id) == CS_TEAM_T || cs_get_user_team(id2) == CS_TEAM_T && cs_get_user_team(id) == CS_TEAM_CT)
      {
         if(bIsNotItPossibleToAttack[id2])
         {
            return HAM_SUPERCEDE;
         }
      }
   }
   return HAM_IGNORED;
}

public remove_bAtGunpoint(id)
{
      bAtGunpoint[id-1] = false;
}

public remove_bIsNotItPossibleToAttack(id)
{
   bIsNotItPossibleToAttack[id-2] = false;
}

public draw_hook(id)
{
   message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
   write_byte(1)                /// TE_BEAMENTPOINT
   write_short(id)                /// entid
   write_coord(floatround(hookorigin[id][0], floatround_round))    /// origin
   write_coord(floatround(hookorigin[id][1], floatround_round))    /// origin
   write_coord(floatround(hookorigin[id][2], floatround_round))    /// origin
   write_short(iSprite)            /// sprite index
   write_byte(0)                /// start frame
   write_byte(0)                /// framerate
   write_byte(100)                /// life
   write_byte(41)                /// ширина спрайта
   write_byte(0)                /// noise
   if(get_user_team(id) == 1)
   {
      write_byte(192) ///R    /|/   СЕРЫЙ ЦВЕТ (R, G, B)
      write_byte(192) ///G
      write_byte(192) ///B
   }
   else
   {
      write_byte(192) ///R    /|/   СЕРЫЙ ЦВЕТ (R, G, B)
      write_byte(192) ///G
      write_byte(192) ///B
   }
   write_byte(250) /// brightness
   write_byte(5)  /// speed
   message_end()
}

public remove_hook(id)
{
   if(task_exists(id))
   {
      remove_task(id)
   }
   remove_beam(id)
   bIsHooked[id] = false
   return -1;
}

public remove_beam(id)
{
   message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
   write_byte(99)
   write_short(id)
   message_end()
}

public give_hook(id)
{
   bGift[id] = true;
}

public Float:pow_f(Float:fNum)
{
   return (fNum * fNum);
}

stock ChatColor(const id, const input[], any:...)
{
   new count = 1, players[32]
   static msg[191]
   vformat(msg, 190, input, 3)
   replace_all(msg, 190, "!g", "^4") /// Green Color
   replace_all(msg, 190, "!y", "^1") /// Default Color
   replace_all(msg, 190, "!t", "^3") /// Team Color
   replace_all(msg, 190, "!t2", "^0") /// Team2 Color
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

stock fm_get_aim_origin(id, Float:aOrigin[3])
{
   new Float:start[3], Float:view_ofs[3];
   pev(id, pev_origin, start);
   pev(id, pev_view_ofs, view_ofs);
   xs_vec_add(start, view_ofs, start);

   new Float:dest[3];
   pev(id, pev_v_angle, dest);
   engfunc(EngFunc_MakeVectors, dest);
   global_get(glb_v_forward, dest);
   xs_vec_mul_scalar(dest, 9999.0, dest);
   xs_vec_add(start, dest, dest);

   engfunc(EngFunc_TraceLine, start, dest, 0, id, 0);
   get_tr2(0, TR_vecEndPos, aOrigin);

   return 1;
}