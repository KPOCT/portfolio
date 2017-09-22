#ifndef GENFUNCSDLL_API_EXPORTS
#define AUTHDLL_API __declspec(dllexport) 
#else
#define AUTHDLL_API __declspec(dllimport) 
#endif

#include <iostream>
#include <windows.h>
#include <conio.h>

#pragma warning(disable:4996)
#pragma warning(disable:4267)

using namespace std;