#ifndef GENFUNCSDLL_API_EXPORTS
#define GENFUNCSDLL_API __declspec(dllexport) 
#else
#define GENFUNCSDLL_API __declspec(dllimport) 
#endif

#include <stdexcept>
#include <ctime>

int * ArrCheck(int *, int, int);