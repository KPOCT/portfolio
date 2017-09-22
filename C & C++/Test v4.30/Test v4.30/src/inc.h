/* includes */
#include <cerrno>
#include <iostream>
#include <windows.h>
/* �����: includes */

/* pragmas */
#pragma warning(disable:4996)
#pragma warning(disable:4267)
#pragma warning(disable:4018)
/* �����: pragmas */

//#define USE_ALL_QUES // ������������ ��� ��������� ������� � �����
#define BUFFER 1001 // ������ ������ �� ������ ��������
#define PASS "test" // ������ ����������� �������������
#define HPS "�" // ������, ������� �������� ������� ����� ������

/* typedefs, structs */
typedef HINSTANCE__ *DLL; // ��������� �� ��������� � ������
typedef char *daoc; // ��������� �� char

struct STUDNAME { daoc Name; daoc Lastname; };
/* �����: typedefs, structs */

// ����������� ��������� ������ "/" � �����, ���� ���������� ���� � ����� �������� ���������,
// ���� ����� �������� � ����� ��������� ������� �������
#define DLLS_DIR "dlls/" // ���� � �����������
#define INTGEN "IntGen" // �������� �-�� ��������� ��������� �����
#define AUTH "Auth" // �������� �-�� �����������
#define ATF "atf" // �������� �-�� �������� ������������� ������
#define TOTALQUESNUM "TotalQuesNum" // �������� �-�� �������� ���-�� ��������
#define READQUESFF "ReadQuesFF" // �������� �-�� ���������� �������� � ����� � �� ���������

/* ������ ���������������� ������������ � ��������� ��� ��������� */
#ifndef _WIN64
	#ifdef _DEBUG
	#define GENF_DLL "debgenf.dll"
	#else
	#define GENF_DLL "genf.dll"
	#define AUTH_DLL "auth.dll"
	#define RQFF_DLL "rqff.dll"
	#endif
#else
	#ifdef _DEBUG
	#define GENF_DLL "debgenf64.dll"
	#else
	#define GENF_DLL "genf_64.dll"
	#define AUTH_DLL "auth_64.dll"
	#define RQFF_DLL "rqff_64.dll"
	#endif
#endif
/* �����: ������ ���������������� ������������ � ��������� ��� ��������� */

/* ��������� �-�� */
int CorE();
daoc efk(daoc, int);
int OpenDll(daoc pLibName);
/* �����: ��������� */

/* ������� ������������ */
using namespace std;
/* �����: ������� ������������ */