#include "inc.h"

#pragma warning(disable:4244) // ��������� ����� �������������� 4244 ��� ����������

HANDLE hConsoleHandle = GetStdHandle(STD_OUTPUT_HANDLE); // �������� ���������� ������ ������ ������� ������� ��� ��������� ����� ������ � ����

MYSQL *connection, mysql; // ���������, ����������� ����������������� � ��
MYSQL_RES *result; // ���������, ����������� ������������ �������������� �����
MYSQL_ROW row; // ��������� ������ ��� ������ �����

void main(void)
{
	setlocale(LC_ALL, "Russian"); // ��������� ���������

	unsigned int i = 0;
	while(!connect_to_db())
	{
		system("cls");
		printf(" �� ������� ����������� � ����� ������!\n", SetErrorTextColor());
		printf(" ������: \"%s\"\n", mysql_error(&mysql));
		printf(" ��������� �������: %d\n\n", ++i);
		printf(" ������� ����� ������� ��� ��������� ������� �����������,\n", SetStandardTextColor());
		printf(" ���� ������� Escape ��� ���������� ������ ���������...\n\n");
		if(_getch() == KEYCODE_ESC)
		{
			exit(EXIT_FAILURE);
		}
	}

	m_main();
}

bool connect_to_db()
{
	char sHost[32], sUser[32], sPass[32], sDB[32], sPort[32];
	GetPrivateProfileStringA("mysql_init", "host", NULL, sHost, charsmax(sHost), ".\\mysql.ini"); // ����� � ���� ������ ���� � ������� ��� ����������� � ��
	GetPrivateProfileStringA("mysql_init", "user", NULL, sUser, charsmax(sUser), ".\\mysql.ini");
	GetPrivateProfileStringA("mysql_init", "pass", NULL, sPass, charsmax(sPass), ".\\mysql.ini");
	GetPrivateProfileStringA("mysql_init", "db", NULL, sDB, charsmax(sDB), ".\\mysql.ini");
	GetPrivateProfileStringA("mysql_init", "port", NULL, sPort, charsmax(sPort), ".\\mysql.ini");

	mysql_init(&mysql); // ������������� ���������
	connection = mysql_real_connect(&mysql, sHost, sUser, sPass, sDB, atoi(sPort), NULL , 0); // ������������ � ��
	if(connection == NULL) // ���� ���������� �� �������
	{
          return false;
	}

	mysql_query(&mysql, "SET NAMES cp1251"); // ��� ���������, ���� � �� �� ����������� ������ ���������
	mysql_query(&mysql, "SET CHARACTER SET cp1251");

	return true;
}


/* ������� ���� */
void m_main(void)
{
	int iKeys = 0;

	mysql_free_result(result); // ������� �������������� �����

	system("cls");
	printf("  %s\n", sMenuNames[0], SetHeaderTextColor());

	for(unsigned int i = 1; i < arraySize(sMenuNames); i++) // �� ����� �������, ����� ������� �������� ("������� ����")
	{
		printf("\n  %d. ", i, SetNumberTextColor()); // ������� ������� ������������ �����
		printf("%s", sMenuNames[i], SetStandardTextColor()); // ������� ������ �������� �����
		add_key(i, iKeys); // ��������� ����� � ���. �����, ����� ����� ���� �� ���� ��������
	}

	printf("\n\n\n  0. ", SetNumberTextColor());
	printf("�����", SetStandardTextColor());
	add_key(MENU_KEY_0, iKeys);

	mh_main(iKeys);
}

/* ������� �������� ���� */
void mh_main(int iKeys)
{
	switch(get_key(iKeys)) // ������� ������� �������, ������� ��������� � ���. ����� iKeys
	{
		case MENU_KEY_1:
		{
			if(!read_medications()) // ���� ������ ������, ��
				menu_create(mMedications, 0); // ������ ���� ��������. 0 - ��������� ��������
			break;
		}
		case MENU_KEY_2:
		{
			if(!read_diagnosis())
				menu_create(mDiagnosis, 0);
			break;
		}
		case MENU_KEY_3:
		{
			if(!read_compositions())
				menu_create(mCompositions, 0);
			break;
		}
		case MENU_KEY_4:
		{
			if(!read_cntraindications())
				menu_create(mContraindications, 0);
			break;
		}
		case MENU_KEY_5:
		{
			if(!read_manufacturers())
				menu_create(mManufacturers, 0);
			break;
		}
		case MENU_KEY_0:
		{
			exit(1);
		}
	}
}

