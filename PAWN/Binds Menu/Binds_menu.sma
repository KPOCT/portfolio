/*** Не забыть: показ меню в удобное время без перекрытия уже открытого меню, нестандартные кнопки (ввод кнопки пользователем) ***/
#include < amxmodx >

#if !defined MAX_PLAYERS
	const MAX_PLAYERS = 32;

new const PLUGIN = "Binds menu";
new const AUTHOR = "KP0CT";
new const VERSION = "1.2";
new const NOT_SHOW_PATH = "addons/amxmodx/configs/Binds_not_show.ini";
new const FILE_OF_COMMANDS_PATH = "addons/amxmodx/configs/Binds_Commands.ini";
new const FILE_OF_KEYS_PATH = "addons/amxmodx/configs/Binds_Keys.ini";

const SVC_DIRECTOR_ID = 51;
const SVC_DIRECTOR_STUFFTEXT_ID = 10;

new sCmdsAndKeys[ MAX_PLAYERS + 1 ][ 2 ][ 64 ], mCmds, mKeys;

public plugin_init( )
{
   register_plugin( PLUGIN, VERSION, AUTHOR );
   register_clcmd( "binds", "Binds_menu" );
   register_clcmd( "say /binds", "Binds_menu" );
}

public plugin_cfg( )
{
   /// Подгружаем файл с командами и создаём меню.
   mCmds = menu_create( "^t\y[\rBinds menu\y] ^n^t\yВыберите команду:", "mhCmds" );
   new file = fopen( FILE_OF_COMMANDS_PATH, "rt" );
   if( !file )
   {
      server_print( "Failed to open the file ^"%s^"", FILE_OF_COMMANDS_PATH );
      menu_setprop( mCmds, MPROP_TITLE, "^t\y[\rBinds menu\y] ^n^t\rНет доступных команд." );
      menu_additem( mCmds, "\wВыйти", "exist" );
      menu_setprop( mCmds, MPROP_EXIT, MEXIT_NEVER );
   }
   else
   {
      new sBuffer[ 128 ], sCmd[ 64 ], sItemName[ 64 ];
      while( !feof( file ) )
      {
         fgets( file, sBuffer, charsmax( sBuffer ) );
         parse( sBuffer, sCmd, charsmax( sCmd ), sItemName, charsmax( sItemName ) );
         if( sCmd[ 0 ] == '/' && sCmd[ 1 ] == '/' || sCmd[ 0 ] == ' ' || sCmd[ 0 ] == '\' )
         {
            continue;
         }
         if( !sCmd[ 0 ] )
         {
            if( !sItemName[ 0 ] )
            {
               menu_addblank( mCmds, 0 );
               continue;
            }
            if( menu_items( mCmds ) )
            {
               menu_addtext( mCmds, sItemName, 0 );
            }
            continue;
         }
         if( !sItemName[ 0 ] )
         {
            sItemName = sCmd;
            if( sItemName[ 0 ] == '+' )
            {
               replace( sItemName, 1, "+", "" );
            }
         }
         menu_additem( mCmds, sItemName, sCmd );
      }
      if( !menu_items( mCmds ) )
      {
         menu_setprop( mCmds, MPROP_TITLE, "^t\y[\rBinds menu\y] ^n^t\rНет доступных команд." );
         menu_additem( mCmds, "\wВыйти", "exist" );
         menu_setprop( mCmds, MPROP_EXIT, MEXIT_NEVER );
      }
      if( menu_pages( mCmds ) > 1 )
      {
         menu_setprop( mCmds, MPROP_TITLE, "^t\y[\rBinds menu\y] ^n^t\yВыберите команду:^n^t\dСтраница:" );
      }
      menu_setprop( mCmds, MPROP_EXIT, MEXIT_ALL );
      menu_setprop( mCmds, MPROP_BACKNAME, "\wНазад" );
      menu_setprop( mCmds, MPROP_NEXTNAME, "\wВперёд" );
      menu_setprop( mCmds, MPROP_EXITNAME, "\wВыход" );
      fclose( file );
   }
   /// Подгружаем файл с клавишами и создаём меню.
   mKeys = menu_create( "^t\y[\rBinds menu\y] ^n^t\yВыберите клавишу:", "mhKeys" );
   file = fopen( FILE_OF_KEYS_PATH, "rt" );
   if( !file )
   {
      server_print( "Failed to open the file ^"%s^"", FILE_OF_KEYS_PATH );
      menu_setprop( mKeys, MPROP_TITLE, "^t\y[\rBinds menu\y] ^n^t\rНет доступных клавиш." );
      menu_additem( mKeys, "\wВыйти", "exist" );
      menu_setprop( mKeys, MPROP_EXIT, MEXIT_NEVER );
   }
   else
   {
      new sBuffer[ 128 ], sKey[ 64 ], sItemName[ 64 ];
      while( !feof( file ) )
      {
         fgets( file, sBuffer, charsmax( sBuffer ) );
         parse( sBuffer, sKey, charsmax( sKey ), sItemName, charsmax( sItemName ) );
         if( sKey[ 0 ] == '/' && sKey[ 1 ] == '/' || sKey[ 0 ] == ' ' || sKey[ 0 ] == '\' )
         {
            continue;
         }
         if( !sKey[ 0 ] )
         {
            if( !sItemName[ 0 ] )
            {
               menu_addblank( mKeys, 0 );
               continue;
            }
            if( menu_items( mKeys ) )
            {
               menu_addtext( mKeys, sItemName, 0 );
            }
            continue;
         }
         if( !sItemName[ 0 ] )
         {
            sItemName = sKey;
            if(sItemName[0] == '+')
            {
               replace( sItemName, 1, "+", "" );
            }
         }
         menu_additem( mKeys, sItemName, sKey );
      }
      if( !menu_items( mKeys ) )
      {
         menu_setprop( mKeys, MPROP_TITLE, "^t\y[\rBinds menu\y] ^n^t\rНет доступных клавиш." );
         menu_additem( mKeys, "\wВыйти", "exist" );
         menu_setprop( mKeys, MPROP_EXIT, MEXIT_NEVER );
      }
      if( menu_pages( mKeys ) > 1 )
      {
         menu_setprop( mKeys, MPROP_TITLE, "^t\y[\rBinds menu\y] ^n^t\yВыберите клавишу:^n^t\dСтраница:" );
      }
      menu_setprop( mKeys, MPROP_EXIT, MEXIT_ALL );
      menu_setprop( mKeys, MPROP_BACKNAME, "\wНазад" );
      menu_setprop( mKeys, MPROP_NEXTNAME, "\wВперёд" );
      menu_setprop( mKeys, MPROP_EXITNAME, "\wВыход" );
      fclose( file );
   }
}

public mhCmds( id, mCmds, iItem )
{
   new iAccess, sBuffer[ 64 ], sName[ 64 ], iCallback;
   menu_item_getinfo( mCmds, iItem, iAccess, sBuffer, charsmax( sBuffer ), sName, charsmax( sName ), iCallback );
   if( !strcmp( sBuffer, "exist" ) || iItem == MENU_EXIT )
   {
      return;
   }
   sCmdsAndKeys[ id ][ 0 ] = sBuffer;
   menu_display( id, mKeys, 0 );
}

public mhKeys( id, mKeys, iItem )
{
   new iAccess, sBuffer[ 64 ], sName[ 64 ], iCallback;
   menu_item_getinfo( mKeys, iItem, iAccess, sBuffer, charsmax( sBuffer ), sName, charsmax( sName ), iCallback );
   if( !strcmp( sBuffer, "exist" ) || iItem == MENU_EXIT )
   {
      return;
   }
   sCmdsAndKeys[ id ][ 1 ] = sBuffer;
   if( strlen( sCmdsAndKeys[ id ][ 1 ] ) && strlen( sCmdsAndKeys[ id ][ 0 ] ) )
   {
      new sBind[ 150 ];
      format( sBind, charsmax( sBind ) - 1, "bind ^3^"^4%s^3^" ^"^4%s^3^"", sCmdsAndKeys[ id ][ 1 ], sCmdsAndKeys[ id ][ 0 ] );
      ChatColor( id, "^1[^4Binds menu^1] ^3В вашу консоль отправлена команда ^4%s.", sBind );
      replace_all( sBind, charsmax( sBind ), "^3", "" );
      replace_all( sBind, charsmax( sBind ), "^4", "" );
      STUFFTEXT_CMD( id, sBind );
      sCmdsAndKeys[ id ][ 0 ] = "";
      sCmdsAndKeys[ id ][ 1 ] = "";
   }
}

public Binds_menu( id )
{
   new mYesOrNo = menu_create( "^t\y[\rBinds menu\y] ^n^t\yХотите создать горячую клавишу?", "mhYesOrNo" );
   menu_additem( mYesOrNo, "\wДа" );
   menu_additem( mYesOrNo, "\wНет" );
   if( !not_show( id ) )
   {
      menu_addblank( mYesOrNo, 0 );
      menu_additem( mYesOrNo, "\wНе показывать меню при входе" );
   }
   menu_setprop( mYesOrNo, MPROP_EXIT, MEXIT_NEVER );
   menu_display( id, mYesOrNo, 0 );
   return PLUGIN_HANDLED;
}

public mhYesOrNo( id, mYesOrNo, iItem )
{
   if( iItem == 2 )
   {
      if( not_show( id ) )
      {
         return;
      }
      new sUserSID[ 64 ];
      get_user_authid( id, sUserSID, 64 );
      write_file( NOT_SHOW_PATH, sUserSID, -1 )
      ChatColor( id, "^1[^4Binds menu^1] ^3Чтобы открыть меню снова, напишите в чат ^4/binds^3." );
      return;
   }
   if( iItem == 0 )
   {
      menu_display( id, mCmds, 0 );
   }
}

public client_putinserver( id )
{
   if( not_show( id ) )
   {
      return;
   }
   set_task( 5.0, "Binds_menu", id );
}

public bool:not_show( id )
{
   new file = fopen( NOT_SHOW_PATH, "a+" );
   if( !file )
   {
      server_print( "Failed to open the file ^"%s^"", NOT_SHOW_PATH );
      return true;
   }
   else
   {
      new sBuffer[ 64 ], sUserSID[ 64 ];
      get_user_authid( id, sUserSID, 64 );
      while( !feof( file ) )
      {
         fgets( file, sBuffer, charsmax( sBuffer ) );
         parse( sBuffer, sBuffer, charsmax( sBuffer ) );
         if( !strcmp( sBuffer, sUserSID ) )
         {
            return true;
         }
      }
      return false;
   }
   return true;
}

stock STUFFTEXT_CMD( id = 0, sText[ ] ) 
{ 
	if ( ( id == 0 ) || ( is_user_connected( id ) ) )
	{ 
		message_begin( MSG_ONE, SVC_DIRECTOR_ID, _, id );
		write_byte( strlen( sText ) + 2 );
		write_byte( SVC_DIRECTOR_STUFFTEXT_ID );
		write_string( sText );
		message_end();
	}
}

stock ChatColor( const id, const input[ ], any:... )
{
	new count = 1, players[ 32 ];
	static sMsg[ 191 ];
	vformat( sMsg, charsmax( sMsg ), input, 3 );
	if ( id ) players[ 0 ] = id; else get_players( players, count, "ch" );
	{
		for ( new i; i < count; i++ )
		{
			if( is_user_connected( players[ i ] ) )
			{
				message_begin( MSG_ONE_UNRELIABLE, get_user_msgid( "SayText" ), _, players[ i ] );
				write_byte( players[ i ] );
				write_string( sMsg );
				message_end( );
			}
		}
	}
}