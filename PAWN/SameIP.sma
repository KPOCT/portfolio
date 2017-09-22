#include <amxmodx>

#define PLUGIN "Same IP"
#define VERSION "0.3"
#define AUTHOR "KP0CT"

#define MAX_SAME_IP        1	// Сколько игроков с одним IP может находиться на сервере?
#define BAN_DURATION       5
new gszKickMsg[] =         "На сервере уже есть игрок с этим IP. Вы забанены на 5 минут."

#define MAX_PLAYERS        32
//#define WHITELIST_SIZE   2	// ТОЧНОЕ колличество строк с разрешенными IP; Раскомментируй, чтобы включить белый список.

#if defined WHITELIST_SIZE
new const gszWhiteList[WHITELIST_SIZE][] = {
	"127.0.0.0/8",         // loopback-интерфейс (Обычно присваивается IP 127.0.0.1)
	"192.168.0.0/24",      // Подсети 192.168.0.0/24, IP-адреса диапазона 192.168.0.0 ... 192.168.0.255
	//"10.3.3.2/24",         // Подсети 10.3.3.0/24. Можно использовать любой другой IP-адрес.
}
#endif

#define DEBUG

new gszPlayerIP[MAX_PLAYERS + 1][16]
new Trie:gtPlayerIPs

#if defined WHITELIST_SIZE
enum _:WhitelistData {
	NET_IP,
	NET_MASK
}
new Array:gaWhitelist
#endif

#define FIRST_PLAYER   1
#define SINGLE_PLAYER  1

public plugin_init() {
	register_plugin( PLUGIN, VERSION, AUTHOR )
	register_cvar( "sameip_version", VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED )

	gtPlayerIPs = TrieCreate()

#if defined WHITELIST_SIZE
	new iData[WhitelistData]
	gaWhitelist = ArrayCreate(WhitelistData)

	for( new i; i < WHITELIST_SIZE; i++ ) {
		net_to_long( gszWhiteList[i], iData[NET_IP], iData[NET_MASK] )
		ArrayPushArray( gaWhitelist, iData )
	}
#endif
}

public client_putinserver(id) {
	new szPlayerIP[16]
	get_user_ip( id, szPlayerIP, charsmax(szPlayerIP), 1 /* без порта */ )

#if defined WHITELIST_SIZE
	new iData[WhitelistData]
	for( new i; i < WHITELIST_SIZE; i++ ) {
		ArrayGetArray( gaWhitelist, i, iData )
		if( iData[NET_IP] == ip_to_long(szPlayerIP) & iData[NET_MASK] ) {
			#if defined DEBUG
			server_print( "Обнаружен "белый" IP: id %d, IP %s", id, szPlayerIP )
			#endif
			return
		}
	}
#endif

	new iQuantity = FIRST_PLAYER
	if( TrieGetCell( gtPlayerIPs, szPlayerIP, iQuantity ) ) {
		if( ++iQuantity > MAX_SAME_IP ) {
			server_cmd( "kick #%d  %s; wait; addip %d %s", get_user_userid(id), gszKickMsg, BAN_DURATION, szPlayerIP )
			static szBanMsg[] = "IP-адрес %s был забанен на %d минут"
			log_amx( szBanMsg, szPlayerIP, BAN_DURATION )
		}
	}

	TrieSetCell( gtPlayerIPs, szPlayerIP, iQuantity )
	copy( gszPlayerIP[id], charsmax( gszPlayerIP[] ), szPlayerIP )
}

public client_disconnect(id) {
	if( !gszPlayerIP[id][0] )
		// Игрок в белом списке или не полноценно инициализирован (это может произойти после смены карты)
		return

	new iQuantity
	TrieGetCell( gtPlayerIPs, gszPlayerIP[id], iQuantity )
	if( iQuantity == SINGLE_PLAYER )
		TrieDeleteKey( gtPlayerIPs, gszPlayerIP[id] )
	else
		TrieSetCell( gtPlayerIPs, gszPlayerIP[id], --iQuantity )

	gszPlayerIP[id][0] = EOS
}

/*--- Улучшенный и упрощённый преобразователь стоков от Zetex ---*/

// Получает сеть и маску, как длину подсети
stock net_to_long( net_string[], &net, &mask ) {
	new i, ip[16]

	i = copyc( ip, charsmax(ip), net_string, '/' )
	mask = i ? cidr_to_long( net_string[i + 1] ) : 0xFFFFFFFF /* маска /32, непосредственный IP*/

	net = ip_to_long(ip) & mask
}

// Преобразует маску в длину. Возвращает unsigned long.
stock cidr_to_long( mask_string[] ) {
	new mask = str_to_num(mask_string)
	new result = (1 << 31) >> (mask - 1)

	return result
}

// Преобразует IP в длину. Возвращает unsigned long.
stock ip_to_long( ip_string[] ) {
	new right[16], part[4], octet, ip = 0
	strtok( ip_string, part, 3, right, 15, '.' )

	for( new i = 0; i < 4; i++ ) {
		octet = str_to_num(part)

		ip += octet

		if( i == 3 )
			break

		strtok( right, part, 3, right, 15, '.' )
		ip = ip << 8
	}

	return ip
}