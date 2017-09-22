#ifndef GENFUNCSDLL_API_EXPORTS
#define RQFFDLL_API __declspec(dllexport) 
#else
#define RQFFDLL_API __declspec(dllimport) 
#endif

#include <iostream>
#include <fstream>
#include <windows.h>
#include "rc5\RC5Simple.h"

#pragma warning(disable:4996)

#define QUES_DIR "questions/"
#define QUES_FILE "questions.qst"
#define ANSW_FILE "answers.qst"
#define AKEY_FILE "akeys.qst"

#define BUFFER 1000
#define KEY "2La5^0GQq8MPEjZp"
#define DECL "\t"
#define DECL_AK "\n"

/* Прототипы ф-ий */
int DecryptAKF(int, int *);
/*Конец: Прототипы ф-ий*/

using namespace std;
