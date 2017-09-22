#include "crypt_inc.h"
void main() {
	/* Особые ф-ии */
	RC5Simple rc5(true);	locale().global(locale(""));
	/* Конец: Особые ф-ии */

	/* Переменные */
	int iStep = 1;
	char *pBuffer = (char *)malloc(BUFFER * sizeof(char));
	char *pPathEncr = (char *)malloc(BUFFER / 5 * sizeof(char));
	char *pPathDecr = (char *)malloc(BUFFER / 5 * sizeof(char));
	/* Конец: Переменные */

	/* Пути к файлам */
	*pPathEncr = NULL;
	strcat(pPathEncr, QUES_DIR);
	strcat(pPathEncr, AKEY_FILE_ENCRYPT);
	*pPathDecr = NULL;
	strcat(pPathDecr, QUES_DIR);
	strcat(pPathDecr, AKEY_FILE_DECRYPT);
	/* Конец: Пути к файлам */

	/* Авторизация (пропустится, если PASS не будет содержать символов) */
#if defined PASS
	HINSTANCE__ *hLibName; // Дескриптор загружаемой библиотеки универсальный
	*pBuffer = NULL; // нуль терминируем буфер
	strcat(pBuffer, DLLS_DIR); // копируем название папки хранения библиотеки
	strcat(pBuffer, AUTH_DLL); // копируем название нужной библиотеки
	hLibName = LoadLibrary(pBuffer); // загружаем библиотеку
	if (!hLibName)
	{
		*pBuffer = NULL;
		// Формируем сообщение для MessageBox
		strcat(pBuffer, "Библиотека ");
		strcat(pBuffer, DLLS_DIR);
		strcat(pBuffer, AUTH_DLL);
		strcat(pBuffer, " не найдена!");
		MessageBox(NULL, pBuffer, "Ошибка загрузки библиотеки", MB_OK | MB_ICONERROR);
		free(pBuffer); // освобождаем буфер
		exit(3); // закрываем программу с кодом 3
	}
	// Объявление указателей на функции, вызываемой из библиотеки,
	// название указателя никак не влияет на название вызываемой ф-ии;
	// назвал УНФ так же, как и функции в библиотеке для удобства
	int(*Auth)(char *, char *, int); // Прототип экспортируемой функции
	// Вызовом GetProcAddress получаем адреса ф-ий и присваиваем их указателям,
	// GetProcAddress возвращает бестиповой far-указатель!
	// Существует и др. вариант реализации получения УНФ,
	// но этот попросту понятнее, чем более нагромождённый его аналог
	(FARPROC &)Auth = GetProcAddress(hLibName, AUTH);
	if (!Auth)
	{
		*pBuffer = NULL;
		// Формируем сообщение для MessageBox
		strcat(pBuffer, "В библиотеке «");
		strcat(pBuffer, AUTH_DLL);
		strcat(pBuffer, "» не найдена функция «");
		strcat(pBuffer, AUTH);
		strcat(pBuffer, "»!");
		MessageBox(NULL, pBuffer, "Ошибка обращения к функции", MB_OK | MB_ICONERROR);
		free(pBuffer); // освобождаем буфер
		exit(4); // закрываем программу с кодом 4
	}
	int iAuthConfirmed = Auth(PASS, HPS, iStep);
	FreeLibrary(hLibName); // выгружаем библиотеку после использования
	if (!iAuthConfirmed)	CorE();
	if (iAuthConfirmed)		iStep++;
	system("cls");
#endif
/* Конец: Авторизация */

	// Генерация предварительного ключ шифрования
	char *pKey = (char *)malloc(RC5_B * sizeof(char) + 1);
	*pKey = NULL;
	strcat(pKey, KEY);
	// Конвертация ключа в вектор
	vector<unsigned char> vKey(RC5_B);
	for (int i = 0; i<RC5_B; i++)	vKey[i] = *(pKey + i);
	// Устанавливаем ключ шифрования
	rc5.RC5_SetKey(vKey);
choose_action:
	cout << "* Шаг " << iStep << "-й. Выберите действие: " << endl << endl;
	cout << "  1 - Зашифровать файл akeys.qst.decrypt" << endl;
	cout << "  2 - Расшифровать файл akeys.qst" << endl << endl << "Действие: ";
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
			strcat(pBuffer, "Файл «");
			strcat(pBuffer, AKEY_FILE_DECRYPT);
			strcat(pBuffer, "» не найден!");
			MessageBox(NULL, pBuffer, "Ошибка открытия файла", MB_OK | MB_ICONERROR);
			exit(0); // Выходим с кодом 0
		}
		// Отправляем зашифрованный файл назад получаем расшифрованный
		rc5.RC5_EncryptFile(pPathDecr, pPathEncr);
		*pBuffer = NULL;
		strcat(pBuffer, "Шифрование файла «");
		strcat(pBuffer, AKEY_FILE_DECRYPT);
		strcat(pBuffer, "» выполнено!");
		MessageBox(NULL, pBuffer, "Шифрование файла", MB_OK | MB_ICONERROR);
	}
	if (!_strcmp(pBuffer, "2")) {
		ifstream AK(pPathEncr);
		if (!AK.is_open()) {
			// Формируем сообщение для MessageBox
			*pBuffer = NULL;
			strcat(pBuffer, "Файл «");
			strcat(pBuffer, AKEY_FILE_ENCRYPT);
			strcat(pBuffer, "» не найден!");
			MessageBox(NULL, pBuffer, "Ошибка открытия файла", MB_OK | MB_ICONERROR);
			exit(1); // Выходим с кодом 1
		}
		// Отправляем зашифрованный файл назад получаем расшифрованный
		rc5.RC5_DecryptFile(pPathEncr, pPathDecr);
		*pBuffer = NULL;
		strcat(pBuffer, "Расшифрование файла «");
		strcat(pBuffer, AKEY_FILE_ENCRYPT);
		strcat(pBuffer, "» выполнено!");
		MessageBox(NULL, pBuffer, "Расшифрование файла", MB_OK | MB_ICONERROR);
	}
	CorE();
}

