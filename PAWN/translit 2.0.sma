/**************************************************
* Translit by Game Force CS // 13.08.2017
* Задействован код: Chat Manager
* Благодарность: Mistrick, Subb98, KPOCT
* Отдельная благодарность проекту: Dev-CS.Ru
**************************************************/
#include <amxmodx>
#include <regex>
#include <reapi>

#pragma semicolon 1

new const g_cTableConvert[][] = {
	"Э", "#", ";", "%", "?", "э", "(", ")", "*", "+", "б", "-", "ю", ".", "0", "1", "2", "3", "4",
	"5", "6", "7", "8", "9", "Ж", "ж", "Б", "=", "Ю", ",", "^"", "Ф", "И", "С", "В", "У", "А", "П",
	"Р", "Ш", "О", "Л", "Д", "Ь", "Т", "Щ", "З", "Й", "К", "Ы", "Е", "Г", "М", "Ц", "Ч", "Н", "Я",
	"х", "\", "ъ", ":", "_", "ё", "ф", "и", "с", "в", "у", "а", "п", "р", "ш", "о", "л", "д", "ь",
	"т", "щ", "з", "й", "к", "ы", "е", "г", "м", "ц", "ч", "н", "я", "Х", "/", "Ъ", "Ё"
};

new const g_sWhiteListIP[][] = {
	"37.230.210.128"
};

new const g_sWhiteListDomain[][] = {
	"vk.com/gmforce",
};

const ADMIN_FLAG = ADMIN_BAN;
const MAX_MESSAGE_STRLEN = 512;
const AUTHID_STRLEN = 24;
const PREFIX_STRLEN = 32;
const ACTIVE_PREFIX_STRLEN = 6;
const PLAYER_NAME_STRLEN = 32;
const WORDS_STRLEN = 32;
const PATH_STRLEN = 64;
const DP_AUTH_STEAM = 2;
const ERROR_STRLEN = 2;

enum _:PREFIXES_DATA_SIZE {
	pds_sPlayerSID[AUTHID_STRLEN],
	pds_sPlayerPrefix[PREFIX_STRLEN + 1],
	pds_sActivePrefix[ACTIVE_PREFIX_STRLEN]
}

new g_pProvider;
new g_sDataDir[PATH_STRLEN];
new g_sLogsDir[PATH_STRLEN];
new g_sPrefixesFile[PATH_STRLEN + 32];
new g_sBlackWordsFile[PATH_STRLEN + 32];
new g_sWhiteWordsFile[PATH_STRLEN + 32];
new g_aPrefixesTemp[PREFIXES_DATA_SIZE];
new g_sPlayerPrefix[MAX_PLAYERS + 1][PREFIX_STRLEN + 1];

new bool:g_bIsUseRus[MAX_PLAYERS + 1];
new bool:g_bIsSteam[MAX_PLAYERS + 1];
new bool:g_bIsAdminFlag[MAX_PLAYERS + 1];

new Regex:g_rIPPattern;
new Regex:g_rDomainPattern;

new Array:g_aPrefixes;
new Array:g_aBlackWords;
new Array:g_aWhiteWords;

public plugin_init() {
	register_plugin("Translit", "2.0", "Javekson");
	register_clcmd("say /rus", "ClCmdLangRus");
	register_clcmd("say /eng", "ClCmdLangEng");
	register_clcmd("say", "ClCmdSay");
	register_clcmd("say_team", "ClCmdSayTeam");
	g_pProvider = get_cvar_pointer("dp_r_id_provider");
}

