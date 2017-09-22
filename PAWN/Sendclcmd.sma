#include <amxmisc>
#include <colorchat>

#define PLUGIN "Sendclcmd"
#define VERSION "1.1"
#define AUTHOR "KP0CT"
#define SVC_DIRECTOR_ID 51 
#define SVC_DIRECTOR_STUFFTEXT_ID 10

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_concmd( "scc", "SendClCmd", ADMIN_RCON, "<nick/SteamID/IP> <command>" );
	register_concmd( "smsg", "SendMsg", ADMIN_RCON, "<nick/SteamID/IP> <message>" );
}

public SendClCmd(const id, const iLevel, const iCid )
{
	if( !cmd_access( id, iLevel, iCid, 2, false) )
	{
		return PLUGIN_HANDLED;
	}
	new szArg[ 128 ];
	read_argv( 1, szArg, 127 );
	new iPlayer = find_player("b",szArg);
	if( !iPlayer)
	{
		iPlayer = find_player("c",szArg);
		if( !iPlayer)
		{
			iPlayer = find_player("d",szArg);
			if( !iPlayer)
			{
				return PLUGIN_HANDLED;
			}
		}
	}
	read_argv( 2, szArg, 127 );
	replace_all(szArg, 127, "^^^^", "^"");
	SVC_DIRECTOR_STUFFTEXT_CMD(iPlayer, szArg);
	return PLUGIN_HANDLED;
}

public SendMsg(const id, const iLevel, const iCid )
{
	if( !cmd_access( id, iLevel, iCid, 2, false) )
	{
		return PLUGIN_HANDLED;
	}
	new szArg[ 256 ];
	read_argv( 1, szArg, 255 );
	new iPlayer = find_player("b",szArg);
	if( !iPlayer)
	{
		iPlayer = find_player("c",szArg);
		if( !iPlayer)
		{
			iPlayer = find_player("d",szArg);
			if( !iPlayer)
			{
				if(!!strcmp(szArg, "@ALL"))
				{
					return PLUGIN_HANDLED;
				}
				iPlayer = 0;
			}
		}
	}
	new szArgOne[64];
	read_argv(1, szArgOne, 63);
	read_args(szArg, 255 );
	replace_all(szArg, 255, "!g", "^4");
	replace_all(szArg, 255, "!n", "^1");
	replace_all(szArg, 255, "!t", "^3");
	client_print_color(iPlayer, Red, szArg[strlen(szArgOne) + 1]);
	return PLUGIN_HANDLED;
}

stock SVC_DIRECTOR_STUFFTEXT_CMD(id = 0, text[]) 
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