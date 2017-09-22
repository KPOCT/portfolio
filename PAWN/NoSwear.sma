//#define MASKING // Закомментируйте, если не хотите использовать маску матов.

#include <amxmodx>
#include <gmf_directory>
#if defined MASKING
#else
	#include <printmsg>
#endif

#pragma semicolon 1

#define MSG_LENGTH 192 // Не ставить больше 192-х!!!

new const PLUGIN[] = "No Swear", VERSION[] = "1.15", AUTHOR[] = "KPOCT & AraHnID";
new const BLACK_LIST_FILE_NAME[] = "BlackList.txt";
new const WHITE_LIST_FILE_NAME[] = "WhiteList.txt";
#if defined MASKING
#else
	new const MSG_SWEAR_WAS_FOUND[] = "^4* ^1Ваше сообщение удалено цензурой."; // Текст сообщения, которое выведется, если найден мат. Не используется в режиме маскировки.
#endif
	const PATH_LENGTH = 96;

new g_sLogsDir[PATH_LENGTH], g_sConfigsDir[PATH_LENGTH];

public plugin_cfg()
{
	gmf_get_sublogsdir(g_sLogsDir, charsmax(g_sLogsDir), "/antimat");
	gmf_get_subconfigsdir(g_sConfigsDir, charsmax(g_sConfigsDir), "/antimat");
}

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
#if defined MASKING
	register_message(get_user_msgid("SayText"), "MessageSayText");
#else
	register_clcmd("say", "hook_say");
#endif
}

#if defined MASKING
	public MessageSayText(const iMsgID, const iSender, const iReceiver)
	{
		#pragma unused iMsgID
		if(is_user_bot(iSender))
		{
			return PLUGIN_CONTINUE;
		}
		new sMsg[MSG_LENGTH], sMsgTreated[MSG_LENGTH], sOriginalMsg[MSG_LENGTH], bool:bSwearFound;
		get_msg_arg_string(4, sOriginalMsg, charsmax(sOriginalMsg));
		sMsg = sOriginalMsg;
		remove_white_words(sMsg, sMsgTreated);
		if(mask_all_swear(sMsg, sMsgTreated))	bSwearFound = true;
		remove_unnecessary_chars(sMsgTreated);
		if(mask_all_swear(sMsg, sMsgTreated))	bSwearFound = true;
		set_msg_arg_string(4, sMsg);
		if(iSender == iReceiver && bSwearFound)
		{
			new sName[32], sSID[32], sIP[32];
			get_user_name(iSender, sName, charsmax(sName));
			get_user_authid(iSender, sSID, charsmax(sSID));
			get_user_ip(iSender, sIP, charsmax(sIP), 1);
			Logging(g_sLogsDir, "antimat_", "<%d> <%s> <%s> %s: %s", get_user_userid(iSender), sSID, sIP, sName, sOriginalMsg);
		}
		return PLUGIN_CONTINUE;
	}
#else
	public hook_say(id)
	{
		new sMsg[MSG_LENGTH], sMsgTreated[MSG_LENGTH];
		read_args(sMsg, charsmax(sMsg));
		remove_white_words(sMsg, sMsgTreated);
		if(swear_search(sMsgTreated))
		{
			new sName[32], sSID[32], sIP[32];
			get_user_name(id, sName, charsmax(sName));
			get_user_authid(id, sSID, charsmax(sSID));
			get_user_ip(id, sIP, charsmax(sIP), 1);
			PrintMsg(id, MSG_SWEAR_WAS_FOUND);
			Logging(g_sLogsDir, "antimat_", "<%d> <%s> <%s> %s: %s", get_user_userid(id), sSID, sIP, sName, sMsg);
			return PLUGIN_HANDLED_MAIN;
		}
		remove_unnecessary_chars(sMsgTreated);
		if(swear_search(sMsgTreated))
		{
			new sName[32], sSID[32], sIP[32];
			get_user_name(id, sName, charsmax(sName));
			get_user_authid(id, sSID, charsmax(sSID));
			get_user_ip(id, sIP, charsmax(sIP), 1);
			PrintMsg(id, MSG_SWEAR_WAS_FOUND);
			Logging(g_sLogsDir, "antimat_", "<%d> <%s> <%s> %s: %s", get_user_userid(id), sSID, sIP, sName, sMsg);
			return PLUGIN_HANDLED_MAIN;
		}
		return PLUGIN_CONTINUE;
	}
#endif

