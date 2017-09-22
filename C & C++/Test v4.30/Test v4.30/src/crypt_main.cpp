#include "crypt_inc.h"
void main() {
	/* ������ �-�� */
	RC5Simple rc5(true);	locale().global(locale(""));
	/* �����: ������ �-�� */

	/* ���������� */
	int iStep = 1;
	char *pBuffer = (char *)malloc(BUFFER * sizeof(char));
	char *pPathEncr = (char *)malloc(BUFFER / 5 * sizeof(char));
	char *pPathDecr = (char *)malloc(BUFFER / 5 * sizeof(char));
	/* �����: ���������� */

	/* ���� � ������ */
	*pPathEncr = NULL;
	strcat(pPathEncr, QUES_DIR);
	strcat(pPathEncr, AKEY_FILE_ENCRYPT);
	*pPathDecr = NULL;
	strcat(pPathDecr, QUES_DIR);
	strcat(pPathDecr, AKEY_FILE_DECRYPT);
	/* �����: ���� � ������ */

	/* ����������� (�����������, ���� PASS �� ����� ��������� ��������) */
#if defined PASS
	HINSTANCE__ *hLibName; // ���������� ����������� ���������� �������������
	*pBuffer = NULL; // ���� ����������� �����
	strcat(pBuffer, DLLS_DIR); // �������� �������� ����� �������� ����������
	strcat(pBuffer, AUTH_DLL); // �������� �������� ������ ����������
	hLibName = LoadLibrary(pBuffer); // ��������� ����������
	if (!hLibName)
	{
		*pBuffer = NULL;
		// ��������� ��������� ��� MessageBox
		strcat(pBuffer, "���������� ");
		strcat(pBuffer, DLLS_DIR);
		strcat(pBuffer, AUTH_DLL);
		strcat(pBuffer, " �� �������!");
		MessageBox(NULL, pBuffer, "������ �������� ����������", MB_OK | MB_ICONERROR);
		free(pBuffer); // ����������� �����
		exit(3); // ��������� ��������� � ����� 3
	}
	// ���������� ���������� �� �������, ���������� �� ����������,
	// �������� ��������� ����� �� ������ �� �������� ���������� �-��;
	// ������ ��� ��� ��, ��� � ������� � ���������� ��� ��������
	int(*Auth)(char *, char *, int); // �������� �������������� �������
	// ������� GetProcAddress �������� ������ �-�� � ����������� �� ����������,
	// GetProcAddress ���������� ���������� far-���������!
	// ���������� � ��. ������� ���������� ��������� ���,
	// �� ���� �������� ��������, ��� ����� ������������� ��� ������
	(FARPROC &)Auth = GetProcAddress(hLibName, AUTH);
	if (!Auth)
	{
		*pBuffer = NULL;
		// ��������� ��������� ��� MessageBox
		strcat(pBuffer, "� ���������� �");
		strcat(pBuffer, AUTH_DLL);
		strcat(pBuffer, "� �� ������� ������� �");
		strcat(pBuffer, AUTH);
		strcat(pBuffer, "�!");
		MessageBox(NULL, pBuffer, "������ ��������� � �������", MB_OK | MB_ICONERROR);
		free(pBuffer); // ����������� �����
		exit(4); // ��������� ��������� � ����� 4
	}
	int iAuthConfirmed = Auth(PASS, HPS, iStep);
	FreeLibrary(hLibName); // ��������� ���������� ����� �������������
	if (!iAuthConfirmed)	CorE();
	if (iAuthConfirmed)		iStep++;
	system("cls");
#endif
/* �����: ����������� */

	// ��������� ���������������� ���� ����������
	char *pKey = (char *)malloc(RC5_B * sizeof(char) + 1);
	*pKey = NULL;
	strcat(pKey, KEY);
	// ����������� ����� � ������
	vector<unsigned char> vKey(RC5_B);
	for (int i = 0; i<RC5_B; i++)	vKey[i] = *(pKey + i);
	// ������������� ���� ����������
	rc5.RC5_SetKey(vKey);
choose_action:
	cout << "* ��� " << iStep << "-�. �������� ��������: " << endl << endl;
	cout << "  1 - ����������� ���� akeys.qst.decrypt" << endl;
	cout << "  2 - ������������ ���� akeys.qst" << endl << endl << "��������: ";
	efk(pBuffer, BUFFER);
	OemToCharA(pBuffer, pBuffer);
	if (!!_strcmp(pBuffer, "1") && !!_strcmp(pBuffer, "2")) {
		system("cls");
		goto choose_action;
	}
	if (!_strcmp(pBuffer, "1")) {
		ifstream AK(pPathDecr);
		if (!AK.is_open()) {
			*pBuffer = NULL;
			strcat(pBuffer, "���� �");
			strcat(pBuffer, AKEY_FILE_DECRYPT);
			strcat(pBuffer, "� �� ������!");
			MessageBox(NULL, pBuffer, "������ �������� �����", MB_OK | MB_ICONERROR);
			exit(0); // ������� � ����� 0
		}
		// ���������� ������������� ���� ����� �������� ��������������
		rc5.RC5_EncryptFile(pPathDecr, pPathEncr);
		*pBuffer = NULL;
		strcat(pBuffer, "���������� ����� �");
		strcat(pBuffer, AKEY_FILE_DECRYPT);
		strcat(pBuffer, "� ���������!");
		MessageBox(NULL, pBuffer, "���������� �����", MB_OK | MB_ICONERROR);
	}
	if (!_strcmp(pBuffer, "2")) {
		ifstream AK(pPathEncr);
		if (!AK.is_open()) {
			// ��������� ��������� ��� MessageBox
			*pBuffer = NULL;
			strcat(pBuffer, "���� �");
			strcat(pBuffer, AKEY_FILE_ENCRYPT);
			strcat(pBuffer, "� �� ������!");
			MessageBox(NULL, pBuffer, "������ �������� �����", MB_OK | MB_ICONERROR);
			exit(1); // ������� � ����� 1
		}
		// ���������� ������������� ���� ����� �������� ��������������
		rc5.RC5_DecryptFile(pPathEncr, pPathDecr);
		*pBuffer = NULL;
		strcat(pBuffer, "������������� ����� �");
		strcat(pBuffer, AKEY_FILE_ENCRYPT);
		strcat(pBuffer, "� ���������!");
		MessageBox(NULL, pBuffer, "������������� �����", MB_OK | MB_ICONERROR);
	}
	CorE();
}