/* ������ ���� */ 
void menu_create(int iMenu, int iPage)
{
	int iMaxPages = mysql_num_rows(result) / ITEMS_PER_PAGE, iKeys = 0; // ���������� ������������ ���-�� �����
	if(!(mysql_num_rows(result) % ITEMS_PER_PAGE))	iMaxPages--;

	if(iPage > iMaxPages) // ������������ ����� ������� ��������, ���� �� �� ����� �� ����� �������
		iPage = iMaxPages;
	if(iPage < 0) 
		iPage = 0;

	/* ������: ���������� ���� */
	system("cls"); // ������� �����
	printf("  %s", sMenuNames[iMenu], SetHeaderTextColor()); // ������� �������� ����
	printf(" [%d/%d]\n", iPage + 1, iMaxPages + 1, SetDisableTextColor()); // ����� ������� �������� � ����� ����� �������

	char **sRows = (char**)malloc(sizeof(char*) * mysql_num_rows(result)); // ������ ��������� ������������ ������ ��� ��������� ���������� �������
	for(unsigned int i = 0; row = mysql_fetch_row(result), i < mysql_num_rows(result); i++)
	{
		sRows[i] = (char*)malloc(sizeof(char) * strlen(*row));
		sRows[i] = *row;
	}
	
	mysql_data_seek(result, 0); // �.�. ����� ����������� ����� ������� ��������� � ����� �������, ����� � ����������� � ������� ������� ��� ���������� ������
	
	SetStandardTextColor();
	for(unsigned int i = 0; i < ITEMS_PER_PAGE; i++) // ������� ������
	{
		if((i + iPage * ITEMS_PER_PAGE) < mysql_num_rows(result))
		{
			printf("\n %d. ", i + 1, SetNumberTextColor());
			printf("%s", sRows[i + iPage * ITEMS_PER_PAGE], SetStandardTextColor());
			add_key((i + 1), iKeys);
		}
		else
		{
			printf("\n");
		}
	}

	if(!iPage)	printf("\n\n 8. �����", SetDisableTextColor()); // ���� �������� �������, ����� ����������� ��������� ����� 
	else 
	{
		add_key(MENU_KEY_8, iKeys); 
		printf("\n\n 8. ", SetNumberTextColor()); 
		printf("�����", SetStandardTextColor()); 
	}

	if(iPage >= iMaxPages)	printf("\n 9. �����", SetDisableTextColor()); 
	else 
	{
		add_key(MENU_KEY_9, iKeys); 
		printf("\n 9. ", SetNumberTextColor()); 
		printf("�����", SetStandardTextColor()); 
	}

	add_key(MENU_KEY_0, iKeys); 
	printf("\n\n 0. ", SetNumberTextColor()); 
	printf("%s", sMenuNames[0], SetStandardTextColor()); 
	/* �����: ���������� ���� */ 


	switch(iMenu) // ����� �������� 
	{
		case mMedications : mh_medications(iPage, iKeys); 
		case mDiagnosis : mh_diagnosis(iPage, iKeys); 
		case mCompositions : mh_compositions(iPage, iKeys); 
		case mContraindications : mh_contraindications(iPage, iKeys); 
		case mManufacturers : mh_manufacturers(iPage, iKeys); 
	}
}

