#include "genf_head.h"

extern "C" GENFUNCSDLL_API int * IntGen(int *pI, int iMin, int iMax) {
	srand((unsigned)time(NULL)); // рандомные числа зависящие от времени
	for (int i = 0; i < (iMax - iMin); i++) // Заполняем рандомными числами, чтобы то ни было
		*(pI + i) = iMin + rand() % (iMax - iMin);
	pI = ArrCheck(pI, iMin, iMax);
	return pI;
}

int * ArrCheck(int *pI, int iMin, int iMax) {
	if ((iMax - iMin) == 1)
		return pI;
	int i, j, iSumbRep = 0;
	for (i = 0; i < (iMax - iMin) - 1; i++) {
		for (j = i + 1; j < (iMax - iMin); j++) {
			if (*(pI + i) == *(pI + j)) { // если следующий символ повторился, то
				*(pI + j) = iMin + rand() % (iMax - iMin); // генерируем новый
				iSumbRep++; // показываем, символ повторился
			}
		}
	}
	if (iSumbRep != 0) // проверяем повторился ли символ
		return ArrCheck(pI, iMin, iMax);
	return pI;
}