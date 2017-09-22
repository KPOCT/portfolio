#include "inc.h"
int main(){
	/* Структуры */					/* Особые ф-ии */
	STUDNAME Student;				locale().global(locale(""));
	/* Конец: Структуры */			/* Конец: Особые ф-ии */

	/* Переменные */
	double dMark = 0.0;
	int iStep = 1;
	daoc pBuffer = (daoc)malloc(BUFFER * sizeof(char));
	DLL hLibName; // Дескриптор загружаемой библиотеки универсальный
	DLL hLibRQFF; // Дескриптор для библиотеки rqff
	/* Конец: Переменные */

	/* Авторизация (пропустится, если PASS не будет содержать символов) */
#if defined PASS
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
	/* Объявление указателей на функции, вызываемой из библиотеки,
	 * название указателя никак не влияет на название вызываемой ф-ии;
	 * назвал УНФ так же, как и функции в библиотеке для удобства */
	int (*Auth)(daoc, daoc, int); // Прототип экспортируемой функции
	/* Вызовом GetProcAddress получаем адреса ф-ий и присваиваем их указателям, 
	 * GetProcAddress возвращает бестиповый far-указатель!
	 * Существует и др. вариант реализации получения УНФ, но этот понятнее, чем его аналог */
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
	if (iAuthConfirmed){
		system("cls");
		iStep++;
	}
#endif
	/* Конец: Авторизация */

	/* Регистрация */
	cout << "* Шаг " << iStep << "-й. Ввод данных о тестируемом" << endl << endl;
	// ввод имени
	cout << "Введите имя: ";
	efk(pBuffer, BUFFER);
	Student.Name = (daoc)malloc(strlen(pBuffer) * sizeof(char) + 1);
	OemToCharA(pBuffer, Student.Name); // преобразовываем символы в Ansi чтобы не было билеберды + копируем в новый массив
	// ввод фамилии
	cout << "Введите фамилию: ";
	efk(pBuffer, BUFFER);
	Student.Lastname = (daoc)malloc(strlen(pBuffer) * sizeof(char) + 1);
	OemToCharA(pBuffer, Student.Lastname); // преобразовываем символы в Ansi чтобы не было билеберды + копируем в новый массив
	system("cls");
	iStep++;
	/* Конец: Регистрация */
	/* Подготовка для начала теста */
	*pBuffer = NULL; // нуль терминируем буфер
	strcat(pBuffer, DLLS_DIR); // копируем название папки хранения библиотеки
	strcat(pBuffer, RQFF_DLL); // копируем название нужной библиотеки
	hLibRQFF = LoadLibrary(pBuffer);
	if (!hLibRQFF) {
		*pBuffer = NULL;
		// Формируем сообщение для MessageBox
		strcat(pBuffer, "Библиотека ");
		strcat(pBuffer, DLLS_DIR);
		strcat(pBuffer, RQFF_DLL);
		strcat(pBuffer, " не найдена!");
		MessageBox(NULL, pBuffer, "Ошибка загрузки библиотеки", MB_OK | MB_ICONERROR);
		free(pBuffer); // освобождаем буфер
		exit(3); // закрываем программу с кодом 3
	}
	// УНФы (прототипы экспортируемых функций)
	int (*ReadQuesFF)(int, int);
	void(*atf)();
	int(*TotalQuesNum)();
	// Получаем адреса ф-ий
	(FARPROC &)ReadQuesFF = GetProcAddress(hLibRQFF, READQUESFF);
	(FARPROC &)atf = GetProcAddress(hLibRQFF, ATF);
	(FARPROC &)TotalQuesNum = GetProcAddress(hLibRQFF, TOTALQUESNUM);
	if (!ReadQuesFF) {
		*pBuffer = NULL;
		// Формируем сообщение для MessageBox
		strcat(pBuffer, "В библиотеке «");
		strcat(pBuffer, RQFF_DLL);
		strcat(pBuffer, "» не найдена функция «");
		strcat(pBuffer, READQUESFF);
		strcat(pBuffer, "»!");
		MessageBox(NULL, pBuffer, "Ошибка обращения к функции", MB_OK | MB_ICONERROR);
		free(pBuffer); // освобождаем буфер
		exit(4); // закрываем программу с кодом 4
	}
	if (!atf) {
		*pBuffer = NULL;
		// Формируем сообщение для MessageBox
		strcat(pBuffer, "В библиотеке «");
		strcat(pBuffer, RQFF_DLL);
		strcat(pBuffer, "» не найдена функция «");
		strcat(pBuffer, ATF);
		strcat(pBuffer, "»!");
		MessageBox(NULL, pBuffer, "Ошибка обращения к функции", MB_OK | MB_ICONERROR);
		free(pBuffer); // освобождаем буфер
		exit(4); // закрываем программу с кодом 4
	}
	if (!TotalQuesNum) {
		*pBuffer = NULL;
		// Формируем сообщение для MessageBox
		strcat(pBuffer, "В библиотеке «");
		strcat(pBuffer, RQFF_DLL);
		strcat(pBuffer, "» не найдена функция «");
		strcat(pBuffer, TOTALQUESNUM);
		strcat(pBuffer, "»!");
		MessageBox(NULL, pBuffer, "Ошибка обращения к функции", MB_OK | MB_ICONERROR);
		free(pBuffer); // освобождаем буфер
		exit(4); // закрываем программу с кодом 4
	}
	atf(); // Проверяем наличие файлов в questions/
	if (TotalQuesNum() == -1) // Проверяeм правильность заполнения файлов
	{
		MessageBox(NULL, "Проверьте правильность заполнения файлов:"
			"\n* akeys.qst"
			"\n* answers.qst"
			"\n* questions.qst"
			"\n\nПрочтите файл «fill_rules.txt»!",
			"Ошибка совместимости данных в файлах", MB_OK | MB_ICONERROR);
		exit(5); // закрываем программу с кодом 5
	}

	/* Переменные для теста */
#if defined USE_ALL_QUES
	int iNoQitT = TotalQuesNum();
#else
	int iNoQitT = 10; // кол-во вопросов в тесте
#endif
	int iRightAnswer, *pQuesNum = (int *)malloc(TotalQuesNum() * sizeof(int));
	/* Конец: Переменные для теста */
	hLibName = NULL; // Дескриптор загружаемой библиотеки
	*pBuffer = NULL; // нуль терминируем буфер
	strcat(pBuffer, DLLS_DIR); // копируем название папки хранения библиотеки
	strcat(pBuffer, GENF_DLL); // копируем название нужной библиотеки
	hLibName = LoadLibrary(pBuffer);
	*pBuffer = NULL;
	if (!hLibName) {
		// Формируем сообщение для MessageBox
		strcat(pBuffer, "Библиотека ");
		strcat(pBuffer, DLLS_DIR);
		strcat(pBuffer, GENF_DLL);
		strcat(pBuffer, " не найдена!");
		MessageBox(NULL, pBuffer, "Ошибка загрузки библиотеки", MB_OK | MB_ICONERROR);
		free(pBuffer); // освобождаем буфер
		exit(3); // закрываем программу с кодом 3
	}
	int *(*IntGen)(int *, int);
	(FARPROC &)IntGen = GetProcAddress(hLibName, INTGEN);
	if (!IntGen) {
		// Формируем сообщение для MessageBox
		strcat(pBuffer, "В библиотеке «");
		strcat(pBuffer, GENF_DLL);
		strcat(pBuffer, "» не найдена функция «");
		strcat(pBuffer, INTGEN);
		strcat(pBuffer, "»!");
		MessageBox(NULL, pBuffer, "Ошибка обращения к функции", MB_OK | MB_ICONERROR);
		free(pBuffer); // освобождаем буфер
		exit(4); // закрываем программу с кодом 4
	}
	pQuesNum = IntGen(pQuesNum, TotalQuesNum()); // генерируем случайные числа (для вывода случайных вопросов)
	FreeLibrary(hLibName); // выгружаем библиотеку из памяти
	/* Конец: Подготовка для начала теста */

	/* Вопросы для теста */
	for (int i = 0; i < iNoQitT; i++) {
	question:
		cout << "* Шаг " << iStep << "-й. Тест. Вопрос №" << i + 1 << endl << endl;
		iRightAnswer = ReadQuesFF(*(pQuesNum + i), TotalQuesNum());
		if (iRightAnswer == -1) { // Проверям правильность заполнения файла akeys.qst.decrypt
			MessageBox(NULL, "Проверьте правильность заполнения файла:"	"\n* akeys.qst.decrypt"	"\n\nПрочтите файл «fill_rules.txt»!", "Ошибка заполнения данных в файле", MB_OK | MB_ICONERROR);
			free(pBuffer); // освобождаем буфер
			exit(6); // закрываем программу с кодом 6
		}
		cout << endl << endl << "Ваш ответ (укажите цифру): ";
		efk(pBuffer, BUFFER);
		if (atoi(pBuffer) == iRightAnswer)	dMark++;
		system("cls"); // Очищаем экран
		if (!!strcmp(pBuffer, "1") && !!strcmp(pBuffer, "2") && !!strcmp(pBuffer, "3") && !!strcmp(pBuffer, "4"))
			goto question;
	}
	free(pQuesNum); // Очищаем сгенерированные номера вопросов
	FreeLibrary(hLibRQFF); // Выгружаем библиотеку считывания вопросов, ответов
	iStep++; // инкремент шага программы
	/* Конец: Вопросы для теста */

	/* Результат */
	cout << "* Шаг " << iStep << "-й. Результат" << endl << endl;
	if (dMark > iNoQitT / 2) {
		cout << "* Поздравляю, " << Student.Name << " " << Student.Lastname << ", Вы набрали " << dMark * 5 / iNoQitT;
		if (dMark * 5 / iNoQitT == 5) cout << " баллов";
		else cout << " балла";
		cout << " и сдали тест!";
	} else {
		cout << "* Увы, " << Student.Name << " " << Student.Lastname << ", Вы набрали " << dMark * 5 / iNoQitT;
		if (dMark * 5 / iNoQitT == 1) cout << " балл";
		else if (dMark * 5 / iNoQitT == 0) cout << " баллов";
		else cout << " балла";
		cout << " и не сдали тест!";
	}
	free(pBuffer); // Очищаем буфер по ненадобности
	free(Student.Name); // Очищаем имя
	free(Student.Lastname); // Очищаем фамилию
	return CorE();
}

int CorE() {
	daoc pBuffer = (daoc)malloc(BUFFER * sizeof(char)); // определяем дин. массив для буфера символов
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
}

void IPH(const wchar_t* expression,
	const wchar_t* function,
	const wchar_t* file,
	unsigned int line,
	uintptr_t pReserved) {
	// CRT обработчик ничего не делает
	// просто разрешает выполнять код дальше
}

daoc efk(daoc pString, int iStrLen) { // Альтернативная ф-ия считывания введенных символов с клавиатуры
	daoc pMsg = (daoc)malloc(300 * sizeof(char));
	daoc pItoaBuf = (daoc)malloc(20 * sizeof(char));
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