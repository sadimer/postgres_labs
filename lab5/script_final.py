import random
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
    
with open('lab3.1_insert_3.sql', 'w+') as f:
	for j in range(2):
		print('i am on step', j)
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
			'(SELECT "commercial_name" FROM medecines WHERE id_med = ' + id_m + '),\n' + 
			'(SELECT "name" FROM pharmacies WHERE id_ph = ' + id_ph + '),\n' +
			'(SELECT "contact information" ->> ' + "'address'" + ' FROM pharmacies WHERE id_ph = ' + id_ph + ')' +
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
		'(SELECT "commercial_name" FROM medecines WHERE id_med = ' + id_m + '),\n' + 
		'(SELECT "name" FROM pharmacies WHERE id_ph = ' + id_ph + '),\n' +
		'(SELECT "contact information" ->> ' + "'address'" + ' FROM pharmacies WHERE id_ph = ' + id_ph + ')' +
		");\n")

