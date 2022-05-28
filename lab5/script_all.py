from faker import Faker
import random
import requests
import json
import urllib.request

import time

def str_time_prop(start, end, time_format, prop):
    """Get a time at a proportion of a range of two formatted times.

    start and end should be strings specifying times formatted in the
    given format (strftime-style), giving an interval [start, end].
    prop specifies how a proportion of the interval to be taken after
    start.  The returned time will be in the specified format.
    """

    stime = time.mktime(time.strptime(start, time_format))
    etime = time.mktime(time.strptime(end, time_format))

    ptime = stime + prop * (etime - stime)

    return time.strftime(time_format, time.localtime(ptime))


def random_date(start, end, prop):
    return str_time_prop(start, end, '%d.%m.%Y', prop)
    
fake = Faker('ru_RU')
working_time = ['10:00-22:00', '00:00-00:00', '09:00-21:00', '09:00-22:00', '09:00-23:00',
'08:00-21:00', '08:00-22:00', '08:00-22:30', '08:30-22:00', '08:00-23:00', '08:00-00:00',
'08:30-20:00', '10:00-23:00', '10:00-20:00', '10:00-21:00', '07:00-20:00', '07:00-19:00',
'07:00-21:00', '07:45-20:45', '07:00-23:00']
names = ["5+","Аве","Авиценна","Айболит","Аймед","Алия","Анкор","Аптека доброго дня","Аптека Пастера","Аптека топовых цен","Аптека экономных людей","Аптекарь","Асаки-Фарма","АСНА","Беролина","Валентина","Ваш доктор","Ваше здоровье","Векфарм","Вита","Виталюкс","Витамакс","Витафарм","Витрум","Ганнеман","Горфарма","Губернский лекарь","Дарьяна","Диалог","Диасфарм","Добрый доктор","Доктор Айболит","Доктор Алвик","Доктор Н","Доктор Столетов","Евромед","Евросервис","Еврофарм","Желаем здоровья","Живая аптека","Живая капля","Живика","Живы-здоровы","Забота и здоровье","Заботливая аптека","Здоров.ру","Здоровея","Здоровые люди","Здоровый город","Здоровье","ЗдравЗона","Знахарь","Имплозия","Инфолек","Лавка жизни","Лавка здоровья","Ладушка","Лапушка","Лекарь","ЛекОптТорг","Лекрус","Линия жизни","Люксфарма","Маяк","Мебиус","Медиал","Медицина для Вас","Медпроф","Медуника","Медуница","Мелодия здоровья","Мир здоровья","Мицар-Н","Народная аптека","Наша аптека","Невис","Неофарм","Ника-Фарм","Озерки","Омега","Онфарм","Планета здоровья","Полимед","Полифарма","Просто аптека","Радуга","Рациола","Ригла","Родник здоровья","Ромашка","Сальвэ","Самсон-Фарма","Семейная аптека","Сердечко","Сиблек","Скиф","СОБИ-Фарм","Советская аптека","Солнышко","СоюзАптека","Стар и млад","Статим","Сто рецептов","Столетник","Столица-медикл","Страна здоровья","Твой доктор","Терра Вита","Трика","Троица","Тутаптека","Унция","Фармадар","Фармакор","Фармация","Фармшоп","Феерия","Фиалка","Флория","Формула здоровья","Форте","Целитель","Я здоров","Ясса","120 на 80","36,6","А5","Аптека низких цен","Белый лотос","Будь здоров!","ГлавАптека","Горздрав","Губернские аптеки","Дежурные аптеки","Зеленая аптека","Классика","Кремлевская аптека","Лекарня","Леко","Медторг","Микстурка","Не болей","Неболейка","Ноль-боль","Норма","Опека","Панацея","Первая помощь","Старый лекарь","Столички","Таблетка","Таблеточка","Фармакопейка","Хорошая аптека"]
sp = ['Детских лекарственных средств', 'Матери и ребенка', 'Гериатрическая', 'Гомеопатическая', 'Лекарственных растений']
dph = {}
da = {}
with open('lab3.1_insert_1.sql', 'w+') as f:
	f.write('INSERT INTO pharmacies ("name", "specialization", "contact information") VALUES')
	for i in range(1000000):
		name = random.choice(names)
		addr = fake.address()
		f.write('\n(' + "'" 
		+ name + "',\n" + random.choice(["'" + random.choice(sp) + "'", 'NULL']) + ",\n" +
		"'{ " + '"address"' + ': "' + addr + '",' + 
		'"telephone"' + ': "' + fake.phone_number() + '",' + 
		'"working hours"' + ': "' + random.choice(working_time) + '"}' + "');"+ '\n')
		dph[i] = name
		da[i] = addr
		
