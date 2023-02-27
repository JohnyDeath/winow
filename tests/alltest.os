#Использовать autumn
#Использовать ".."
#Использовать asserts

Перем Сервер;

Процедура ПередЗапускомТеста() Экспорт	
	ВключитьСервер();
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
КонецПроцедуры

Процедура ВключитьСервер() 
	
	Если Сервер = Неопределено Тогда
		Сервер = Новый Поделка();
		ФоновыеЗадания.Выполнить(Сервер, "ЗапуститьПриложение");
		// Подождем что бы сервер успел запустится и проинициализироваться.
		Приостановить(1000);
		Настройки = Сервер.НайтиЖелудь("Настройки");
		Настройки.ЗадержкаПередЗакрытиемСокета = 150;
	КонецЕсли;

КонецПроцедуры

Функция ГетЗапрос(АдресТеста, Заголовки = Неопределено)
	Соединение = Новый HTTPСоединение("http://localhost",3333,,,,5);
	Запрос = Новый HTTPЗапрос(СтрШаблон("/tests/%1", АдресТеста));
	Если Не Заголовки = Неопределено Тогда
		Запрос.Заголовки = Заголовки;
	КонецЕсли;
	Ответ = Соединение.Получить(Запрос);
	Возврат Ответ;
КонецФункции

Функция ПостЗапросТелоИзСтроки(АдресТеста, ТелоЗапроса, Заголовки = Неопределено)
	Соединение = Новый HTTPСоединение("http://localhost",3333,,,,5);
	Запрос = Новый HTTPЗапрос(СтрШаблон("/tests/%1", АдресТеста));
	Если Не Заголовки = Неопределено Тогда
		Запрос.Заголовки = Заголовки;
	КонецЕсли;
	Запрос.УстановитьТелоИзСтроки(ТелоЗапроса, КодировкаТекста.UTF8);
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	Возврат Ответ;
КонецФункции

