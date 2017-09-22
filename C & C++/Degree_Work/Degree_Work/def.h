#define KEYCODE_ESC 27 // ��� ������� Escape

char sMenuNames[][32] = // ������ � ���������� ����
{
	"������� ����",

	"���������",
	"��������",
	"������� ��������",
	"����������������",
	"������������",
};

#define MENU_KEY_1 1 // ��������� ������
#define MENU_KEY_2 2
#define MENU_KEY_3 3
#define MENU_KEY_4 4
#define MENU_KEY_5 5
#define MENU_KEY_6 6
#define MENU_KEY_7 7
#define MENU_KEY_8 8
#define MENU_KEY_9 9
#define MENU_KEY_0 0

#define ITEMS_PER_PAGE 7 // ����� ������� �� 1 ��������

#define add_key(bit, bit_summ) (bit_summ |= (1 << bit)) // ��������� ��� (bit) � ���. ����� (bit_summ)
#define sub_key(bit, bit_summ) (bit_summ &= ~(1 << bit)) // ������� ��� (bit) �� ���. ����� (bit_summ)
#define key_valid(bit, bit_summ) (bit_summ & (1 << bit)) // ���������, ���� �� ��� (bit) � ���. ����� (bit_summ)

enum Menus // ������������ ��������������� ����
{
	mMedications = 0,
	mDiagnosis,
	mCompositions,
	mContraindications,
	mManufacturers
};

enum ConsoleColor // ������������ ������
{
	Black = 0,
	Blue,
	Green,
	Cyan,
	Red,
	Magenta,
	Brown,
	LightGray,
	DarkGray,
	LightBlue,
	LightGreen,
	LightCyan,
	LightRed,
	LightMagenta,
	Yellow,
	White
};

#define SetErrorTextColor() SetConsoleTextAttribute(hConsoleHandle, LightRed | Black) // ��� ������
#define SetNumberTextColor() SetConsoleTextAttribute(hConsoleHandle, LightRed | Black) // ��� ������� �������
#define SetHeaderTextColor() SetConsoleTextAttribute(hConsoleHandle, LightCyan | Black) // ��� ���������
#define SetStandardTextColor() SetConsoleTextAttribute(hConsoleHandle, LightGray | Black) // ����������� ����
#define SetDisableTextColor() SetConsoleTextAttribute(hConsoleHandle, DarkGray | Black) // Ҹ�������� ����
#define SetSeparatorColor() SetConsoleTextAttribute(hConsoleHandle, Magenta | Black) // ���������� ��� ���������� (�����������)

/* �������� ����������� ������� � ������� (���������) ������������ */
template<typename T, size_t n>
inline size_t arraySize(const T (&arr)[n])
{
    return n;
}
/* �������� ������ ������� � ������ ��������� ����� ��� ����-������������ ������ */
#define charsmax(arr) (arraySize(arr) - 1)