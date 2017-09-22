/* includes */
#include <cerrno>
#include <iostream>
#include <windows.h>
/* Конец: includes */

/* pragmas */
#pragma warning(disable:4996)
#pragma warning(disable:4267)
#pragma warning(disable:4018)
/* Конец: pragmas */

//#define USE_ALL_QUES // использовать все возможные вопросы в тесте
#define BUFFER 1001 // размер буфера на тысячу символов
#define PASS "test" // пароль авторизации преподавателя
#define HPS "•" // символ, которым прячутся символы ввода пароля

/* typedefs, structs */
typedef HINSTANCE__ *DLL; // указатель на библиотку в памяти
typedef char *daoc; // указатель на char

struct STUDNAME { daoc Name; daoc Lastname; };
/* Конец: typedefs, structs */

// Обязательно оставлять символ "/" в конце, если указываете путь к папке хранения библиотек,
// если хотим находить в корне оставляем ковычки пустыми
#define DLLS_DIR "dlls/" // путь к библиотекам
#define INTGEN "IntGen" // название ф-ии рандомной генерации чисел
#define AUTH "Auth" // название ф-ии авторизации
#define ATF "atf" // название ф-ии проверки существования файлов
#define TOTALQUESNUM "TotalQuesNum" // название ф-ии подсчёта кол-ва вопросов
#define READQUESFF "ReadQuesFF" // название ф-ии считывания вопросов с файла и их обработка

/* Скрипт автопереключения конфигурации и платформы для библиотек */
#ifndef _WIN64
	#ifdef _DEBUG
	#define GENF_DLL "debgenf.dll"
	#else
	#define GENF_DLL "genf.dll"
	#define AUTH_DLL "auth.dll"
	#define RQFF_DLL "rqff.dll"
	#endif
#else
	#ifdef _DEBUG
	#define GENF_DLL "debgenf64.dll"
	#else
	#define GENF_DLL "genf_64.dll"
	#define AUTH_DLL "auth_64.dll"
	#define RQFF_DLL "rqff_64.dll"
	#endif
#endif
/* Конец: Скрипт автопереключения конфигурации и платформы для библиотек */

/* Прототипы ф-ий */
int CorE();
daoc efk(daoc, int);
int OpenDll(daoc pLibName);
/* Конец: Прототипы */

/* Именные пространства */
using namespace std;
/* Конец: Именные пространства */