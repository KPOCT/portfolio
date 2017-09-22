#include "inc.h"
int main(){
	/* ��������� */					/* ������ �-�� */
	STUDNAME Student;				locale().global(locale(""));
	/* �����: ��������� */			/* �����: ������ �-�� */

	/* ���������� */
	double dMark = 0.0;
	int iStep = 1;
	daoc pBuffer = (daoc)malloc(BUFFER * sizeof(char));
	DLL hLibName; // ���������� ����������� ���������� �������������
	DLL hLibRQFF; // ���������� ��� ���������� rqff
	/* �����: ���������� */

	/* ����������� (�����������, ���� PASS �� ����� ��������� ��������) */
#if defined PASS
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
	/* ���������� ���������� �� �������, ���������� �� ����������,
	 * �������� ��������� ����� �� ������ �� �������� ���������� �-��;
	 * ������ ��� ��� ��, ��� � ������� � ���������� ��� �������� */
	int (*Auth)(daoc, daoc, int); // �������� �������������� �������
	/* ������� GetProcAddress �������� ������ �-�� � ����������� �� ����������, 
	 * GetProcAddress ���������� ���������� far-���������!
	 * ���������� � ��. ������� ���������� ��������� ���, �� ���� ��������, ��� ��� ������ */
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
	if (iAuthConfirmed){
		system("cls");
		iStep++;
	}
#endif
	/* �����: ����������� */

	/* ����������� */
	cout << "* ��� " << iStep << "-�. ���� ������ � �����������" << endl << endl;
	// ���� �����
	cout << "������� ���: ";
	efk(pBuffer, BUFFER);
	Student.Name = (daoc)malloc(strlen(pBuffer) * sizeof(char) + 1);
	OemToCharA(pBuffer, Student.Name); // ��������������� ������� � Ansi ����� �� ���� ��������� + �������� � ����� ������
	// ���� �������
	cout << "������� �������: ";
	efk(pBuffer, BUFFER);
	Student.Lastname = (daoc)malloc(strlen(pBuffer) * sizeof(char) + 1);
	OemToCharA(pBuffer, Student.Lastname); // ��������������� ������� � Ansi ����� �� ���� ��������� + �������� � ����� ������
	system("cls");
	iStep++;
	/* �����: ����������� */
	/* ���������� ��� ������ ����� */
	*pBuffer = NULL; // ���� ����������� �����
	strcat(pBuffer, DLLS_DIR); // �������� �������� ����� �������� ����������
	strcat(pBuffer, RQFF_DLL); // �������� �������� ������ ����������
	hLibRQFF = LoadLibrary(pBuffer);
	if (!hLibRQFF) {
		*pBuffer = NULL;
		// ��������� ��������� ��� MessageBox
		strcat(pBuffer, "���������� ");
		strcat(pBuffer, DLLS_DIR);
		strcat(pBuffer, RQFF_DLL);
		strcat(pBuffer, " �� �������!");
		MessageBox(NULL, pBuffer, "������ �������� ����������", MB_OK | MB_ICONERROR);
		free(pBuffer); // ����������� �����
		exit(3); // ��������� ��������� � ����� 3
	}
	// ���� (��������� �������������� �������)
	int (*ReadQuesFF)(int, int);
	void(*atf)();
	int(*TotalQuesNum)();
	// �������� ������ �-��
	(FARPROC &)ReadQuesFF = GetProcAddress(hLibRQFF, READQUESFF);
	(FARPROC &)atf = GetProcAddress(hLibRQFF, ATF);
	(FARPROC &)TotalQuesNum = GetProcAddress(hLibRQFF, TOTALQUESNUM);
	if (!ReadQuesFF) {
		*pBuffer = NULL;
		// ��������� ��������� ��� MessageBox
		strcat(pBuffer, "� ���������� �");
		strcat(pBuffer, RQFF_DLL);
		strcat(pBuffer, "� �� ������� ������� �");
		strcat(pBuffer, READQUESFF);
		strcat(pBuffer, "�!");
		MessageBox(NULL, pBuffer, "������ ��������� � �������", MB_OK | MB_ICONERROR);
		free(pBuffer); // ����������� �����
		exit(4); // ��������� ��������� � ����� 4
	}
	if (!atf) {
		*pBuffer = NULL;
		// ��������� ��������� ��� MessageBox
		strcat(pBuffer, "� ���������� �");
		strcat(pBuffer, RQFF_DLL);
		strcat(pBuffer, "� �� ������� ������� �");
		strcat(pBuffer, ATF);
		strcat(pBuffer, "�!");
		MessageBox(NULL, pBuffer, "������ ��������� � �������", MB_OK | MB_ICONERROR);
		free(pBuffer); // ����������� �����
		exit(4); // ��������� ��������� � ����� 4
	}
	if (!TotalQuesNum) {
		*pBuffer = NULL;
		// ��������� ��������� ��� MessageBox
		strcat(pBuffer, "� ���������� �");
		strcat(pBuffer, RQFF_DLL);
		strcat(pBuffer, "� �� ������� ������� �");
		strcat(pBuffer, TOTALQUESNUM);
		strcat(pBuffer, "�!");
		MessageBox(NULL, pBuffer, "������ ��������� � �������", MB_OK | MB_ICONERROR);
		free(pBuffer); // ����������� �����
		exit(4); // ��������� ��������� � ����� 4
	}
	atf(); // ��������� ������� ������ � questions/
	if (TotalQuesNum() == -1) // �������e� ������������ ���������� ������
	{
		MessageBox(NULL, "��������� ������������ ���������� ������:"
			"\n* akeys.qst"
			"\n* answers.qst"
			"\n* questions.qst"
			"\n\n�������� ���� �fill_rules.txt�!",
			"������ ������������� ������ � ������", MB_OK | MB_ICONERROR);
		exit(5); // ��������� ��������� � ����� 5
	}

	/* ���������� ��� ����� */
#if defined USE_ALL_QUES
	int iNoQitT = TotalQuesNum();
#else
	int iNoQitT = 10; // ���-�� �������� � �����
#endif
	int iRightAnswer, *pQuesNum = (int *)malloc(TotalQuesNum() * sizeof(int));
	/* �����: ���������� ��� ����� */
	hLibName = NULL; // ���������� ����������� ����������
	*pBuffer = NULL; // ���� ����������� �����
	strcat(pBuffer, DLLS_DIR); // �������� �������� ����� �������� ����������
	strcat(pBuffer, GENF_DLL); // �������� �������� ������ ����������
	hLibName = LoadLibrary(pBuffer);
	*pBuffer = NULL;
	if (!hLibName) {
		// ��������� ��������� ��� MessageBox
		strcat(pBuffer, "���������� ");
		strcat(pBuffer, DLLS_DIR);
		strcat(pBuffer, GENF_DLL);
		strcat(pBuffer, " �� �������!");
		MessageBox(NULL, pBuffer, "������ �������� ����������", MB_OK | MB_ICONERROR);
		free(pBuffer); // ����������� �����
		exit(3); // ��������� ��������� � ����� 3
	}
	int *(*IntGen)(int *, int);
	(FARPROC &)IntGen = GetProcAddress(hLibName, INTGEN);
	if (!IntGen) {
		// ��������� ��������� ��� MessageBox
		strcat(pBuffer, "� ���������� �");
		strcat(pBuffer, GENF_DLL);
		strcat(pBuffer, "� �� ������� ������� �");
		strcat(pBuffer, INTGEN);
		strcat(pBuffer, "�!");
		MessageBox(NULL, pBuffer, "������ ��������� � �������", MB_OK | MB_ICONERROR);
		free(pBuffer); // ����������� �����
		exit(4); // ��������� ��������� � ����� 4
	}
	pQuesNum = IntGen(pQuesNum, TotalQuesNum()); // ���������� ��������� ����� (��� ������ ��������� ��������)
	FreeLibrary(hLibName); // ��������� ���������� �� ������
	/* �����: ���������� ��� ������ ����� */

	/* ������� ��� ����� */
	for (int i = 0; i < iNoQitT; i++) {
	question:
		cout << "* ��� " << iStep << "-�. ����. ������ �" << i + 1 << endl << endl;
		iRightAnswer = ReadQuesFF(*(pQuesNum + i), TotalQuesNum());
		if (iRightAnswer == -1) { // �������� ������������ ���������� ����� akeys.qst.decrypt
			MessageBox(NULL, "��������� ������������ ���������� �����:"	"\n* akeys.qst.decrypt"	"\n\n�������� ���� �fill_rules.txt�!", "������ ���������� ������ � �����", MB_OK | MB_ICONERROR);
			free(pBuffer); // ����������� �����
			exit(6); // ��������� ��������� � ����� 6
		}
		cout << endl << endl << "��� ����� (������� �����): ";
		efk(pBuffer, BUFFER);
		if (atoi(pBuffer) == iRightAnswer)	dMark++;
		system("cls"); // ������� �����
		if (!!strcmp(pBuffer, "1") && !!strcmp(pBuffer, "2") && !!strcmp(pBuffer, "3") && !!strcmp(pBuffer, "4"))
			goto question;
	}
	free(pQuesNum); // ������� ��������������� ������ ��������
	FreeLibrary(hLibRQFF); // ��������� ���������� ���������� ��������, �������
	iStep++; // ��������� ���� ���������
	/* �����: ������� ��� ����� */

	/* ��������� */
	cout << "* ��� " << iStep << "-�. ���������" << endl << endl;
	if (dMark > iNoQitT / 2) {
		cout << "* ����������, " << Student.Name << " " << Student.Lastname << ", �� ������� " << dMark * 5 / iNoQitT;
		if (dMark * 5 / iNoQitT == 5) cout << " ������";
		else cout << " �����";
		cout << " � ����� ����!";
	} else {
		cout << "* ���, " << Student.Name << " " << Student.Lastname << ", �� ������� " << dMark * 5 / iNoQitT;
		if (dMark * 5 / iNoQitT == 1) cout << " ����";
		else if (dMark * 5 / iNoQitT == 0) cout << " ������";
		else cout << " �����";
		cout << " � �� ����� ����!";
	}
	free(pBuffer); // ������� ����� �� ������������
	free(Student.Name); // ������� ���
	free(Student.Lastname); // ������� �������
	return CorE();
}

int CorE() {
	daoc pBuffer = (daoc)malloc(BUFFER * sizeof(char)); // ���������� ���. ������ ��� ������ ��������
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
}

void IPH(const wchar_t* expression,
	const wchar_t* function,
	const wchar_t* file,
	unsigned int line,
	uintptr_t pReserved) {
	// CRT ���������� ������ �� ������
	// ������ ��������� ��������� ��� ������
}

daoc efk(daoc pString, int iStrLen) { // �������������� �-�� ���������� ��������� �������� � ����������
	daoc pMsg = (daoc)malloc(300 * sizeof(char));
	daoc pItoaBuf = (daoc)malloc(20 * sizeof(char));
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