public remove_white_words(const sMsg[MSG_LENGTH], sMsgTreated[MSG_LENGTH])
{
	sMsgTreated = sMsg;
	new sFilePath[PATH_LENGTH + 32];
	formatex(sFilePath, charsmax(sFilePath), "%s/%s", g_sConfigsDir, WHITE_LIST_FILE_NAME);
	new const file = fopen(sFilePath, "a+");
	if(!file)
	{
		server_print("Failed to open the file ^"%s^"", sFilePath);
	}
	else
	{
		strtolower(sMsgTreated);
		strtolower_rus(sMsgTreated);
		new sWhiteWord[MSG_LENGTH], iLenMsg = charsmax(sMsgTreated);
		while(!feof(file))
		{
			fgets(file, sWhiteWord, charsmax(sWhiteWord));
			trim(sWhiteWord);
			strtolower(sWhiteWord);
			strtolower_rus(sWhiteWord);
			if(sWhiteWord[0] == '^0' || strlen(sMsgTreated) < strlen(sWhiteWord))
			{
				continue;
			}
			new sArr4ReplaceWhiteWord[MSG_LENGTH];
			for(new i; i < strlen(sWhiteWord); i++)
			{
				copy(sArr4ReplaceWhiteWord[i], charsmax(sArr4ReplaceWhiteWord), "1");
			}
			while(replace(sMsgTreated, iLenMsg, sWhiteWord, sArr4ReplaceWhiteWord) != 0){}
		}
	}
}

public remove_unnecessary_chars(sMsg[MSG_LENGTH])
{
	new const iMaxLength = charsmax(sMsg);
	new const sUnnecessaryChars[][] = { ".", "!", "@", "#", "$", "%", "^^", "&", "*", "(", ")", "-", "_", "+", "=", "`", "'", "~", "№", ";", ":", "?", ",", "/", "|", "<", ">", "[", "]", "{", "}", " ", "\", "^"" };
	for(new i; i <= charsmax(sUnnecessaryChars); i++)
	{
		while(replace(sMsg, iMaxLength, sUnnecessaryChars[i], "") != 0){}
	}
}

#if defined MASKING
	public mask_all_swear(sMsg[MSG_LENGTH], sMsgTreated[MSG_LENGTH])
	{
		new sFilePath[PATH_LENGTH + 32];
		formatex(sFilePath, charsmax(sFilePath), "%s/%s", g_sConfigsDir, BLACK_LIST_FILE_NAME);
		new const file = fopen(sFilePath, "a+");
		if(!file)
		{
			server_print("Failed to open the file ^"%s^"", sFilePath);
		}
		else
		{
			new sBlackWord[MSG_LENGTH], bool:bSwearMasked;
			while(!feof(file))
			{
				fgets(file, sBlackWord, charsmax(sBlackWord));
				trim(sBlackWord);
				strtolower(sBlackWord);
				strtolower_rus(sBlackWord);
				if(sBlackWord[0] == '^0' || strlen(sMsgTreated) < strlen(sBlackWord))
				{
					continue;
				}
				for(new iPosA_MsgTreated = contain_fixed(sMsgTreated, sBlackWord); iPosA_MsgTreated >= 0; iPosA_MsgTreated = contain_fixed(sMsgTreated, sBlackWord))
				{
					bSwearMasked = true;
					new const iPosB_MsgTreated = iPosA_MsgTreated + strlen(sBlackWord)-1;
					new const sA = sBlackWord[0];
					new const sB = sBlackWord[is_rus_char(sBlackWord[strlen(sBlackWord)-2]) ? strlen(sBlackWord)-2 : strlen(sBlackWord)-1];
					new iCountA_MsgTreated, iCountB_MsgTreated;
					for(new i; i <= iPosA_MsgTreated; i++)
					{
						if(sMsgTreated[i] == sA)
						{
							iCountA_MsgTreated++;
						}
					}
					for(new i; i <= iPosB_MsgTreated; i++)
					{
						if(sMsgTreated[i] == sB)
						{
							iCountB_MsgTreated++;
						}
					}
					new sArr4ReplaceBlackWord[MSG_LENGTH];
					for(new i; i < strlen(sBlackWord); i++)
					{
						copy(sArr4ReplaceBlackWord[i], charsmax(sArr4ReplaceBlackWord), "0");
					}
					replace(sMsgTreated, charsmax(sMsgTreated), sBlackWord, sArr4ReplaceBlackWord);
					new iPosA_Msg, iPosB_Msg;
					for(new i, iCountA_Msg; i < strlen(sMsg); i++)
					{
						if(sMsg[i] == sA)
						{
							iCountA_Msg++;
							if(iCountA_Msg == iCountA_MsgTreated)
							{
								iPosA_Msg = i;
								break;
							}
						}
					}
					for(new i, iCountB_Msg; i < strlen(sMsg); i++)
					{
						if(sMsg[i] == sB)
						{
							iCountB_Msg++;
							if(iCountB_Msg == iCountB_MsgTreated)
							{
								iPosB_Msg = i;
								break;
							}
						}
					}
					for(new i = iPosA_Msg; i <= iPosB_Msg; i++)
					{
						if(is_rus_char(sMsg[i]))
						{
							for(new j = i; j < strlen(sMsg)-1; j++)
							{
								sMsg[j] = sMsg[j+1];
								if(j + 1 == strlen(sMsg)-1)
								{
									sMsg[j+1] = '^0';
								}
							}
							sMsg[i] = '*';
							iPosB_Msg--;
						}
						else
						{
							sMsg[i] = '*';
						}
					}
				}
			}
			fclose(file);
			if(bSwearMasked)
			{
				return true;
			}
		}
		return false;
	}