public plugin_cfg() {
	g_aPrefixes = ArrayCreate(PREFIXES_DATA_SIZE);
	g_aBlackWords = ArrayCreate(WORDS_STRLEN);
	g_aWhiteWords = ArrayCreate(WORDS_STRLEN);
	
	new sError[ERROR_STRLEN], iRegexReturn;
	g_rIPPattern = regex_compile("(?:\s*\d+\s*\.){3}", iRegexReturn, sError, charsmax(sError));
	g_rDomainPattern = regex_compile("(?:\w{2,}\s*\.\s*(su|ru|by|kz|ua|eu|bg|de|fr|lt|lv|me|pl|ro|us|ws|com|net|org|biz|name|info)\b)", iRegexReturn, sError, charsmax(sError));
	
	get_localinfo("amxx_logs", g_sLogsDir, charsmax(g_sLogsDir));
	add(g_sLogsDir, charsmax(g_sLogsDir), "/translit");
	if(!dir_exists(g_sLogsDir)) mkdir(g_sLogsDir);
	
	get_localinfo("amxx_datadir", g_sDataDir, charsmax(g_sDataDir));
	add(g_sDataDir, charsmax(g_sDataDir), "/translit");
	if(!dir_exists(g_sDataDir)) mkdir(g_sDataDir);
	
	formatex(g_sPrefixesFile, charsmax(g_sPrefixesFile), "%s/prefixes.dat", g_sDataDir);
	formatex(g_sBlackWordsFile, charsmax(g_sBlackWordsFile), "%s/black_words.dat", g_sDataDir);
	formatex(g_sWhiteWordsFile, charsmax(g_sWhiteWordsFile), "%s/white_words.dat", g_sDataDir);
	ReadPrefixesFile(); ReadBlackWordsFile(); ReadWhiteWordsFile();
}

ReadPrefixesFile() {
	new iFileID;
	if((iFileID = fopen(g_sPrefixesFile, "rt"))) {
		new sText[AUTHID_STRLEN + PREFIX_STRLEN + ACTIVE_PREFIX_STRLEN + 10], sPlayerSID[AUTHID_STRLEN], sPlayerPrefix[PREFIX_STRLEN + 1], sActivePrefix[ACTIVE_PREFIX_STRLEN];
		while(!feof(iFileID)) {
			fgets(iFileID, sText, charsmax(sText)); trim(sText);
			if(!sText[0] || sText[0] == ';') continue;
			parse(sText, sPlayerSID, charsmax(sPlayerSID), sPlayerPrefix, charsmax(sPlayerPrefix), sActivePrefix, charsmax(sActivePrefix));
			if(sActivePrefix[0] == 'f') continue;
			
			g_aPrefixesTemp[pds_sPlayerSID] = sPlayerSID;
			g_aPrefixesTemp[pds_sPlayerPrefix] = sPlayerPrefix;
			ArrayPushArray(g_aPrefixes, g_aPrefixesTemp);
		}
		fclose(iFileID);
	}
}

ReadBlackWordsFile() {
	new iFileID;
	if((iFileID = fopen(g_sBlackWordsFile, "rt"))) {
		new sText[WORDS_STRLEN];
		while(!feof(iFileID)) {
			fgets(iFileID, sText, charsmax(sText)); trim(sText);
			if(!sText[0] || sText[0] == ';') continue;
			ArrayPushString(g_aBlackWords, sText);
		}
		fclose(iFileID);
	}
}

ReadWhiteWordsFile() {
	new iFileID;
	if((iFileID = fopen(g_sWhiteWordsFile, "rt"))) {
		new sText[WORDS_STRLEN];
		while(!feof(iFileID)) {
			fgets(iFileID, sText, charsmax(sText)); trim(sText);
			if(!sText[0] || sText[0] == ';') continue;
			ArrayPushString(g_aWhiteWords, sText);
		}
		fclose(iFileID);
	}
}

public client_putinserver(id) {
	g_bIsAdminFlag[id] = get_user_flags(id) & ADMIN_FLAG ? true : false;
	g_bIsSteam[id] = is_player_steam(id);
	g_bIsUseRus[id] = false;
	
	new sPlayerSID[AUTHID_STRLEN];
	get_user_authid(id, sPlayerSID, charsmax(sPlayerSID));
	
	g_sPlayerPrefix[id] = "";
	for(new i, iPrefixesSize = ArraySize(g_aPrefixes); i < iPrefixesSize; i++) {
		ArrayGetArray(g_aPrefixes, i, g_aPrefixesTemp);
		if(equal(g_aPrefixesTemp[pds_sPlayerSID], sPlayerSID)) {
			copy(g_sPlayerPrefix[id], charsmax(g_sPlayerPrefix[]), g_aPrefixesTemp[pds_sPlayerPrefix]);
			break;
		}
	}
}

