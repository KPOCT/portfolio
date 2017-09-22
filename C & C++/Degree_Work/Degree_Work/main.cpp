#include "inc.h"

#pragma warning(disable:4244) // Отключаем вывод предупреждения 4244 при компиляции

HANDLE hConsoleHandle = GetStdHandle(STD_OUTPUT_HANDLE); // Получаем дескриптор потока вывода текущей консоли для изменения цвета текста и фона

MYSQL *connection, mysql; // Структуры, позволяющие взаимодействовать с БД
MYSQL_RES *result; // Структура, позволяющая обрабатывать результирующий набор
MYSQL_ROW row; // Двумерный массив для записи строк

void main(void)
{
	setlocale(LC_ALL, "Russian"); // Поддержка кириллицы

	unsigned int i = 0;
	while(!connect_to_db())
	{
		system("cls");
		printf(" Не удалось соединиться с базой данных!\n", SetErrorTextColor());
		printf(" Ошибка: \"%s\"\n", mysql_error(&mysql));
		printf(" Неудачных попыток: %d\n\n", ++i);
		printf(" Нажмите любую клавишу для повторной попытки подключения,\n", SetStandardTextColor());
		printf(" либо нажмите Escape для завершения работы программы...\n\n");
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
	GetPrivateProfileStringA("mysql_init", "host", NULL, sHost, charsmax(sHost), ".\\mysql.ini"); // Здесь и ниже парсим файл с данными для подключения к БД
	GetPrivateProfileStringA("mysql_init", "user", NULL, sUser, charsmax(sUser), ".\\mysql.ini");
	GetPrivateProfileStringA("mysql_init", "pass", NULL, sPass, charsmax(sPass), ".\\mysql.ini");
	GetPrivateProfileStringA("mysql_init", "db", NULL, sDB, charsmax(sDB), ".\\mysql.ini");
	GetPrivateProfileStringA("mysql_init", "port", NULL, sPort, charsmax(sPort), ".\\mysql.ini");

	mysql_init(&mysql); // Инициализация структуры
	connection = mysql_real_connect(&mysql, sHost, sUser, sPass, sDB, atoi(sPort), NULL , 0); // Подключаемся к БД
	if(connection == NULL) // Если соединение не удалось
	{
          return false;
	}

	mysql_query(&mysql, "SET NAMES cp1251"); // Для кириллицы, если в БД не установлена нужная кодировка
	mysql_query(&mysql, "SET CHARACTER SET cp1251");

	return true;
}


/* Главное меню */
void m_main(void)
{
	int iKeys = 0;

	mysql_free_result(result); // Очищаем результирующий набор

	system("cls");
	printf("  %s\n", sMenuNames[0], SetHeaderTextColor());

	for(unsigned int i = 1; i < arraySize(sMenuNames); i++) // По всему массиву, кроме первого элемента ("Главное меню")
	{
		printf("\n  %d. ", i, SetNumberTextColor()); // Выводим циферки специального цвета
		printf("%s", sMenuNames[i], SetStandardTextColor()); // Выводим пункты обычного цвета
		add_key(i, iKeys); // Добавляем пункт в бит. сумму, чтобы можно было на него нажимать
	}

	printf("\n\n\n  0. ", SetNumberTextColor());
	printf("Выйти", SetStandardTextColor());
	add_key(MENU_KEY_0, iKeys);

	mh_main(iKeys);
}

/* Хендлер главного меню */
void mh_main(int iKeys)
{
	switch(get_key(iKeys)) // Ожидаем нажатие клавиши, которая заключена в бит. сумме iKeys
	{
		case MENU_KEY_1:
		{
			if(!read_medications()) // Если запрос удался, то
				menu_create(mMedications, 0); // Создаём меню лекарств. 0 - начальная страница
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

/* Создаём меню */ 
void menu_create(int iMenu, int iPage)
{
	int iMaxPages = mysql_num_rows(result) / ITEMS_PER_PAGE, iKeys = 0; // Определяем максимальное кол-во строк
	if(!(mysql_num_rows(result) % ITEMS_PER_PAGE))	iMaxPages--;

	if(iPage > iMaxPages) // Корректируем номер текущей страницы, дабы он не вышел за рамки предела
		iPage = iMaxPages;
	if(iPage < 0) 
		iPage = 0;

	/* Начало: заполнение меню */
	system("cls"); // Очищаем экран
	printf("  %s", sMenuNames[iMenu], SetHeaderTextColor()); // Выводим название меню
	printf(" [%d/%d]\n", iPage + 1, iMaxPages + 1, SetDisableTextColor()); // номер текущей страницы и общее число страниц

	char **sRows = (char**)malloc(sizeof(char*) * mysql_num_rows(result)); // Создаём двумерный динамический массив для получения результата запроса
	for(unsigned int i = 0; row = mysql_fetch_row(result), i < mysql_num_rows(result); i++)
	{
		sRows[i] = (char*)malloc(sizeof(char) * strlen(*row));
		sRows[i] = *row;
	}
	
	mysql_data_seek(result, 0); // Т.к. после предыдущего цикла каретка оказалась в конце таблицы, нужно её переместить в нулевую позицию для дальнейшей работы
	
	SetStandardTextColor();
	for(unsigned int i = 0; i < ITEMS_PER_PAGE; i++) // Выводим пункты
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

	if(!iPage)	printf("\n\n 8. Назад", SetDisableTextColor()); // Если страница нулевая, тогда закрашиваем тёмносерым цетом 
	else 
	{
		add_key(MENU_KEY_8, iKeys); 
		printf("\n\n 8. ", SetNumberTextColor()); 
		printf("Назад", SetStandardTextColor()); 
	}

	if(iPage >= iMaxPages)	printf("\n 9. Вперёд", SetDisableTextColor()); 
	else 
	{
		add_key(MENU_KEY_9, iKeys); 
		printf("\n 9. ", SetNumberTextColor()); 
		printf("Вперёд", SetStandardTextColor()); 
	}

	add_key(MENU_KEY_0, iKeys); 
	printf("\n\n 0. ", SetNumberTextColor()); 
	printf("%s", sMenuNames[0], SetStandardTextColor()); 
	/* Конец: заполнение меню */ 


	switch(iMenu) // Вызов хендлера 
	{
		case mMedications : mh_medications(iPage, iKeys); 
		case mDiagnosis : mh_diagnosis(iPage, iKeys); 
		case mCompositions : mh_compositions(iPage, iKeys); 
		case mContraindications : mh_contraindications(iPage, iKeys); 
		case mManufacturers : mh_manufacturers(iPage, iKeys); 
	}
}

/* Хендлер меню лекарств */
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
			printf("\n\n\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor()); // Выводим информацию по пункту, который был нажат
			printf("\t  %21s | ", "Название", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][0], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t %21s | ", "Показания к применению", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][1], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t  %21s | ", "Дозировка", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][2], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			mysql_data_seek(result, 0);
			_getch();
			menu_create(mMedications, iPage);
		}
	}
}

/* Хендлер меню диагнозов */
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
			printf("\n\n\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t %8s | ", "Название", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][0], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			mysql_data_seek(result, 0);
			_getch();
			menu_create(mDiagnosis, iPage);
		}
	}
}

