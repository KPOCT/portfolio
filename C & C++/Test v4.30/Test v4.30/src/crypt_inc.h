#include <conio.h>
#include <iostream>
#include <fstream>
#include <windows.h>
#pragma warning(disable:4996)

#include "rc5\RC5Simple.h"

#define KEY "2La5^0GQq8MPEjZp" // Предварительный ключ шифрования
#define BUFFER 1000 // размер буфера на тысячу символов
#define PASS "test" // пароль авторизации преподавателя
#define HPS "*" // символ, которым прячутся символы ввода пароля

#define DLLS_DIR "dlls/" // путь к библиотекам
#define AUTH "Auth" // название ф-ии авторизации

#define QUES_DIR "questions/"
#define AKEY_FILE_ENCRYPT "akeys.qst"
#define AKEY_FILE_DECRYPT "akeys.qst.decrypt"


/* Скрипт автопереключения конфигурации и платформы для библиотек */
#ifndef _WIN64
#ifdef _DEBUG
#define GENF_DLL "debauth.dll"
#else
#define AUTH_DLL "auth.dll"
#endif
#else
#ifdef _DEBUG
#define GENF_DLL "debauth_64.dll"
#else
#define AUTH_DLL "auth_64.dll"
#endif
#endif
/* Конец: Скрипт автопереключения конфигурации и платформы для библиотек */

/* Прототипы ф-ий */
int CorE();
char *efk(char *, int);
/* Конец: Прототипы */

/* Именные пространства */
using namespace std;
/* Конец: Именные пространства */