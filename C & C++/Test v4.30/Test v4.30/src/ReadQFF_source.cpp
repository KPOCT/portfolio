#include "ReadQFF_head.h"

extern "C" RQFFDLL_API int ReadQuesFF(int iLine, int iTotalQuesNum) {
	/* ������ �-�� */
	locale().global(locale(""));
	/* �����: ������ �-�� */

	/* ���������� */
	int iAKey;
	char *pBuffer = (char *)malloc(BUFFER * sizeof(char));

	*pBuffer = NULL;
	strcat(pBuffer, QUES_DIR);
	strcat(pBuffer, QUES_FILE);
	ifstream TQ(pBuffer);

	*pBuffer = NULL;
	strcat(pBuffer, QUES_DIR);
	strcat(pBuffer, ANSW_FILE);
	ifstream TA(pBuffer);

	*pBuffer = NULL;
	strcat(pBuffer, QUES_DIR);
	strcat(pBuffer, AKEY_FILE);
	ifstream AK(pBuffer);

	*pBuffer = NULL; // �������� ����� ��� ����������� �������������
	/* ���������� */

	for (int i = 0; i < iTotalQuesNum; i++) {
		if (!TQ.eof()) {
			TQ.getline(pBuffer, BUFFER - 1);
			if (i == iLine) {
				cout << "* " << pBuffer << endl;
			}
		}
		if (!TA.eof()) {
			TA.getline(pBuffer, BUFFER - 1);
			if (i == iLine) {
				int iNA = 1;
				for (char *pAnswer = strtok(pBuffer, DECL); pAnswer != NULL; pAnswer = strtok(NULL, DECL)) {
					cout << "  " << iNA << ") " << pAnswer << endl;
					iNA++;
				}
				break;
			}
		}
	}

	// � ����� ����������� ������ �� ������!
	// ������� ���������� ����� ������������ ���������� ������
	// x86 �� �������� return DecryptAKF(iLine, &k); � ��������!
	int k = 0; // ����� �� ������������
	iAKey = DecryptAKF(iLine, &k);

	if (iAKey == -1) return -1;
	if (iAKey < 1 || iAKey > 4) return -1;
	else return iAKey;
}

int DecryptAKF(int iLine, int *iNumOfKeys) { // �-�� ����������� �����
	int i;
	char *pTok;
	char *pPath = (char *)malloc(BUFFER / 5 * sizeof(char));
	int *pIntBuffer = (int *)malloc(BUFFER * sizeof(int));
	// ������ ������ �������������� ������
	vector<unsigned char> vDecryptedData;

	/* ������ �-�� */
	RC5Simple rc5(true);
	locale().global(locale(""));
	/* �����: ������ �-�� */

	*pPath = NULL;
	strcat(pPath, QUES_DIR);
	strcat(pPath, AKEY_FILE);

	// ���������� ����
	char *pKey = (char *)malloc(RC5_B * sizeof(char) + 1);
	*pKey = NULL;
	strcat(pKey, KEY);

	// ������������ ���� � ������
	vector<unsigned char> vKey(RC5_B);
	for (i = 0; i < RC5_B; i++)
		vKey[i] = *(pKey + i);

	// ������������� ���� ����������
	rc5.RC5_SetKey(vKey);
	// ���������� ������������� ���� ����� �������� �������������� ������
	rc5.RC5_DecryptFileRQFF(pPath, vDecryptedData);

	free(pPath); // ����������� ������ �� ���� � �����

	// ����� ��� ��������
	char *pBuffer = (char *)malloc(vDecryptedData.size() * sizeof(char));

	for (i = 0; i <= vDecryptedData.size(); i++) {
		if (i != vDecryptedData.size())
			*(pBuffer + i) = vDecryptedData[i];
		else
			*(pBuffer + i) = NULL;
	}

	// ��������� ������ � ������
	int iCnt = 0; // ������� ��� strtok
	for (pTok = strtok(pBuffer, DECL_AK); pTok != NULL; pTok = strtok(NULL, DECL_AK), iCnt++) {
		*(pIntBuffer + iCnt) = atoi(pTok);
	}

	// ���������� ����������� ����� ���-�� ������ �������
	*iNumOfKeys = iCnt;

	for (i = 0; i < iCnt; i++) {
		if (i == iLine) {
			return *(pIntBuffer + i);
			break;
		}
	}
	return -1;
}