&Тест
Процедура Должен_ПроверитьЗапускСервере() Экспорт

	// Дано
	АдресТеста = "checkup";

	// Когда
	Ответ = ГетЗапрос(АдресТеста);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьОбработкуГетПараметров() Экспорт

	// Дано
	АдресТеста = "getparams?animal1=Кошка&animal2=Собака";

	// Когда
	Ответ = ГетЗапрос(АдресТеста);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку()).Равно("Кошка И Собака");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьОбработкуУпорядоченныхГетПараметров() Экспорт

	// Дано
	АдресТеста = "getorderedparams/Кошка/Собака";

	// Когда
	Ответ = ГетЗапрос(АдресТеста);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку()).Равно("Кошка И Собака");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьОбработкуПостЗапроса() Экспорт

	// Дано
	АдресТеста = "postparams";
	ТелоЗапроса = "animal1=Кошка&animal2=Собака";

	// Когда
	Ответ = ПостЗапросТелоИзСтроки(АдресТеста, ТелоЗапроса);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку()).Равно("Кошка И Собака");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьРаботуКук() Экспорт

	// Дано
	ЗначениеКуки = Строка(Новый УникальныйИдентификатор());
	АдресТеста = СтрШаблон("setcookie?pechenka=%1", ЗначениеКуки);

	// Когда
	Ответ = ГетЗапрос(АдресТеста);
	ТекстКук = Ответ.Заголовки.Получить("Set-Cookie");


	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(СтрНайти(ТекстКук, ЗначениеКуки)).Больше(0);

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьРаботуСессий() Экспорт

	// Дано
	Значение = Строка(Новый УникальныйИдентификатор());
	АдресУстановки = СтрШаблон("setsessiondata?userdata=%1", Значение);
	АдресПолучения = "readsessiondata";

	// Когда
	ОтветУстановки = ГетЗапрос(АдресУстановки);
	ТекстКук = ОтветУстановки.Заголовки.Получить("Set-Cookie");
	МеткаСессии = "SessionID=";
	НачалоИдСессии = СтрНайти(ТекстКук,МеткаСессии);
	КонецИдСесии = СтрНайти(ТекстКук,";",,НачалоИдСессии);
	ИдСессии = СтрЗаменить(Сред(ТекстКук, НачалоИдСессии, КонецИдСесии - НачалоИдСессии), МеткаСессии, "");

	Заголовки = Новый Соответствие();
	Заголовки.Вставить("Cookie", "SessionID=" + ИдСессии);
	ОтветПолучения = ГетЗапрос(АдресПолучения, Заголовки);

	// Тогда
	Ожидаем.Что(ОтветУстановки.КодСостояния).Равно(200);
	Ожидаем.Что(ОтветПолучения.КодСостояния).Равно(200);
	Ожидаем.Что(ОтветПолучения.ПолучитьТелоКакСтроку()).Равно(Значение);

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьПолучениеФайлаССервера() Экспорт

	// Дано
	ЗначениеКуки = Строка(Новый УникальныйИдентификатор());
	АдресТеста = "textfile.txt";

	// Когда
	Ответ = ГетЗапрос(АдресТеста);
	ДДТело = Ответ.ПолучитьТелоКакДвоичныеДанные();
	ТекстТело = ПолучитьСтрокуИзДвоичныхДанных(ДДТело);

	Чтение = Новый ЧтениеТекста();
	Чтение.Открыть("./tests/app/files/textfile.txt", КодировкаТекста.UTF8);
	ТекстИзФайла = Чтение.Прочитать();
	Чтение.Закрыть();


	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(ТекстТело).Равно(ТекстИзФайла);

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьОграничениеДоступа() Экспорт

	// Дано
	АдресТеста = "user";
	Логипас = "Пользователь:111";
	Заголовки = Новый Соответствие();
	ХешЛогипасов = Base64Строка(ПолучитьДвоичныеДанныеИзСтроки(Логипас));
	Заголовки.Вставить("Authorization", "Basic " + ХешЛогипасов);

	ЗаголовкиНеКорректные = Новый Соответствие();
	ХешЛогипасовНеКорректные = Base64Строка(ПолучитьДвоичныеДанныеИзСтроки(Логипас+"1"));
	ЗаголовкиНеКорректные.Вставить("Authorization", "Basic " + ХешЛогипасовНеКорректные);


	// Когда
	ОтветЗапросАвторизации = ГетЗапрос(АдресТеста);
	ОтветАвторизован = ГетЗапрос(АдресТеста, Заголовки);
	ОтветНеАвторизован = ГетЗапрос(АдресТеста, ЗаголовкиНеКорректные);

	// Тогда
	Ожидаем.Что(ОтветЗапросАвторизации.КодСостояния).Равно(401);
	Ожидаем.Что(ОтветАвторизован.КодСостояния).Равно(200);
	Ожидаем.Что(ОтветНеАвторизован.КодСостояния).Равно(401);

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьРаботуШаблонов() Экспорт

	// Дано
	АдресТеста = "view/1";

	// Когда
	Ответ = ГетЗапрос(АдресТеста);

	// Тогда
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8)).Равно("Заголовок 1 Текст 2 Вложенный текст 3 4 конец");
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	
КонецПроцедуры

