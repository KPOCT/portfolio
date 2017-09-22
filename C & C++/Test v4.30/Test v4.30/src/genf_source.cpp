#include "genf_head.h"

extern "C" GENFUNCSDLL_API int * IntGen(int *pI, int iMin, int iMax) {
	srand((unsigned)time(NULL)); // ��������� ����� ��������� �� �������
	for (int i = 0; i < (iMax - iMin); i++) // ��������� ���������� �������, ����� �� �� ����
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
			if (*(pI + i) == *(pI + j)) { // ���� ��������� ������ ����������, ��
				*(pI + j) = iMin + rand() % (iMax - iMin); // ���������� �����
				iSumbRep++; // ����������, ������ ����������
			}
		}
	}
	if (iSumbRep != 0) // ��������� ���������� �� ������
		return ArrCheck(pI, iMin, iMax);
	return pI;
}