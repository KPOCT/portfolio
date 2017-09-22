#include <amxmodx>
#include <regex>

#define PLUGIN "NickFix"
#define VERSION "1.0"
#define AUTHOR "KP0CT"

new Regex:g_iPattern;

public plugin_init()
{
   register_plugin(PLUGIN, VERSION, AUTHOR);
   new sError[64], iError;
   g_iPattern = regex_compile("\+[abcdfghijlmnprstuv]", iError, sError, charsmax(sError), "i");
   if(iError < 0)
   {
      set_fail_state(sError);
   }
}

public client_infochanged(id)
{
   new sNewName[32], sOldName[32];
   get_user_info(id, "name", sNewName, 31);
   get_user_name(id, sOldName, 31);
   if(!equal(sNewName, sOldName))
   {
      Check(id, sNewName);
   }
}

Check(id, sNewName[] = "")
{
   new sName[32];
   if(sNewName[0])
   {
      copy(sName, 31, sNewName);
   }
   else
   {
      get_user_name(id, sName, 31);
   }
   new iNum;
   new sSubStr[3];
   new sNewTxtPart[3];
   while(regex_match_c(sName, g_iPattern, iNum))
   {
      regex_substr(g_iPattern, 0, sSubStr, 2);
      copy(sNewTxtPart, 2, sSubStr);
      replace(sNewTxtPart, 2, "+", "");
      replace_all(sName, 31, sSubStr, sNewTxtPart);
   }
   set_user_info(id, "name", sName);
}