/* ������� ���� �������� */
void mh_medications(int iPage, int iKeys = 0)
{
	int iKey = get_key(iKeys);
	switch(iKey)
	{
		case MENU_KEY_8:
		{
			menu_create(mMedications, --iPage);
			break;
		}
		case MENU_KEY_9:
		{
			menu_create(mMedications, ++iPage);
			break;
		}
		case MENU_KEY_0:
		{
			m_main();
			break;
		}
		default:
		{
			iKey--;
			MYSQL_ROW *sRows = (char***)malloc(sizeof(char**) * mysql_num_rows(result));
			for(unsigned int i = 0; row = mysql_fetch_row(result), i < mysql_num_rows(result); i++)
			{
				sRows[i] = (char**)malloc(sizeof(char*) * mysql_num_fields(result));
				for(unsigned int j = 0; j < mysql_num_fields(result); j++)
				{
					sRows[i][j] = (char*)malloc(sizeof(char) * strlen(row[j]));
					sRows[i][j] = row[j];
				}
			}
			printf("\n\n\t���������������������������������������������������������������\n", SetSeparatorColor()); // ������� ���������� �� ������, ������� ��� �����
			printf("\t  %21s | ", "��������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][0], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t %21s | ", "��������� � ����������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][1], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t  %21s | ", "���������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][2], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			mysql_data_seek(result, 0);
			_getch();
			menu_create(mMedications, iPage);
		}
	}
}

/* ������� ���� ��������� */
void mh_diagnosis(int iPage, int iKeys = 0)
{
	int iKey = get_key(iKeys);
	switch(iKey)
	{
		case MENU_KEY_8:
		{
			menu_create(mDiagnosis, --iPage);
			break;
		}
		case MENU_KEY_9:
		{
			menu_create(mDiagnosis, ++iPage);
			break;
		}
		case MENU_KEY_0:
		{
			m_main();
			break;
		}
		default:
		{
			iKey--;
			MYSQL_ROW *sRows = (char***)malloc(sizeof(char**) * mysql_num_rows(result));
			for(unsigned int i = 0; row = mysql_fetch_row(result), i < mysql_num_rows(result); i++)
			{
				sRows[i] = (char**)malloc(sizeof(char*) * mysql_num_fields(result));
				for(unsigned int j = 0; j < mysql_num_fields(result); j++)
				{
					sRows[i][j] = (char*)malloc(sizeof(char) * strlen(row[j]));
					sRows[i][j] = row[j];
				}
			}
			printf("\n\n\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t %8s | ", "��������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][0], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			mysql_data_seek(result, 0);
			_getch();
			menu_create(mDiagnosis, iPage);
		}
	}
}

/* ������� ���� �������� �������� */
void mh_compositions(int iPage, int iKeys = 0)
{
	int iKey = get_key(iKeys);
	switch(iKey)
	{
		case MENU_KEY_8:
		{
			menu_create(mCompositions, --iPage);
			break;
		}
		case MENU_KEY_9:
		{
			menu_create(mCompositions, ++iPage);
			break;
		}
		case MENU_KEY_0:
		{
			m_main();
			break;
		}
		default:
		{
			iKey--;
			MYSQL_ROW *sRows = (char***)malloc(sizeof(char**) * mysql_num_rows(result));
			for(unsigned int i = 0; row = mysql_fetch_row(result), i < mysql_num_rows(result); i++)
			{
				sRows[i] = (char**)malloc(sizeof(char*) * mysql_num_fields(result));
				for(unsigned int j = 0; j < mysql_num_fields(result); j++)
				{
					sRows[i][j] = (char*)malloc(sizeof(char) * strlen(row[j]));
					sRows[i][j] = row[j];
				}
			}
			printf("\n\n\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t  %12s | ", "������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][0], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t  %12s | ", "������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][1], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t %12s | ", "����� �������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][2], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			mysql_data_seek(result, 0);
			_getch();
			menu_create(mCompositions, iPage);
		}
	}
}

/* ������� ���� ���������������� */
void mh_contraindications(int iPage, int iKeys = 0)
{
	int iKey = get_key(iKeys);
	switch(iKey)
	{
		case MENU_KEY_8:
		{
			menu_create(mContraindications, --iPage);
			break;
		}
		case MENU_KEY_9:
		{
			menu_create(mContraindications, ++iPage);
			break;
		}
		case MENU_KEY_0:
		{
			m_main();
			break;
		}
		default:
		{
			iKey--;
			MYSQL_ROW *sRows = (char***)malloc(sizeof(char**) * mysql_num_rows(result));
			for(unsigned int i = 0; row = mysql_fetch_row(result), i < mysql_num_rows(result); i++)
			{
				sRows[i] = (char**)malloc(sizeof(char*) * mysql_num_fields(result));
				for(unsigned int j = 0; j < mysql_num_fields(result); j++)
				{
					sRows[i][j] = (char*)malloc(sizeof(char) * strlen(row[j]));
					sRows[i][j] = row[j];
				}
			}
			printf("\n\n\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t %15s | ", "������ ���������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][0], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t %15s | ", "�������� �������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][1], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t  %15s | ", "��� �����", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][2], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t  %15s | ", "��� ����������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][3], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			mysql_data_seek(result, 0);
			_getch();
			menu_create(mContraindications, iPage);
		}
	}
}

/* ������� ���� ������������� */
void mh_manufacturers(int iPage, int iKeys = 0)
{
	int iKey = get_key(iKeys);
	switch(iKey)
	{
		case MENU_KEY_8:
		{
			menu_create(mManufacturers, --iPage);
			break;
		}
		case MENU_KEY_9:
		{
			menu_create(mManufacturers, ++iPage);
			break;
		}
		case MENU_KEY_0:
		{
			m_main();
			break;
		}
		default:
		{
			iKey--;
			MYSQL_ROW *sRows = (char***)malloc(sizeof(char**) * mysql_num_rows(result));
			for(unsigned int i = 0; row = mysql_fetch_row(result), i < mysql_num_rows(result); i++)
			{
				sRows[i] = (char**)malloc(sizeof(char*) * mysql_num_fields(result));
				for(unsigned int j = 0; j < mysql_num_fields(result); j++)
				{
					sRows[i][j] = (char*)malloc(sizeof(char) * strlen(row[j]));
					sRows[i][j] = row[j];
				}
			}
			printf("\n\n\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t %7s | ", "��������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][0], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			printf("\t  %7s | ", "������", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][1], SetStandardTextColor());
			printf("\t���������������������������������������������������������������\n", SetSeparatorColor());
			mysql_data_seek(result, 0);
			_getch();
			menu_create(mManufacturers, iPage);
		}
	}
}

/* �-� ������ ������� ��������� ������, ������� ������� � iKeys */ 
int get_key(int iKeys)
{
	for(;;) // ����������� ����. ������������ while(1)
	{
		char cKey = _getch() - 48; // ���� ��������� ������: 48-57. ����� �������� ��������� ����� �������, �������� 48 (49-48=1 -- ������ ������� 1)
		if(key_valid(cKey, iKeys)) // ��������� �� ������� ���� �������? �.�. ��������� �� ���� ��� � ���. �����?
			return cKey; // ���� "��", �� ���������� ����� ������� �������
	}
}

int read_medications()
{
	char sDB[32];
	GetPrivateProfileStringA("mysql_init", "db", NULL, sDB, charsmax(sDB), ".\\mysql.ini");
	if(mysql_select_db(&mysql, sDB)) // �������� ������ ��� ��
	{
		printf("\n\n"); 
		error_db(); // ���� �� ����� ������ �� ��������� ������, �� �������� ��������������� �������
	}

	if(mysql_query(&mysql, "SELECT name, applying, dosing_regimen FROM medications")) // �������� ������ (������ ���� name, applying, dosing_regimen � ������� medications
	{
		printf("\n\n"); 
		error_db();
	}

	if(!(result = mysql_store_result(&mysql))) // �������� �������������� �����
	{
		printf("\n\n"); 
		error_db();
	}

	return NULL;
}

int read_diagnosis()
{
	char sDB[32];
	GetPrivateProfileStringA("mysql_init", "db", NULL, sDB, charsmax(sDB), ".\\mysql.ini");
	if(mysql_select_db(&mysql, sDB))
	{
		printf("\n\n");
		error_db();
	}

	if(mysql_query(&mysql, "SELECT name FROM diagnosis"))
	{
		printf("\n\n"); 
		error_db();
	}

	if(!(result = mysql_store_result(&mysql)))
	{
		printf("\n\n"); 
		error_db();
	}

	return NULL;
}

int read_compositions()
{
	char sDB[32];
	GetPrivateProfileStringA("mysql_init", "db", NULL, sDB, charsmax(sDB), ".\\mysql.ini");
	if(mysql_select_db(&mysql, sDB))
	{
		printf("\n\n"); 
		error_db();
	}

	if(mysql_query(&mysql, "SELECT components, grp, issue_form FROM consist"))
	{
		printf("\n\n"); 
		error_db();
	}

	if(!(result = mysql_store_result(&mysql)))
	{
		printf("\n\n"); 
		error_db();
	}

	return NULL;
}

int read_cntraindications()
{
	char sDB[32];
	GetPrivateProfileStringA("mysql_init", "db", NULL, sDB, charsmax(sDB), ".\\mysql.ini");
	if(mysql_select_db(&mysql, sDB))
	{
		printf("\n\n"); 
		error_db();
	}

	if(mysql_query(&mysql, "SELECT interactions, side_effects, 4children, 4pregnant FROM �ontraindications"))
	{
		printf("\n\n"); 
		error_db();
	}

	if(!(result = mysql_store_result(&mysql)))
	{
		printf("\n\n"); 
		error_db();
	}

	return NULL;
}

int read_manufacturers()
{
	char sDB[32];
	GetPrivateProfileStringA("mysql_init", "db", NULL, sDB, charsmax(sDB), ".\\mysql.ini");
	if(mysql_select_db(&mysql, sDB))
	{
		printf("\n\n"); 
		error_db();
	}

	if(mysql_query(&mysql, "SELECT company, country FROM manufacturer"))
	{
		printf("\n\n"); 
		error_db();
	}

	if(!(result = mysql_store_result(&mysql)))
	{
		printf("\n\n"); 
		error_db();
	}

	return NULL;
}

void error_db() 
{ 
	printf("* ������ �������������� � ����� ������:\n", SetErrorTextColor()); 
	printf("* \"%s\"\n\n", mysql_error(&mysql)); // �-� ���������� ������ � �������
	printf("* ������������ ���������� � �������� MySQL,\n", SetStandardTextColor()); 
	printf("* ��������� ������������� ��������� ������...\n");
	while(!connect_to_db()); 
	//m_main(); 
}