#else
	public bool:swear_search(sMsgTreated[MSG_LENGTH])
	{
		new sFilePath[PATH_LENGTH + 32];
		formatex(sFilePath, charsmax(sFilePath), "%s/%s", g_sConfigsDir, BLACK_LIST_FILE_NAME);
		new const file = fopen(sFilePath, "a+");
		if(!file)
		{
			server_print("Failed to open the file ^"%s^"", sFilePath);
			return false;
		}
		else
		{
			new sBlackWord[MSG_LENGTH];
			while(!feof(file))
			{
				fgets(file, sBlackWord, charsmax(sBlackWord));
				trim(sBlackWord);
				strtolower(sBlackWord);
				strtolower_rus(sBlackWord);
				if(sBlackWord[0] == '^0' || strlen(sMsgTreated) < strlen(sBlackWord))
				{
					continue;
				}
				if(contain_fixed(sMsgTreated, sBlackWord) >= 0)
				{
					return true;
				}
			}
		}
		return false;
	}
#endif

#if defined MASKING
	public is_rus_char(sMsg[])
	{
		if(strlen(sMsg) > 1)
		{
			new const	ch1 = (sMsg[0] & 0xFF),
						ch2 = (sMsg[1] & 0xFF);
			if((ch1 == 0xD0 && ch2 >= 0x90 && ch2 <= 0xBF) || (ch1 == 0xD1 && ch2 >= 0x80 && ch2 <= 0x8F) || (ch1 == 0xD0 && ch2 == 0x81) || (ch1 == 0xD1 && ch2 == 0x91))
			{
				return true;
			}
		}
		return false;
	}

	public replace_fixed(sMsg[MSG_LENGTH], const sWhat[], const sWith[])
	{
		for(new i, sWordInMsg[MSG_LENGTH]; i < strlen(sMsg); i++)
		{
			if(i > strlen(sMsg) - strlen(sWhat))
			{
				break;
			}
			formatex(sWordInMsg, strlen(sWhat), sMsg[i]);
			if(!strcmp(sWordInMsg, sWhat))
			{
				formatex(sMsg[i], strlen(sMsg), sWith);
			}
		}
	}
#endif

public strtolower_rus(sMsg[MSG_LENGTH])
{
	for(new i, ch1, ch2; i < strlen(sMsg)-1; i++)
	{
		ch1 = sMsg[i] & 0xFF;
		ch2 = sMsg[i+1] & 0xFF;
		if(ch1 == 0xD0 && ch2 >= 0x90 && ch2 <= 0x9F)
		{
			sMsg[i+1] = ch2 + 0x20;
		}
		else if(ch1 == 0xD0 && ch2 >= 0xA0 && ch2 <= 0xAF)
		{
			sMsg[i] = 0xD1;
			sMsg[i+1] = ch2 - 0x20;
		}
		else if(ch1 == 0xD0 && ch2 == 0x81)
		{
			sMsg[i] = 0xD1;
			sMsg[i+1] = 0x91;
		}
	}
}

public contain_fixed(const sMsg[MSG_LENGTH], const sWord[MSG_LENGTH])
{
	for(new i, sWordInMsg[MSG_LENGTH]; i < strlen(sMsg); i++) // i - для прохода по sMsg; sWordInMsg - массив, в который будет записываться слово из sMsg.
	{
		if(i > strlen(sMsg) - strlen(sWord)) // Если кол-во символом после i меньше, чем длина искомого слова, то дальнейшие действия бессмысленны. Здесь мы это проверяем и выходим из цикла, затем последует выход из функции. 
		{
			break;
		}
		formatex(sWordInMsg, strlen(sWord), sMsg[i]); // Записываем в sWordInMsg слово из sMsg, которое начинается с позиции i и заканчивается позицией (i + <длина_искомого_слова>)
		if(!strcmp(sWordInMsg, sWord)) // Здесь сравниваем полученное ^ здесь ^ слово с искомым словом. Если они равны, то возвращаем позицию начала этого слова.
		{
			return i;
		}
	}
	return -1;
}

Logging(const LogsDir[], const FileName[] = "", const Message[], any:...)
{
	new Msg[512], Time[32], File[PATH_LENGTH + 32], pFile;
	vformat(Msg, charsmax(Msg), Message, 4);
	get_time("%d-%m-%y.log", Time, charsmax(Time));
	formatex(File, charsmax(File), "%s/%s%s", LogsDir, FileName, Time);
	pFile = fopen(File, "at");
	get_time("%Y/%m/%d - %H:%M:%S", Time, charsmax(Time));
	fprintf(pFile, "%s: %s^n", Time, Msg);
	fclose(pFile);
}