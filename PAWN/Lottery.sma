#include <amxmodx>
#include <cstrike>
#include <colorchat>
#include <surf>

#define PLUGIN "Lottery"
#define VERSION "1.0"
#define AUTHOR "KP0CT"
#define PREFIX "^1[^4Лотерея^1]"
#define LOTTERY_COST 20
#define LOTTERY_INTERVAL 30 // in sec
#define MIN_VALUE 0
#define MAX_VALUE 40
#define ends_with_1( %0 )             ( ( ( %0 )  == 1 ) || ( ( %0 ) > 20 && ( %0 ) % 10 == 1 ) )
#define ends_with_234( %0 )         ( ( 2 <= ( %0 ) <= 4 ) || ( ( %0 ) > 20 ) && ( ( %0 ) % 10 ) > 1 && ( ( %0 ) % 10 ) < 5 )

new g_iUserRound[33], bool:bTimer[33];
new iTimeLeft[33];

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_clcmd("say /lottery","lottery")
	register_clcmd("lottery","lottery")
	register_event("HLTV", "Event_HLTV", "a", "1=0", "2=0");
}

public Event_HLTV()
{
	for(new i = 1; i <= get_maxplayers(); i++)
	{
		if(is_user_connected(i))
		{
			g_iUserRound[i] = false;
		}
	}
}

public lottery(id)
{
	if(!g_iUserRound[id])
	{
		if(!bTimer[id])
		{
			if(surf_get_user_points(id) >= LOTTERY_COST)
			{
				new name[32], sMessage[256] = ""; get_user_name(id, name, 31);
				new iRandNum  = random_num(MIN_VALUE, MAX_VALUE)
				new iResultPoints = iRandNum - LOTTERY_COST;
				new iLen;
				if(iResultPoints >= 1)
				{
					iLen = formatex(sMessage, 255, "%s ^4Игрок ^3%s ", PREFIX, name)
					iLen += formatex(sMessage[iLen], charsmax(sMessage) - iLen, "^4выиграл ^3%d", iResultPoints)
					if( ends_with_1( iResultPoints ) )
					{
						iLen += add(sMessage, charsmax(sMessage) - iLen, " ^4поинт")
					}
					else if( ends_with_234( iResultPoints ) )
					{
						iLen += add(sMessage, charsmax(sMessage) - iLen, " ^4поинта")
					}
					else
					{
						iLen += add(sMessage, charsmax(sMessage) - iLen, " ^4поинтов")
					}
				}
				else if(iResultPoints <= -1)
				{
					iLen = formatex(sMessage, 255, "%s ^3Игрок ^4%s ", PREFIX, name)
					iLen += formatex(sMessage[iLen], charsmax(sMessage) - iLen, "^3проиграл ^4%d", absiResultPoints)
					if( ends_with_1( iResultPoints ) )
					{
						iLen += add(sMessage, charsmax(sMessage) - iLen, " ^3поинт")
					}
					else if( ends_with_234( iResultPoints ) )
					{
						iLen += add(sMessage, charsmax(sMessage) - iLen, " ^3поинта")
					}
					else
					{
						iLen += add(sMessage, charsmax(sMessage) - iLen, " ^3поинтов")
					}
				}
				else if(!iResultPoints)
				{
					iLen = formatex(sMessage, 255, "%s ^3Игрок ^4%s ", PREFIX, name)
					iLen += copy(sMessage[iLen], charsmax(sMessage) - iLen, "^3ничего не выиграл.")
				}
				client_print_color(0, Red, sMessage)
				client_print(0, print_notify, sMessage)
				surf_del_user_points(id, LOTTERY_COST)
				surf_add_user_points(id, iRandNum)
				g_iUserRound[id] = true;
				bTimer[id] = true;
				iTimeLeft[id] = LOTTERY_INTERVAL;
				Timer(id);
			}
				else
			{
				client_print_color(id, Red,"%s ^3Недостаточно поинтов .", PREFIX)
			}
		}
		else
		{
			client_print_color(id, Red,"%s ^3Будет доступно через %d сек.", PREFIX, iTimeLeft[id])
		}
	}
	else
	{
		client_print_color(id, Red,"%s ^3Будет доступно в следующем раунде .", PREFIX)
	}
	return PLUGIN_HANDLED
}

public Timer(id)
{
	if(iTimeLeft[id] == 1)
	{
		bTimer[id] = false;
	}
	else
	{
		iTimeLeft[id]--;
		set_task(1.0, "Timer", id);
	}
}