int CorE() {
	char *pBuffer = (char *)malloc(BUFFER * sizeof(char)); // определяем дин. массив для буфера символов
	cout << endl << endl << "Продолжить работу с программой? Да/Нет: ";
	efk(pBuffer, BUFFER);
	OemToCharA(pBuffer, pBuffer);
	if (!_stricmp(pBuffer, "да") || !_stricmp(pBuffer, "lf")) {	  // Не учитываем регистр
		cout << endl;
		system("cls");
		free(pBuffer); // Очищаем буфер по ненадобности
		return main();
	}
	else if (!_stricmp(pBuffer, "нет") || !_stricmp(pBuffer, "ytn")) { 	  // Не учитываем регистр
		free(pBuffer); // Очищаем буфер по ненадобности
		exit(2);
	}
	else {
		cout << "* Введен не верный ответ, выберите один из вариантов!" << endl << "* Или завершите выполнение программы самостоятельно.";
		free(pBuffer); // Очищаем буфер по ненадобности
		return CorE();
	}
	return 0;
}

void IPH(const wchar_t* expression,	const wchar_t* function, const wchar_t* file, unsigned int line, uintptr_t pReserved)
{
	// CRT обработчик ничего не делает. Просто разрешает выполнять код дальше
}
char *efk(char *pString, int iStrLen) { // Альтернативная ф-ия считывания введенных символов
	char *pMsg = (char *)malloc(300 * sizeof(char));
	char *pItoaBuf = (char *)malloc(20 * sizeof(char));
	errno_t eCode;
	_set_invalid_parameter_handler(IPH);
	// Вызываем gets_s, если буфер переполнится, вызовется обработчик
	// и продолжится выполнение кода ф-ии
	gets_s(pString, iStrLen);
	_get_errno(&eCode); // получаем код ошибки errno, через ф-ию, а ни макрос
	if (eCode == ERANGE) {
		*pMsg = NULL;
		strcat(pMsg, "Вы ввели недопустимое количество символов в строку!\n* Максимальное количество вводимых символов: ");
		strcat(pMsg, itoa((BUFFER - 1), pItoaBuf, 10));
		strcat(pMsg, "!\n\nУчтите это и начните ввод заново!");
		MessageBox(NULL, pMsg, "Ошибка переполнения буфера символов", MB_OK | MB_ICONERROR);
		// Освободим память за ненадобностью
		free(pMsg);
		free(pItoaBuf);
		_set_errno(NULL); // устанавливаем errno исходное значение (0 — исх. знач.)
		return efk(pString, iStrLen);
	}
	if (*pString == NULL)
		efk(pString, iStrLen);
	// Освободим память за ненадобностью
	free(pMsg);
	free(pItoaBuf);
	return pString;
}