int CorE() {
	char *pBuffer = (char *)malloc(BUFFER * sizeof(char)); // ���������� ���. ������ ��� ������ ��������
	cout << endl << endl << "���������� ������ � ����������? ��/���: ";
	efk(pBuffer, BUFFER);
	OemToCharA(pBuffer, pBuffer);
	if (!_stricmp(pBuffer, "��") || !_stricmp(pBuffer, "lf")) {	  // �� ��������� �������
		cout << endl;
		system("cls");
		free(pBuffer); // ������� ����� �� ������������
		return main();
	}
	else if (!_stricmp(pBuffer, "���") || !_stricmp(pBuffer, "ytn")) { 	  // �� ��������� �������
		free(pBuffer); // ������� ����� �� ������������
		exit(2);
	}
	else {
		cout << "* ������ �� ������ �����, �������� ���� �� ���������!" << endl << "* ��� ��������� ���������� ��������� ��������������.";
		free(pBuffer); // ������� ����� �� ������������
		return CorE();
	}
	return 0;
}

void IPH(const wchar_t* expression,	const wchar_t* function, const wchar_t* file, unsigned int line, uintptr_t pReserved)
{
	// CRT ���������� ������ �� ������. ������ ��������� ��������� ��� ������
}
char *efk(char *pString, int iStrLen) { // �������������� �-�� ���������� ��������� ��������
	char *pMsg = (char *)malloc(300 * sizeof(char));
	char *pItoaBuf = (char *)malloc(20 * sizeof(char));
	errno_t eCode;
	_set_invalid_parameter_handler(IPH);
	// �������� gets_s, ���� ����� ������������, ��������� ����������
	// � ����������� ���������� ���� �-��
	gets_s(pString, iStrLen);
	_get_errno(&eCode); // �������� ��� ������ errno, ����� �-��, � �� ������
	if (eCode == ERANGE) {
		*pMsg = NULL;
		strcat(pMsg, "�� ����� ������������ ���������� �������� � ������!\n* ������������ ���������� �������� ��������: ");
		strcat(pMsg, itoa((BUFFER - 1), pItoaBuf, 10));
		strcat(pMsg, "!\n\n������ ��� � ������� ���� ������!");
		MessageBox(NULL, pMsg, "������ ������������ ������ ��������", MB_OK | MB_ICONERROR);
		// ��������� ������ �� �������������
		free(pMsg);
		free(pItoaBuf);
		_set_errno(NULL); // ������������� errno �������� �������� (0 � ���. ����.)
		return efk(pString, iStrLen);
	}
	if (*pString == NULL)
		efk(pString, iStrLen);
	// ��������� ������ �� �������������
	free(pMsg);
	free(pItoaBuf);
	return pString;
}