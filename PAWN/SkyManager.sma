/* Random sky 0.1 [16.09.2016] */
/* SkyManager 0.2 [19.01.2017] */
/* SkyManager 0.3 (with random) [20.01.2017] */
/* SkyManager 0.4 (improved random) [to be continued... expect..] */

#include <amxmodx>
#include <gmf_directory>

#pragma semicolon 1

new const INI_FILE_NAME[] = "SkyManager.ini";

const MAP_STRLEN = 32;
const SKY_STRLEN = 24;
const PATH_LENGTH = 96;
const FILE_STRING_LENGTH = 512;

new g_SkyName[SKY_STRLEN];

public plugin_precache()
{
	register_plugin("SkyManager", "0.4", "Subb98 & KPOCT");
	if(get_skyname_from_file(g_SkyName, charsmax(g_SkyName)))
	{
		if(g_SkyName[0])
		{
			PrecacheSkyName(g_SkyName);
		}
	}
	else
	{
		g_SkyName[0] = 0;
		log_amx("Failed to load the sky from a ini file.");
	}
}

public plugin_cfg()
{
	if(g_SkyName[0])
	{
		set_cvar_string("sv_skyname", g_SkyName);
	}
	pause("d");
}

bool:get_skyname_from_file(sSkyNameOut[], const iLen_SkyNameOut)
{
	new sConfigsDir[PATH_LENGTH];
	gmf_get_subconfigsdir(sConfigsDir, charsmax(sConfigsDir), "/SkyManager");
	new sFilePath[PATH_LENGTH + 32];
	formatex(sFilePath, charsmax(sFilePath), "%s/%s", sConfigsDir, INI_FILE_NAME);
	new const file = fopen(sFilePath, "rt");
	if(!file)
	{
		server_print("Failed to open the file ^"%s^"", sFilePath);
	}
	else
	{
		new sTemp[FILE_STRING_LENGTH], sMapName[MAP_STRLEN], sCurMap[MAP_STRLEN];
		get_mapname(sCurMap, charsmax(sCurMap));
		while(!feof(file))
		{
			fgets(file, sTemp, charsmax(sTemp));
			trim(sTemp);
			parse(sTemp, sMapName, charsmax(sMapName), sSkyNameOut, FILE_STRING_LENGTH);
			if(equali(sCurMap, sMapName))
			{
				parse_n_get_rand_skyname(sSkyNameOut, iLen_SkyNameOut);
				return true;
			}
		}
	}
	return false;
}

parse_n_get_rand_skyname(sSkyNameOut[], const iLen_SkyNameOut)
{
	new Array:aSkyList = ArrayCreate(SKY_STRLEN), sTemp[SKY_STRLEN];
	trim(sSkyNameOut);
	while(replace(sSkyNameOut, FILE_STRING_LENGTH, " ", "") != 0){}
	while(sSkyNameOut[0])
	{
		strtok(sSkyNameOut, sTemp, SKY_STRLEN, sSkyNameOut, FILE_STRING_LENGTH, ',');
		ArrayPushString(aSkyList, sTemp);
	}
	if(ArraySize(aSkyList) && sTemp[0])
	{
		ArrayGetString(aSkyList, random(ArraySize(aSkyList)), sSkyNameOut, iLen_SkyNameOut);
	}
	else
	{
		log_amx("Insufficient data. Please check the filling of the configuration file.");
	}
	ArrayDestroy(aSkyList);
}

PrecacheSkyName(skyname[])
{
	new const ENV_DATA[][] = {"bk", "dn", "ft", "lf", "rt", "up"};
	for(new i, File[SKY_STRLEN + 16]; i < sizeof(ENV_DATA); i++)
	{
		formatex(File, charsmax(File), "gfx/env/%s%s.tga", skyname, ENV_DATA[i]);
		if(file_exists(File)) 
		{
			precache_generic(File);
		}
		else
		{
			skyname[0] = 0;
			log_amx("File ^"%s^" not found", File);
			return;
		}
	}
}