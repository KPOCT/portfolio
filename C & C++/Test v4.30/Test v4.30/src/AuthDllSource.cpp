#include "AuthDllHead.h"

extern "C" AUTHDLL_API int Auth(char *pPassword, char *pHPS, int iStep) {
	if (strlen(pPassword)) {
		/* ������ �-�� */
		locale().global(locale(""));
		/* �����: ������ �-�� */

		/* ���������� */
		char *pPassEnt = (char *)malloc(sizeof(char)); // pPassEnt � ������������ ������ ��� ���������� ��������
		char *pStars = (char *)malloc(sizeof(char)); // pStars � ������������ ������ ��� ��� ������ HPS

													 // ��������� ��������
		*pPassEnt = NULL;
		*pStars = NULL;

		char ch, chbuf[] = " ";
		int iArrSize;
		/* �����: ���������� */

		ch = VK_BACK; // ��� ����� � ����
		while (ch >= 'a' && ch <= 'z' || ch >= 'A' && ch <= 'Z' || ch >= '0' && ch <= '9' || ch >= 32 && ch <= 47 || ch >= 58 && ch <= 64 || ch >= 91 && ch <= 96 || ch >= 123 && ch <= 126 || ch == VK_RETURN || ch == VK_BACK || ch == 0xffffffFC || ch >= 0xffffff80 && ch <= 0xffffffAF || ch >= 0xffffffE0 && ch <= 0xffffffF7 || GetAsyncKeyState(VK_BACK) && GetAsyncKeyState(VK_CONTROL)) {
			system("cls");
			cout << "* ��� " << iStep << "-�. ����������� �������������" << endl << endl;
			cout << "������� ������: ";
			if (ch == VK_RETURN) break;
			else if (ch == VK_BACK) { // ���� BackSpace, �� ������� ��������� ������
				if (strlen(pPassEnt)) {
					iArrSize = strlen(pPassEnt) - 1;
					*(pStars + iArrSize) = NULL;
					*(pPassEnt + iArrSize) = NULL;
				}
				cout << pStars; // ������ ������� ����� ������
				ch = getch();
			}
			else if (GetAsyncKeyState(VK_BACK) && GetAsyncKeyState(VK_CONTROL)) {
				*pPassEnt = NULL;
				*pStars = NULL;
				cout << pStars;
				ch = getch();
			}
			else {
				*chbuf = ch;
				iArrSize = strlen(pPassEnt) + 1;
				pPassEnt = (char *)realloc(pPassEnt, iArrSize * sizeof(char) + 1);
				strcat(pPassEnt, chbuf);
				*(pPassEnt + iArrSize) = NULL;
				pStars = (char *)realloc(pStars, iArrSize * sizeof(char) + 1);
				strcat(pStars, pHPS);
				*(pStars + iArrSize) = NULL;
				cout << pStars;
				ch = getch();
			}
		}
		OemToCharA(pPassEnt, pPassEnt); // ��������������� ������� � Ansi ����� �� ���� ��������� + �������� � ����� ������
		if (strcmp(pPassEnt, pPassword)) {
			cout << pStars;
			cout << endl << "* ����� �������� ������!";
			return 0;
		}
		else {
			free(pPassEnt); // ����������� ������ �� pPassEnt
			free(pStars);  // ����������� ������ �� pStars
			return 1;
		}
	}
	return 0;
}