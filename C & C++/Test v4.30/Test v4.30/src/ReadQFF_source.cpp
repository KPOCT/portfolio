#include "ReadQFF_head.h"

extern "C" RQFFDLL_API int ReadQuesFF(int iLine, int iTotalQuesNum) {
	/* Особые ф-ии */
	locale().global(locale(""));
	/* Конец: Особые ф-ии */

	/* Переменные */
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

	*pBuffer = NULL; // обнуляем буфер для дальнейшего использования
	/* Переменные */

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

	// В схеме возвращения ничего не менять!
	// Сделано специально через присваевание переменной данных
	// x86 не понимает return DecryptAKF(iLine, &k); и вылетает!
	int k = 0; // здесь не используется
	iAKey = DecryptAKF(iLine, &k);

	if (iAKey == -1) return -1;
	if (iAKey < 1 || iAKey > 4) return -1;
	else return iAKey;
}

int DecryptAKF(int iLine, int *iNumOfKeys) { // Ф-ия расшифровки файла
	int i;
	char *pTok;
	char *pPath = (char *)malloc(BUFFER / 5 * sizeof(char));
	int *pIntBuffer = (int *)malloc(BUFFER * sizeof(int));
	// Создаём вектор расшифрованных данных
	vector<unsigned char> vDecryptedData;

	/* Особые ф-ии */
	RC5Simple rc5(true);
	locale().global(locale(""));
	/* Конец: Особые ф-ии */

	*pPath = NULL;
	strcat(pPath, QUES_DIR);
	strcat(pPath, AKEY_FILE);

	// Генерируем ключ
	char *pKey = (char *)malloc(RC5_B * sizeof(char) + 1);
	*pKey = NULL;
	strcat(pKey, KEY);

	// Конвертируем ключ в вектор
	vector<unsigned char> vKey(RC5_B);
	for (i = 0; i < RC5_B; i++)
		vKey[i] = *(pKey + i);

	// Устанавливаем ключ шифрования
	rc5.RC5_SetKey(vKey);
	// Отправляем зашифрованный файл назад получаем расшифрованный вектор
	rc5.RC5_DecryptFileRQFF(pPath, vDecryptedData);

	free(pPath); // Освобождаем память от пути к файлу

	// Буфер для символов
	char *pBuffer = (char *)malloc(vDecryptedData.size() * sizeof(char));

	for (i = 0; i <= vDecryptedData.size(); i++) {
		if (i != vDecryptedData.size())
			*(pBuffer + i) = vDecryptedData[i];
		else
			*(pBuffer + i) = NULL;
	}

	// Переводим данные в строку
	int iCnt = 0; // счетчик для strtok
	for (pTok = strtok(pBuffer, DECL_AK); pTok != NULL; pTok = strtok(NULL, DECL_AK), iCnt++) {
		*(pIntBuffer + iCnt) = atoi(pTok);
	}

	// Отправляем обработчику общее кол-во ключей ответов
	*iNumOfKeys = iCnt;

	for (i = 0; i < iCnt; i++) {
		if (i == iLine) {
			return *(pIntBuffer + i);
			break;
		}
	}
	return -1;
}

extern "C" RQFFDLL_API void atf() { // Ф-ия проверки на наличие файлов в нужной папке
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

	*pBuffer = NULL; // обнуляем буфер для дальнейшего использования

	if (!TQ.is_open()) {
		// Формируем сообщение для MessageBox
		strcat(pBuffer, "Файл «");
		strcat(pBuffer, QUES_FILE);
		strcat(pBuffer, "» не найден!");

		MessageBox(NULL, pBuffer, "Ошибка открытия файла", MB_OK | MB_ICONERROR);

		free(pBuffer); // освобождаем буфер
		exit(6); // закрываем программу с кодом 6
	}

	if (!TA.is_open()) {
		// Формируем сообщение для MessageBox
		strcat(pBuffer, "Файл «");
		strcat(pBuffer, ANSW_FILE);
		strcat(pBuffer, "» не найден!");

		MessageBox(NULL, pBuffer, "Ошибка открытия файла", MB_OK | MB_ICONERROR);

		free(pBuffer); // освобождаем буфер
		exit(7); // закрываем программу с кодом 7
	}

	if (!AK.is_open()) {
		// Формируем сообщение для MessageBox
		strcat(pBuffer, "Файл «");
		strcat(pBuffer, AKEY_FILE);
		strcat(pBuffer, "» не найден!");

		MessageBox(NULL, pBuffer, "Ошибка открытия файла", MB_OK | MB_ICONERROR);

		free(pBuffer); // освобождаем буфер
		exit(8); // закрываем программу с кодом 8
	}
}

extern "C" RQFFDLL_API int TotalQuesNum() { // Ф-ия подсчёта количества вопросов
	int iNoQitF = 0, iNoAitF = 0, iNoAKitF = 0;
	char *pPath = (char *)malloc(BUFFER / 5 * sizeof(char)); // буфер пути
	char *pBuffer = (char *)malloc(BUFFER * sizeof(char));

	/* Создём пути к файлам */
	*pPath = NULL;
	strcat(pPath, QUES_DIR);
	strcat(pPath, QUES_FILE);
	ifstream TQ(pPath);

	*pPath = NULL;
	strcat(pPath, QUES_DIR);
	strcat(pPath, ANSW_FILE);
	ifstream TA(pPath);

	free(pPath); // освобождаем память
	/* Конец: Создём пути к файлам */

	while (!TQ.eof()) { // считаем сколько строк в файле вопросов
		TQ.getline(pBuffer, BUFFER - 1);
		if (pBuffer == NULL) // если строка пустая
			return -1; // вовзращаем -1 (т.е. ошибку)
		iNoQitF++;
	}
	while (!TA.eof()) { // считаем сколько строк в файле ответов
		TA.getline(pBuffer, BUFFER - 1);
		if (pBuffer == NULL) // если строка пустая
			return -1; // вовзращаем -1 (т.е. ошибку)
		iNoAitF++;
	}

	DecryptAKF(NULL, &iNoAKitF);

	free(pBuffer); // освобождаем память

	if (iNoQitF != iNoAitF || iNoQitF != iNoAKitF) // если количества вопросов, ответов и ключей не совпадают
		return -1; // выводим -1
	return iNoQitF; // выводим количество вопросов
}