public ClCmdSay(const id) {
	return ConvertingMessage(id, .bIsTeamMsg = false);
}

public ClCmdSayTeam(const id) {
	return ConvertingMessage(id, .bIsTeamMsg = true);
}

public ClCmdLangRus(const id) {
	g_bIsUseRus[id] = true; return Language(id);
}

public ClCmdLangEng(const id) {
	g_bIsUseRus[id] = false; return Language(id);
}

public Language(const id) {
	if(g_bIsSteam[id]) {
		rg_send_audio(id, "events/friend_died.wav");
		client_print_color(id, print_team_default, "^4* ^1[^4GMF^1] Данная команда недоступна для Steam-клиентов");
		return PLUGIN_HANDLED;
	}
	if(g_bIsUseRus[id]) 
		client_print_color(id, print_team_default, "^4* ^1[^4GMF^1] Язык чата изменён на русский");
	else 
		client_print_color(id, print_team_default, "^4* ^1[^4GMF^1] Язык чата изменён на английский");
	
	rg_send_audio(id, "events/tutor_msg.wav");
	return PLUGIN_HANDLED;
}

ConvertingMessage(const id, const bool:bIsTeamMsg) {
	new sMessage[MAX_MESSAGE_STRLEN];
	read_args(sMessage, charsmax(sMessage));
	remove_quotes(sMessage); trim(sMessage);
	
	if(sMessage[0] == EOS || sMessage[0] == '/')
		return PLUGIN_HANDLED;
	
	new sConverting[MAX_MESSAGE_STRLEN];
	if(!g_bIsSteam[id] && g_bIsUseRus[id]) {
		for(new i, j; sMessage[i] != EOS; i++) {
			new ch = sMessage[i];
			if('"' <= ch <= '~') {
				ch -= '"';
				sConverting[j++] = g_cTableConvert[ch][0];
				if(g_cTableConvert[ch][1] != EOS)
					sConverting[j++] = g_cTableConvert[ch][1];
			}
			else sConverting[j++] = ch;
		}
	} else sConverting = sMessage;
	
	new sPlayerName[PLAYER_NAME_STRLEN], sPlayerSID[AUTHID_STRLEN];
	get_user_name(id, sPlayerName, charsmax(sPlayerName));
	get_user_authid(id, sPlayerSID, charsmax(sPlayerSID));
	
	new iRegexReturn, sConvertingTemp[MAX_MESSAGE_STRLEN];
	if(regex_match_c(sConverting, g_rIPPattern, iRegexReturn)) {
		copy(sConvertingTemp, charsmax(sConvertingTemp), sConverting);
		for(new i, iWhiteListIPSize = sizeof g_sWhiteListIP; i < iWhiteListIPSize; i++)
			while(replace(sConvertingTemp, charsmax(sConvertingTemp), g_sWhiteListIP[i], "")){}
		
		if(regex_match_c(sConvertingTemp, g_rIPPattern, iRegexReturn))
			return blocking_advertising(id);
	}
	if(regex_match_c(sConverting, g_rDomainPattern, iRegexReturn)) {
		copy(sConvertingTemp, charsmax(sConvertingTemp), sConverting);
		for(new i, iWhiteListDomainSize = sizeof g_sWhiteListDomain; i < iWhiteListDomainSize; i++)
			while(replace(sConvertingTemp, charsmax(sConvertingTemp), g_sWhiteListDomain[i], "")){}
		
		if(regex_match_c(sConvertingTemp, g_rDomainPattern, iRegexReturn))
			return blocking_advertising(id);
	}
	
	new sMsgTreated[MAX_MESSAGE_STRLEN]; 
	copy(sMsgTreated, charsmax(sMsgTreated), sConverting);
	strtolower(sMsgTreated); 
	strtolower_rus(sMsgTreated);
	
	remove_white_words(sMsgTreated);
	if(swear_search(sMsgTreated))
		return blocking_swearing(id, sConverting, sPlayerName, sPlayerSID);
		
	remove_unnecessary_chars(sMsgTreated);
	if(swear_search(sMsgTreated))
		return blocking_swearing(id, sConverting, sPlayerName, sPlayerSID);
	
	new sPlayerPrefix[PREFIX_STRLEN + 7];
	if(g_sPlayerPrefix[id][0])
		formatex(sPlayerPrefix, charsmax(sPlayerPrefix), "^1[^4%s^1] ", g_sPlayerPrefix[id]);
	
	if(sMessage[0] == '@' && g_bIsAdminFlag[id]) {
		copy(sConverting, charsmax(sConverting), sConverting[1]);
		trim(sConverting); if(sConverting[0] == EOS) return PLUGIN_HANDLED;
		formatex(sMessage, charsmax(sMessage), "^1(Админ) %s^3%s^1 : %s", sPlayerPrefix, sPlayerName, sConverting);
		
		new iPlayersID[MAX_PLAYERS], iPlayersNum;
		get_players(iPlayersID, iPlayersNum, "ch");
		for(new i; i < iPlayersNum; i++) {
			if(g_bIsAdminFlag[iPlayersID[i]])
				client_print_color(iPlayersID[i], print_team_default, sMessage);
		}
		Logging(g_sLogsDir, "translit_", "^"%s^" ^"(Админ) %s : %s^"", sPlayerSID, sPlayerName, sConverting);
		return PLUGIN_HANDLED;
	}
	if(bIsTeamMsg) {
		formatex(sMessage, charsmax(sMessage), "^1(Команда) %s^3%s^1 : %s", sPlayerPrefix, sPlayerName, sConverting);
		new iPlayersID[MAX_PLAYERS], iPlayersNum;
		get_players(iPlayersID, iPlayersNum, "ch");
		for(new i; i < iPlayersNum; i++) {
			if(get_member(id, m_iTeam) == get_member(iPlayersID[i], m_iTeam))
				client_print_color(iPlayersID[i], print_team_default, sMessage);
		}
		Logging(g_sLogsDir, "translit_", "^"%s^" ^"(Команда) %s : %s^"", sPlayerSID, sPlayerName, sConverting);
		return PLUGIN_HANDLED;
	}
	
	formatex(sMessage, charsmax(sMessage), "%s^3%s^1 : %s", sPlayerPrefix, sPlayerName, sConverting);
	client_print_color(0, print_team_default, sMessage);
	Logging(g_sLogsDir, "translit_", "^"%s^" ^"%s : %s^"", sPlayerSID, sPlayerName, sConverting);
	return PLUGIN_HANDLED;
}

