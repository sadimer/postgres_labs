import json
import urllib.request

headers = {
    'Content-Type': 'application/json',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4) AppleWebKit/605.1.15 '
                  '(KHTML, like Gecko) Version/14.1.1 Safari/605.1.15',
    'Origin': 'https://yandex.ru',
    'Referer': 'https://yandex.ru/',
}


API_URL = 'https://zeapi.yandex.net/lab/api/yalm/text3'
payload = {"query": "Медицинские показания:" , "intro": 0, "filter": 1}
params = json.dumps(payload).encode('utf8')
req = urllib.request.Request(API_URL, data=params, headers=headers)
response = urllib.request.urlopen(req)
tr = response.read().decode('unicode-escape')

list_ind = []
list_ind.append(tr[tr.find('text') + 6::].replace('}', ''))
print(list_ind)
