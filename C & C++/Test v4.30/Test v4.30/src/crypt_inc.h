#include <conio.h>
#include <iostream>
#include <fstream>
#include <windows.h>
#pragma warning(disable:4996)

#include "rc5\RC5Simple.h"

#define KEY "2La5^0GQq8MPEjZp" // ��������������� ���� ����������
#define BUFFER 1000 // ������ ������ �� ������ ��������
#define PASS "test" // ������ ����������� �������������
#define HPS "*" // ������, ������� �������� ������� ����� ������

#define DLLS_DIR "dlls/" // ���� � �����������
#define AUTH "Auth" // �������� �-�� �����������

#define QUES_DIR "questions/"
#define AKEY_FILE_ENCRYPT "akeys.qst"
#define AKEY_FILE_DECRYPT "akeys.qst.decrypt"


/* ������ ���������������� ������������ � ��������� ��� ��������� */
#ifndef _WIN64
#ifdef _DEBUG
#define GENF_DLL "debauth.dll"
#else
#define AUTH_DLL "auth.dll"
#endif
#else
#ifdef _DEBUG
#define GENF_DLL "debauth_64.dll"
#else
#define AUTH_DLL "auth_64.dll"
#endif
#endif
/* �����: ������ ���������������� ������������ � ��������� ��� ��������� */

/* ��������� �-�� */
int CorE();
char *efk(char *, int);
/* �����: ��������� */

/* ������� ������������ */
using namespace std;
/* �����: ������� ������������ */