stock bool:is_player_steam(const id) {
	if(g_pProvider) {
		server_cmd("dp_clientinfo %d", id);
		server_exec();
		return get_pcvar_num(g_pProvider) == DP_AUTH_STEAM ? true : false;
	}
	return false;
}

stock remove_white_words(sMsgTreated[]) {
	new sWhiteWord[WORDS_STRLEN], iLenMsg = strlen(sMsgTreated);
	for(new i, iWhiteWordsSize = ArraySize(g_aWhiteWords); i < iWhiteWordsSize; i++) {
		ArrayGetString(g_aWhiteWords, i, sWhiteWord, charsmax(sWhiteWord));
		
		strtolower(sWhiteWord);
		strtolower_rus(sWhiteWord);
		
		new sArr4ReplaceWhiteWord[WORDS_STRLEN];
		for(new i; i < strlen(sWhiteWord); i++)
			copy(sArr4ReplaceWhiteWord[i], charsmax(sArr4ReplaceWhiteWord), "1");
		
		while(replace(sMsgTreated, iLenMsg, sWhiteWord, sArr4ReplaceWhiteWord) != 0){}
	}
}

stock remove_unnecessary_chars(sMsgTreated[]) {
	new iLenMsg = strlen(sMsgTreated);
	new sUnnecessaryChars[][] = { ".", "!", "@", "#", "$", "%", "^^", "&", "*", "(", ")", "-", "_", "+", "=", "`", "'", "~", "№", ";", ":", "?", ",", "/", "|", "<", ">", "[", "]", "{", "}", " ", "\", "^"" };
	for(new i, iUnnecessarySize = charsmax(sUnnecessaryChars); i <= iUnnecessarySize; i++) {
		while(replace(sMsgTreated, iLenMsg, sUnnecessaryChars[i], "") != 0) {}
	}
}