S = requests.Session()

URL = "https://ru.wikipedia.org/w/api.php"
PAGES = []
PARAMS = {
    "action": "query",
    "cmtitle": "Категория:Лекарственные средства по алфавиту",
    "cmlimit": "500",
    "list": "categorymembers",
    "format": "json"
}

R = S.get(url=URL, params=PARAMS)
DATA = R.json()
PAGES += DATA['query']["categorymembers"]

PARAMS = {
    "action": "query",
    "cmtitle": "Категория:Лекарственные средства по алфавиту",
    "cmcontinue": DATA['continue']["cmcontinue"],
    "cmlimit": "500",
    "list": "categorymembers",
    "format": "json"
}

R = S.get(url=URL, params=PARAMS)
DATA = R.json()
PAGES += DATA['query']["categorymembers"]

PARAMS = {
    "action": "query",
    "cmtitle": "Категория:Лекарственные средства по алфавиту",
    "cmcontinue": DATA['continue']["cmcontinue"],
    "cmlimit": "500",
    "list": "categorymembers",
    "format": "json"
}

R = S.get(url=URL, params=PARAMS)
DATA = R.json()
PAGES += DATA['query']["categorymembers"]

PARAMS = {
    "action": "query",
    "cmtitle": "Категория:Лекарственные средства по алфавиту",
    "cmcontinue": DATA['continue']["cmcontinue"],
    "cmlimit": "500",
    "list": "categorymembers",
    "format": "json"
}

R = S.get(url=URL, params=PARAMS)
DATA = R.json()
PAGES += DATA['query']["categorymembers"]

PARAMS = {
    "action": "query",
    "cmtitle": "Категория:Лекарственные средства по алфавиту",
    "cmcontinue": DATA['continue']["cmcontinue"],
    "cmlimit": "500",
    "list": "categorymembers",
    "format": "json"
}

R = S.get(url=URL, params=PARAMS)
DATA = R.json()
PAGES += DATA['query']["categorymembers"]

PARAMS = {
    "action": "query",
    "cmtitle": "Категория:Лекарственные средства по алфавиту",
    "cmcontinue": DATA['continue']["cmcontinue"],
    "cmlimit": "500",
    "list": "categorymembers",
    "format": "json"
}

R = S.get(url=URL, params=PARAMS)
DATA = R.json()
PAGES += DATA['query']["categorymembers"]

list_r = []
list_g = []
list_ind = []
list_cind = []
list_w = []
list_s = []

for page in PAGES:
    list_r.append(page['title'])
# список всех лекарств

with open("text1.txt") as file1:
	for line in file1:
		list_g.append(line.replace('\n',''))

headers = {
    'Content-Type': 'application/json',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4) AppleWebKit/605.1.15 '
                  '(KHTML, like Gecko) Version/14.1.1 Safari/605.1.15',
    'Origin': 'https://yandex.ru',
    'Referer': 'https://yandex.ru/',
}


API_URL = 'https://zeapi.yandex.net/lab/api/yalm/text3'
number = 0
for i in range(0, len(list_r), 2):
	payload = {"query": "Медицинские показания" + list_r[i] + ":", "intro": 0, "filter": 1}
	params = json.dumps(payload).encode('utf8')
	req = urllib.request.Request(API_URL, data=params, headers=headers)
	response = urllib.request.urlopen(req)
	tr = response.read().decode('unicode-escape')

	list_ind.append(tr[tr.find('text') + 6::].replace('}', '').replace('"', '').replace("'", ''))

	payload = {"query": "Медицинские противопоказания" + list_r[i] + ":", "intro": 0, "filter": 1}
	params = json.dumps(payload).encode('utf8')
	req = urllib.request.Request(API_URL, data=params, headers=headers)
	response = urllib.request.urlopen(req)
	tr = response.read().decode('unicode-escape')

	list_cind.append(tr[tr.find('text') + 6::].replace('}', '').replace('"', '').replace("'", ''))

	payload = {"query": "Способ применения" + list_r[i] + ":", "intro": 0, "filter": 1}
	params = json.dumps(payload).encode('utf8')
	req = urllib.request.Request(API_URL, data=params, headers=headers)
	response = urllib.request.urlopen(req)
	tr = response.read().decode('unicode-escape')

	list_w.append(tr[tr.find('text') + 6::].replace('}', '').replace('"', '').replace("'", ''))

	payload = {"query": "Побочные эффекты" + list_r[i] + ":", "intro": 0, "filter": 1}
	params = json.dumps(payload).encode('utf8')
	req = urllib.request.Request(API_URL, data=params, headers=headers)
	response = urllib.request.urlopen(req)
	tr = response.read().decode('unicode-escape')

	list_s.append(tr[tr.find('text') + 6::].replace('}', '').replace('"', '').replace("'", ''))
	number += 1
	print('i generate', number)