extern "C" RQFFDLL_API void atf() { // �-�� �������� �� ������� ������ � ������ �����
	char *pBuffer = (char *)malloc(BUFFER * sizeof(char));

	*pBuffer = NULL;
	strcat(pBuffer, QUES_DIR);
	strcat(pBuffer, QUES_FILE);
	ifstream TQ(pBuffer);

	*pBuffer = NULL;
	strcat(pBuffer, QUES_DIR);
	strcat(pBuffer, ANSW_FILE);
	ifstream TA(pBuffer);

	*pBuffer = NULL;
	strcat(pBuffer, QUES_DIR);
	strcat(pBuffer, AKEY_FILE);
	ifstream AK(pBuffer);

	*pBuffer = NULL; // �������� ����� ��� ����������� �������������

	if (!TQ.is_open()) {
		// ��������� ��������� ��� MessageBox
		strcat(pBuffer, "���� �");
		strcat(pBuffer, QUES_FILE);
		strcat(pBuffer, "� �� ������!");

		MessageBox(NULL, pBuffer, "������ �������� �����", MB_OK | MB_ICONERROR);

		free(pBuffer); // ����������� �����
		exit(6); // ��������� ��������� � ����� 6
	}

	if (!TA.is_open()) {
		// ��������� ��������� ��� MessageBox
		strcat(pBuffer, "���� �");
		strcat(pBuffer, ANSW_FILE);
		strcat(pBuffer, "� �� ������!");

		MessageBox(NULL, pBuffer, "������ �������� �����", MB_OK | MB_ICONERROR);

		free(pBuffer); // ����������� �����
		exit(7); // ��������� ��������� � ����� 7
	}

	if (!AK.is_open()) {
		// ��������� ��������� ��� MessageBox
		strcat(pBuffer, "���� �");
		strcat(pBuffer, AKEY_FILE);
		strcat(pBuffer, "� �� ������!");

		MessageBox(NULL, pBuffer, "������ �������� �����", MB_OK | MB_ICONERROR);

		free(pBuffer); // ����������� �����
		exit(8); // ��������� ��������� � ����� 8
	}
}

extern "C" RQFFDLL_API int TotalQuesNum() { // �-�� �������� ���������� ��������
	int iNoQitF = 0, iNoAitF = 0, iNoAKitF = 0;
	char *pPath = (char *)malloc(BUFFER / 5 * sizeof(char)); // ����� ����
	char *pBuffer = (char *)malloc(BUFFER * sizeof(char));

	/* ����� ���� � ������ */
	*pPath = NULL;
	strcat(pPath, QUES_DIR);
	strcat(pPath, QUES_FILE);
	ifstream TQ(pPath);

	*pPath = NULL;
	strcat(pPath, QUES_DIR);
	strcat(pPath, ANSW_FILE);
	ifstream TA(pPath);

	free(pPath); // ����������� ������
	/* �����: ����� ���� � ������ */

	while (!TQ.eof()) { // ������� ������� ����� � ����� ��������
		TQ.getline(pBuffer, BUFFER - 1);
		if (pBuffer == NULL) // ���� ������ ������
			return -1; // ���������� -1 (�.�. ������)
		iNoQitF++;
	}
	while (!TA.eof()) { // ������� ������� ����� � ����� �������
		TA.getline(pBuffer, BUFFER - 1);
		if (pBuffer == NULL) // ���� ������ ������
			return -1; // ���������� -1 (�.�. ������)
		iNoAitF++;
	}

	DecryptAKF(NULL, &iNoAKitF);

	free(pBuffer); // ����������� ������

	if (iNoQitF != iNoAitF || iNoQitF != iNoAKitF) // ���� ���������� ��������, ������� � ������ �� ���������
		return -1; // ������� -1
	return iNoQitF; // ������� ���������� ��������
}