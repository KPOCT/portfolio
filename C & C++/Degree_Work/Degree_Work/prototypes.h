int get_key(int);

bool connect_to_db();

void error_db();

void m_main(void);
void mh_main(int);

void menu_create(int, int);
void mh_medications(int, int);
void mh_diagnosis(int, int);
void mh_compositions(int, int);
void mh_contraindications(int, int);
void mh_manufacturers(int, int);

int read_medications();
int read_diagnosis();
int read_compositions();
int read_cntraindications();
int read_manufacturers();