dm = {}
types = ['Гели', 'Сиропы', 'Спреи', 'Смеси измельченного растительного сырья', 'Экстракты', 'Капсулы', 'Настойки', 'Суппозитории (свечи)', 'Пасты', 'Пилюли', 'Растворы', 'Порошки', 'Таблетки']
with open('lab3.1_insert_2.sql', 'w+') as f:
	for i in range(1000000):
		print('i am on step', i, 'check 1')
		num = random.randint(0,1270)
		f.write('INSERT INTO medecines ("commercial_name", "international_nonproprietary_name", "indications", "contraindications", "drug_route", "need_for_a_recipe", "side_effects", "group_of_medecines", "manufacturer", "pack_info") VALUES (\n' + 
		"'" + list_r[num] + "',\n" +
		"'" + list_r[num] + "',\n" +
		"'" + list_ind[num] + "',\n" +
		"'" + list_cind[num] + "',\n" +
		"'" + list_w[num] + "',\n" +
		random.choice(['true', 'false']) + ",\n" +
		"'" + list_s[num] + "',\n" +
		"'{" + '"' + random.choice(list_g) + random.choice(['","' + random.choice(list_g), '']) + '"' + "}',\n" +
		"'" + fake.company() + "',\n" +
		"'{ " + '"type"' + ': "' + random.choice(types) + '",' + 
		'"weight_mg"' + ': "' + str(random.randint(0,500)) + '",' + 
		'"number"' + ': "' + str(random.randint(0,500)) + '"}' + "');"+ '\n')
		dm[i] = {}

    
with open('lab3.1_insert_3.sql', 'w+') as f:
	for j in range(10000):
		print('i am on step', j, 'check 2')
		f.write('INSERT INTO availability ("id_ph", "id_mod", "prev shipment information", "price_rub", "quantity", "shipment information", "recording_date", "med_name", "ph_name", "ph_address") VALUES')
		for i in range(9999):
			quan = 5000 + random.randint(0,1000)
			id_m = str(random.randint(0,1000000))
			id_ph = str(random.randint(0,1000000))
			f.write('\n(' + 
			id_ph + ",\n" +
			id_m + ",\n" +
			"'{ " + '"date"' + ': "' + random_date("01.01.2019", "01.11.2021", random.random()) + '",' + 
			'"quantity"' + ': "' + str(quan) + '",' + 
			'"expiration date"' + ': "' + random_date("01.01.2022", "01.01.2024", random.random()) + '"}' +  "',\n" +
			str(random.randint(0,5000)) + ",\n" +
			str(quan - random.randint(0,5000)) + ",\n" +
			"'{ " + '"date"' + ': "' + random_date("02.11.2021", "01.01.2024", random.random()) + '",' + 
			'"quantity"' + ': "' + str(random.randint(0,5000)) + '",' + 
			'"expiration date"' + ': "' + random_date("01.01.2024", "01.01.2026", random.random()) + '"}' + "'," +
			'current_date' + ",\n" +
			"'" + str(dm[int(id_m)]) + "',\n" +
			"'" + str(dph[int(id_ph)]) + "',\n" +
			"'" + str(da[int(id_ph)]) + "'" +
			"),")
		quan = 5000 + random.randint(0,1000)
		id_m = str(random.randint(0,1000000))
		id_ph = str(random.randint(0,1000000))
		f.write('\n(' + 
		id_ph + ",\n" +
		id_m + ",\n" +
		"'{ " + '"date"' + ': "' + random_date("01.01.2019", "01.11.2021", random.random()) + '",' + 
		'"quantity"' + ': "' + str(quan) + '",' + 
		'"expiration date"' + ': "' + random_date("01.01.2022", "01.01.2024", random.random()) + '"}' +  "',\n" +
		str(random.randint(0,5000)) + ",\n" +
		str(quan - random.randint(0,5000)) + ",\n" +
		"'{ " + '"date"' + ': "' + random_date("02.11.2021", "01.01.2024", random.random()) + '",' + 
		'"quantity"' + ': "' + str(random.randint(0,5000)) + '",' + 
		'"expiration date"' + ': "' + random_date("01.01.2024", "01.01.2026", random.random()) + '"}' + "'," +
		'current_date' + ",\n" +
		"'" + str(dm[int(id_m)]) + "',\n" +
		"'" + str(dph[int(id_ph)]) + "',\n" +
		"'" + str(da[int(id_ph)]) + "'" +
		");\n")