&Тест
Процедура Должен_ПроверитьШаблонныеУРЛЫ() Экспорт

	// Дано
	АдресТеста = "templateuri/Малинка/Желудь/Картошка";

	// Когда
	Ответ = ГетЗапрос(АдресТеста);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку()).Равно("Малинка Желудь Картошка");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьШаблонныеУРЛЫСложение() Экспорт

	// Дано
	АдресТеста = "calc/plus/1/2";

	// Когда
	Ответ = ГетЗапрос(АдресТеста);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку()).Равно("3");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьШаблонныеУРЛЫВычитание() Экспорт

	// Дано
	АдресТеста = "calc/minus/3/2";

	// Когда
	Ответ = ГетЗапрос(АдресТеста);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку()).Равно("1");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьШаблонныеУРЛУмножение() Экспорт

	// Дано
	АдресТеста = "calc/3/multiply/2";

	// Когда
	Ответ = ГетЗапрос(АдресТеста);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку()).Равно("6");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьШаблонныеУРЛЫДеление() Экспорт

	// Дано
	АдресТеста = "calc/6/devide/2";

	// Когда
	Ответ = ГетЗапрос(АдресТеста);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку()).Равно("3");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьОбработкуГетПараметровПоИмени() Экспорт

	// Дано
	АдресТеста = "getparamsbyname?ИмяКошки=Мурка&ИмяСобаки=Жучка";

	// Когда
	Ответ = ГетЗапрос(АдресТеста);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку()).Равно("ИмяКошки=Мурка И ИмяСобаки=Жучка");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьОбработкуПостЗапросаКакОбъект() Экспорт

	// Дано
	АдресТеста = "postjsonbody";
	ТелоЗапроса = "{""Имя"": ""Иван"", ""Фамилия"": ""Пупкин""}";
	Заголовки = Новый Соответствие();
	Заголовки.Вставить("Content-Type", "application/json");

	// Когда
	Ответ = ПостЗапросТелоИзСтроки(АдресТеста, ТелоЗапроса, Заголовки);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку()).Равно("Иван Пупкин");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьОбработкуПостЗапросаКакФорма() Экспорт

	// Дано
	АдресТеста = "postformbody";
	ТелоЗапроса = "Имя=ivan&Фамилия=pupkin";
	Заголовки = Новый Соответствие();
	Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");

	// Когда
	Ответ = ПостЗапросТелоИзСтроки(АдресТеста, ТелоЗапроса, Заголовки);

	// Тогда
	Ожидаем.Что(Ответ.КодСостояния).Равно(200);
	Ожидаем.Что(Ответ.ПолучитьТелоКакСтроку()).Равно("ivan pupkin");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьРукопожатиеВебСокета() Экспорт

	// Дано
	Клиент = Новый TCPСоединение("localhost", 3333);

	ТекстЗапроса = "GET / HTTP/1.1
					|Host: localhost:3333
					|User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:107.0) Gecko/20100101 Firefox/107.0
					|Accept: */*
					|Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3
					|Accept-Encoding: gzip, deflate, br
					|Sec-WebSocket-Version: 13
					|Origin: null
					|Sec-WebSocket-Extensions: permessage-deflate
					|Sec-WebSocket-Key: 8Nm7+HLTwID0n9ABpH5QGA==
					|DNT: 1
					|Connection: keep-alive, Upgrade
					|Sec-Fetch-Dest: websocket
					|Sec-Fetch-Mode: websocket
					|Sec-Fetch-Site: cross-site
					|Pragma: no-cache
					|Cache-Control: no-cache
					|Upgrade: websocket";

	// Когда
	Клиент.ОтправитьСтроку(ТекстЗапроса);
	Ответ = Клиент.ПрочитатьСтроку();
	Приостановить(100);

	// Тогда

	Ожидаем.Что(Клиент.Активно, "Соединение активно").Равно(Истина);
	Ожидаем.Что(Ответ, "ответ содержит хендшейк").Содержит("Sec-WebSocket-Accept: hgGtYQoki4w7EXHvdkxAVu61+PI=");
	Ожидаем.Что(Ответ, "ответ содержит код 101").Содержит("HTTP/1.1 101");
	
КонецПроцедуры

// &Тест
Процедура Должен_ПроверитьВебСокета() Экспорт

	// Дано
	Клиент = Новый TCPСоединение("localhost", 3333);
	// Клиент.ТаймаутЧтения = 1000;

	Запрос1 = Новый ДвоичныеДанные("tests/features/server1");
	Запрос2 = Новый ДвоичныеДанные("tests/features/server2");

	// Результат1 = Новый ДвоичныеДанные("tests/features/client1");
	Результат2 = Новый ДвоичныеДанные("tests/features/client2");

	// Когда
	Клиент.ОтправитьДвоичныеДанные(Запрос1);
	Ответ1 = Клиент.ПрочитатьСтроку();

	Приостановить(100);

	Клиент.ОтправитьДвоичныеДанные(Запрос2);
	Ответ2 = Клиент.ПрочитатьДвоичныеДанные();

	// Тогда

	Ожидаем.Что(Клиент.Активно, "Соединение активно").Равно(Истина);
	Ожидаем.Что(Ответ1, "ответ содержит хендшейк").Содержит("Sec-WebSocket-Accept: LEHPu4/qNukG+0hW+UjpnJTeoc8=");
	Ожидаем.Что(Ответ1, "ответ содержит код 101").Содержит("HTTP/1.1 101");
	Ожидаем.Что(Ответ2, "Ответ веб сокета корректный").Равно(Результат2);
	
КонецПроцедуры

&Тест
Процедура Должен_ПроверитьРаспаковкуСообщенийВебСокета() Экспорт
	// Дано
	Шифровальщик = Новый ШифрованиеВебСокета();

	Каталог = ТекущийСценарий().Каталог;
	
	Запрос2 = Новый ДвоичныеДанные(ОбъединитьПути(Каталог, "features/server2"));

	// Когда
	Сообщение = Шифровальщик.РаспаковатьСообщение(Запрос2);

	// Тогда
	Ожидаем.Что(Сообщение, "Распаковка удачно").Равно("hello");

КонецПроцедуры

&Тест
Процедура Должен_ПроверитьУпаковкуСообщенийВебСокета() Экспорт
	// Дано
	Шифровальщик = Новый ШифрованиеВебСокета();

	Каталог = ТекущийСценарий().Каталог;
	
	УпакованноеСообщение = Новый ДвоичныеДанные(ОбъединитьПути(Каталог, "features/client2"));

	// Когда
	Сообщение = Шифровальщик.ЗапаковатьСообщениеТекстовоеСообщение("hello 1");

	// Тогда
	Ожидаем.Что(Сообщение, "Упаковка удачно").Равно(УпакованноеСообщение);

КонецПроцедуры

&Тест
Процедура Должен_ПолучениеСоединенийСотборами() Экспорт
	
	// Дано
	СоединенияВебСокетов = Новый СоединенияВебСокетов();
	Рефлектор = Новый Рефлектор();
	ПулСоединений = Рефлектор.ПолучитьСвойство(СоединенияВебСокетов, "ПулСоединений");

	НовоеСоединение = ПулСоединений.Добавить();
	НовоеСоединение.Идентификатор = "1";
	НовоеСоединение.Топик = "1";

	НовоеСоединение = ПулСоединений.Добавить();
	НовоеСоединение.Идентификатор = "2";
	НовоеСоединение.Топик = "1";

	НовоеСоединение = ПулСоединений.Добавить();
	НовоеСоединение.Идентификатор = "3";
	НовоеСоединение.Топик = "1";

	НовоеСоединение = ПулСоединений.Добавить();
	НовоеСоединение.Идентификатор = "1";
	НовоеСоединение.Топик = "2";

	СписокИдентификаторов = Новый Массив();
	СписокИдентификаторов.Добавить("1");
	СписокИдентификаторов.Добавить("2");

	// Когда

	ВсеСоединения = СоединенияВебСокетов.ПолучитьСоединенияПоТопику("1");

	СоединенияПоСписку = СоединенияВебСокетов.ПолучитьСоединенияПоТопикуСпискуИдентификаторов("1", СписокИдентификаторов);

	СоединенияКроме = СоединенияВебСокетов.ПолучитьСоединенияПоТопикуКромеСпискаИдентификаторов("1", СписокИдентификаторов);

	СоединениеПоИдентификатору = СоединенияВебСокетов.ПолучитьСоединениеПоИдентификатору("1", "1");

	СоединениеНеопределено = СоединенияВебСокетов.ПолучитьСоединениеПоИдентификатору("1", "9");

	// Тогда
	Ожидаем.Что(ВсеСоединения.Количество(), "Все соединения").Равно(3);
	Ожидаем.Что(СоединенияПоСписку.Количество(), "Соединения по списку").Равно(2);
	Ожидаем.Что(СоединенияКроме.Количество(), "Соединения кроме").Равно(1);
	Ожидаем.Что(СоединениеПоИдентификатору.Идентификатор, "Конкретное соединение").Равно("1");
	Ожидаем.Что(СоединениеНеопределено, "пустое соединение").Равно(Неопределено);

КонецПроцедуры
