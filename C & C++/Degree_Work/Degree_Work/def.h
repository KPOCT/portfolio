#define KEYCODE_ESC 27 // Код клавиши Escape

char sMenuNames[][32] = // Массив с названиями меню
{
	"Главное меню",

	"Лекарства",
	"Диагнозы",
	"Составы лекарств",
	"Противопоказания",
	"Изготовители",
};

#define MENU_KEY_1 1 // Константы клавиш
#define MENU_KEY_2 2
#define MENU_KEY_3 3
#define MENU_KEY_4 4
#define MENU_KEY_5 5
#define MENU_KEY_6 6
#define MENU_KEY_7 7
#define MENU_KEY_8 8
#define MENU_KEY_9 9
#define MENU_KEY_0 0

#define ITEMS_PER_PAGE 7 // Число пунктов на 1 страницу

#define add_key(bit, bit_summ) (bit_summ |= (1 << bit)) // Добавляет бит (bit) к бит. сумме (bit_summ)
#define sub_key(bit, bit_summ) (bit_summ &= ~(1 << bit)) // Удаляет бит (bit) из бит. суммы (bit_summ)
#define key_valid(bit, bit_summ) (bit_summ & (1 << bit)) // Проверяет, есть ли бит (bit) в бит. сумме (bit_summ)

enum Menus // Перечисление идентификаторов меню
{
	mMedications = 0,
	mDiagnosis,
	mCompositions,
	mContraindications,
	mManufacturers
};

enum ConsoleColor // Перечисление цветов
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

#define SetErrorTextColor() SetConsoleTextAttribute(hConsoleHandle, LightRed | Black) // Для ошибок
#define SetNumberTextColor() SetConsoleTextAttribute(hConsoleHandle, LightRed | Black) // Для номеров пунктов
#define SetHeaderTextColor() SetConsoleTextAttribute(hConsoleHandle, LightCyan | Black) // Для заголовка
#define SetStandardTextColor() SetConsoleTextAttribute(hConsoleHandle, LightGray | Black) // Стандартный цвет
#define SetDisableTextColor() SetConsoleTextAttribute(hConsoleHandle, DarkGray | Black) // Тёмносерый цвет
#define SetSeparatorColor() SetConsoleTextAttribute(hConsoleHandle, Magenta | Black) // Фиолетовый для сепаратора (разделителя)

/* Получаем размерность массива с неявной (опущенной) размерностью */
template<typename T, size_t n>
inline size_t arraySize(const T (&arr)[n])
{
    return n;
}
/* Получаем размер массива с учетом выделения места под нуль-терминальный символ */
#define charsmax(arr) (arraySize(arr) - 1)