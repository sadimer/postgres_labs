import requests
import json
import urllib.request
from faker import Faker
import random

fake = Faker('ru_RU')

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

	list_ind.append(tr[tr.find('text') + 6::].replace('}', ''))

	payload = {"query": "Медицинские противопоказания" + list_r[i] + ":", "intro": 0, "filter": 1}
	params = json.dumps(payload).encode('utf8')
	req = urllib.request.Request(API_URL, data=params, headers=headers)
	response = urllib.request.urlopen(req)
	tr = response.read().decode('unicode-escape')

	list_cind.append(tr[tr.find('text') + 6::].replace('}', ''))

	payload = {"query": "Способ применения" + list_r[i] + ":", "intro": 0, "filter": 1}
	params = json.dumps(payload).encode('utf8')
	req = urllib.request.Request(API_URL, data=params, headers=headers)
	response = urllib.request.urlopen(req)
	tr = response.read().decode('unicode-escape')

	list_w.append(tr[tr.find('text') + 6::].replace('}', ''))

	payload = {"query": "Побочные эффекты" + list_r[i] + ":", "intro": 0, "filter": 1}
	params = json.dumps(payload).encode('utf8')
	req = urllib.request.Request(API_URL, data=params, headers=headers)
	response = urllib.request.urlopen(req)
	tr = response.read().decode('unicode-escape')

	list_s.append(tr[tr.find('text') + 6::].replace('}', ''))
	number += 1
	print('i generate', number)

types = ['Гели', 'Сиропы', 'Спреи', 'Смеси измельченного растительного сырья', 'Экстракты', 'Капсулы', 'Настойки', 'Суппозитории (свечи)', 'Пасты', 'Пилюли', 'Растворы', 'Порошки', 'Таблетки']
with open('lab3.1_insert_2.sql', 'w+') as f:
	for i in range(1000000):
		print('i am on step', i)
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
