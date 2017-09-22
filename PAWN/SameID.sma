#include <amxmodx>
 
#define PLUGIN "SameID (fix)"
#define VERSION "0.3"
#define AUTHOR "KPOCT"
 
#define MAX_PLAYERS 32
 
new bool:g_bIsPlayer[MAX_PLAYERS + 1]
new g_szAuthIDs[MAX_PLAYERS + 1][35]
new Trie:g_tAuthIDs
 
public plugin_init()
{
   register_plugin(PLUGIN, VERSION, AUTHOR)
 
   g_tAuthIDs = TrieCreate()
}
 
public client_putinserver(id)
{
   if(!(g_bIsPlayer[id] = bool:(!is_user_bot(id) && !is_user_hltv(id))))
      return
 
   get_user_authid(id, g_szAuthIDs[id], charsmax(g_szAuthIDs[]))
 
   if(!is_valid_authid(g_szAuthIDs[id]))
      return
 
   if(!TrieKeyExists(g_tAuthIDs, g_szAuthIDs[id]))
      TrieSetCell(g_tAuthIDs, g_szAuthIDs[id], id)
   else
      server_cmd("kick #%i ^"На сервере уже есть игрок с этим SteamID^"", get_user_userid(id))
}
 
public client_disconnect(id)
{
   if(!g_bIsPlayer[id])
      return
 
   static iUserId
   TrieGetCell(g_tAuthIDs, g_szAuthIDs[id], iUserId)
 
   if(iUserId == id)
      TrieDeleteKey(g_tAuthIDs, g_szAuthIDs[id])
 
   g_szAuthIDs[id][0] = '^0'
}
 
public plugin_end()
   TrieDestroy(g_tAuthIDs)
 
stock is_valid_authid(const szAuthID[])
{
   static const szAuthIDs[][] = { "STEAM_ID_LAN", "STEAM_ID_PENDING", "VALVE_ID_LAN", "VALVE_ID_PENDING", "STEAM_666:88:666" }
 
   for(new i = 0; i <= charsmax(szAuthIDs); i++)
   {
      if(equali(szAuthID, szAuthIDs[i]))
         return false
   }
   return true
}