stock bool:swear_search(sMsgTreated[]) {
	new sBlackWord[WORDS_STRLEN];
	for(new i, iBlackWordsSize = ArraySize(g_aBlackWords); i < iBlackWordsSize; i++) {
		ArrayGetString(g_aBlackWords, i, sBlackWord, charsmax(sBlackWord));
		
		strtolower(sBlackWord);
		strtolower_rus(sBlackWord);
		
		if(contain_fixed(sMsgTreated, sBlackWord) >= 0) return true;
	}
	return false;
}

stock strtolower_rus(sWord[]) {
	for(new i, ch1, ch2; i < strlen(sWord) - 1; i++) {
		ch1 = sWord[i] & 0xFF;
		ch2 = sWord[i + 1] & 0xFF;
		if(ch1 == 0xD0 && ch2 >= 0x90 && ch2 <= 0x9F) {
			sWord[i+1] = ch2 + 0x20;
		} else if(ch1 == 0xD0 && ch2 >= 0xA0 && ch2 <= 0xAF) {
			sWord[i] = 0xD1;
			sWord[i + 1] = ch2 - 0x20;
		} else if(ch1 == 0xD0 && ch2 == 0x81) {
			sWord[i] = 0xD1;
			sWord[i + 1] = 0x91;
		}
	}
}

stock contain_fixed(const sMsgTreated[], const sBlackWord[]) {
	for(new i, sWordInMsg[WORDS_STRLEN]; i < strlen(sMsgTreated); i++) {
		if(i > strlen(sMsgTreated) - strlen(sBlackWord)) break;
		formatex(sWordInMsg, strlen(sBlackWord), sMsgTreated[i]); 
		if(!strcmp(sWordInMsg, sBlackWord)) return i;
	}
	return -1;
}

stock blocking_swearing(const id, const sConverting[], const sPlayerName[], const sPlayerSID[]) {
	rg_send_audio(id, "events/friend_died.wav");
	client_print_color(id, print_team_default, "^4* ^1[^4GMF^1] Запрещено использования нецензурных сообщений");
	Logging(g_sLogsDir, "antimat_", "^"%s^" ^"%s : %s^"", sPlayerSID, sPlayerName, sConverting);
	return PLUGIN_HANDLED;
}

stock blocking_advertising(const id) {
	rg_send_audio(id, "events/friend_died.wav");
	client_print_color(id, print_team_default, "^4* ^1[^4GMF^1] Реклама на сервере запрещена");
	return PLUGIN_HANDLED;
}

stock Logging(const sLogsDir[], const sFileName[] = "", const sMessage[], any:...) {
	new sMsg[512], sTime[32], sLogFile[PATH_STRLEN + 32], iFileID;
	vformat(sMsg, charsmax(sMsg), sMessage, 4);
	get_time("%d%m%Y.log", sTime, charsmax(sTime));
	formatex(sLogFile, charsmax(sLogFile), "%s/%s%s", sLogsDir, sFileName, sTime);
	iFileID = fopen(sLogFile, "at");
	get_time("%d/%m/%Y - %H:%M:%S", sTime, charsmax(sTime));
	fprintf(iFileID, "^"%s:^" %s^n", sTime, sMsg);
	fclose(iFileID);
}