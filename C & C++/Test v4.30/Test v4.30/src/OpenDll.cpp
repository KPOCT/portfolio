int OpenDll(daoc pLibName, daoc pFuncName)
	{
			daoc pBuffer = (daoc)malloc(BUFSIZ * sizeof(char));
			DLL hLibName; // Дескриптор загружаемой библиотеки универсальный
			*pBuffer = NULL; // нуль терминируем буфер
			strcat(pBuffer, DLLS_DIR); // копируем название папки хранения библиотеки
			strcat(pBuffer, pLibName); // копируем название нужной библиотеки
			hLibName = LoadLibrary(pBuffer); // загружаем библиотеку
			if (!hLibName)
			{
				*pBuffer = NULL;
				// Формируем сообщение для MessageBox
				strcat(pBuffer, "Библиотека ");
				strcat(pBuffer, DLLS_DIR);
				strcat(pBuffer, pLibName);
				strcat(pBuffer, " не найдена!");
				MessageBox(NULL, pBuffer, "Ошибка загрузки библиотеки", MB_OK | MB_ICONERROR);
				free(pBuffer); // освобождаем буфер
				return hLibName;
			}
			for
			(
				// Объявление указателей на функции, вызываемой из библиотеки
				int (*Func)(......???????); // Прототип экспортируемой функции
				// Вызовом GetProcAddress получаем адреса ф-ий и присваиваем их указателям,
				// GetProcAddress возвращает бестиповой far-указатель!
				// Существует и др. вариант реализации получения УНФ,
				// но этот попросту понятнее, чем более нагромождённый его аналог.
				(FARPROC &)Auth = GetProcAddress(hLibName, AUTH);
				if (!Auth)
				{
					*pBuffer = NULL;
					// Формируем сообщение для MessageBox
					strcat(pBuffer, "В библиотеке «");
					strcat(pBuffer, pLibName);
					strcat(pBuffer, "» не найдена функция «");
					strcat(pBuffer, pFuncName);
					strcat(pBuffer, "»!");
					MessageBox(NULL, pBuffer, "Ошибка обращения к функции", MB_OK | MB_ICONERROR);
					free(pBuffer); // освобождаем буфер
					exit(4); // закрываем программу с кодом 4
				}
			}
	}
	/* А потом, если надо подгрузить библиотеку, просто пишем: */
	OpenDll(AUTH_DLL, Auth);
	if (!OpenDll)	exit(3);

	/* Как-то так */