int OpenDll(daoc pLibName, daoc pFuncName)
	{
			daoc pBuffer = (daoc)malloc(BUFSIZ * sizeof(char));
			DLL hLibName; // ���������� ����������� ���������� �������������
			*pBuffer = NULL; // ���� ����������� �����
			strcat(pBuffer, DLLS_DIR); // �������� �������� ����� �������� ����������
			strcat(pBuffer, pLibName); // �������� �������� ������ ����������
			hLibName = LoadLibrary(pBuffer); // ��������� ����������
			if (!hLibName)
			{
				*pBuffer = NULL;
				// ��������� ��������� ��� MessageBox
				strcat(pBuffer, "���������� ");
				strcat(pBuffer, DLLS_DIR);
				strcat(pBuffer, pLibName);
				strcat(pBuffer, " �� �������!");
				MessageBox(NULL, pBuffer, "������ �������� ����������", MB_OK | MB_ICONERROR);
				free(pBuffer); // ����������� �����
				return hLibName;
			}
			for
			(
				// ���������� ���������� �� �������, ���������� �� ����������
				int (*Func)(......???????); // �������� �������������� �������
				// ������� GetProcAddress �������� ������ �-�� � ����������� �� ����������,
				// GetProcAddress ���������� ���������� far-���������!
				// ���������� � ��. ������� ���������� ��������� ���,
				// �� ���� �������� ��������, ��� ����� ������������� ��� ������.
				(FARPROC &)Auth = GetProcAddress(hLibName, AUTH);
				if (!Auth)
				{
					*pBuffer = NULL;
					// ��������� ��������� ��� MessageBox
					strcat(pBuffer, "� ���������� �");
					strcat(pBuffer, pLibName);
					strcat(pBuffer, "� �� ������� ������� �");
					strcat(pBuffer, pFuncName);
					strcat(pBuffer, "�!");
					MessageBox(NULL, pBuffer, "������ ��������� � �������", MB_OK | MB_ICONERROR);
					free(pBuffer); // ����������� �����
					exit(4); // ��������� ��������� � ����� 4
				}
			}
	}
	/* � �����, ���� ���� ���������� ����������, ������ �����: */
	OpenDll(AUTH_DLL, Auth);
	if (!OpenDll)	exit(3);

	/* ���-�� ��� */