/* Хендлер меню составов лекарств */
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
			printf("\n\n\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t  %12s | ", "Состав", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][0], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t  %12s | ", "Группа", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][1], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t %12s | ", "Форма выпуска", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][2], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			mysql_data_seek(result, 0);
			_getch();
			menu_create(mCompositions, iPage);
		}
	}
}

/* Хендлер меню противопоказаний */
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
			printf("\n\n\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t %15s | ", "Другие препараты", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][0], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t %15s | ", "Побочные эффекты", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][1], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t  %15s | ", "Для детей", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][2], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t  %15s | ", "Для беременных", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][3], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			mysql_data_seek(result, 0);
			_getch();
			menu_create(mContraindications, iPage);
		}
	}
}

/* Хендлер меню изготовителей */
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
			printf("\n\n\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t %7s | ", "Компания", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][0], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			printf("\t  %7s | ", "Страна", SetHeaderTextColor());
			printf("%s\n", sRows[iKey + iPage * ITEMS_PER_PAGE][1], SetStandardTextColor());
			printf("\t———————————————————————————————————————————————————————————————\n", SetSeparatorColor());
			mysql_data_seek(result, 0);
			_getch();
			menu_create(mManufacturers, iPage);
		}
	}
}

/* Ф-я отлова нажатия цифренных клавиш, которые указаны в iKeys */ 
int get_key(int iKeys)
{
	for(;;) // Бесконечный цикл. Эквивалентно while(1)
	{
		char cKey = _getch() - 48; // Коды цифренных клавиш: 48-57. Чтобы получить настоящее число клавиши, отнимаем 48 (49-48=1 -- нажали клавишу 1)
		if(key_valid(cKey, iKeys)) // Разрешено ли нажатие этой клавиши? Т.е. находится ли этот бит в бит. сумме?
			return cKey; // Если "да", то возвращаем цифру нажатой клавиши
	}
}

int read_medications()
{
	char sDB[32];
	GetPrivateProfileStringA("mysql_init", "db", NULL, sDB, charsmax(sDB), ".\\mysql.ini");
	if(mysql_select_db(&mysql, sDB)) // Выбираем нужную нам БД
	{
		printf("\n\n"); 
		error_db(); // Если во время выбора БД произошла ошибка, то вызываем соответствующую функцию
	}

	if(mysql_query(&mysql, "SELECT name, applying, dosing_regimen FROM medications")) // Посылаем запрос (просим поля name, applying, dosing_regimen с таблицы medications
	{
		printf("\n\n"); 
		error_db();
	}

	if(!(result = mysql_store_result(&mysql))) // Получаем результирующий набор
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

	if(mysql_query(&mysql, "SELECT interactions, side_effects, 4children, 4pregnant FROM сontraindications"))
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
	printf("* Ошибка взаимодействия с базой данных:\n", SetErrorTextColor()); 
	printf("* \"%s\"\n\n", mysql_error(&mysql)); // Ф-я возвращает строку с ошибкой
	printf("* Восстановите соединение с сервером MySQL,\n", SetStandardTextColor()); 
	printf("* программа автоматически продолжит работу...\n");
	while(!connect_to_db()); 
	//m_main(); 
}