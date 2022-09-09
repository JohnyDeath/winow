#Использовать json

Перем Порт Экспорт;
Перем ИмяХоста Экспорт;
Перем ЗапросВФоновыхЗаданиях Экспорт;
Перем КаталогиСФайлами Экспорт;
Перем КаталогиСПриложениями Экспорт;


&Желудь
Процедура ПриСозданииОбъекта()
	Порт = 3333;
	ИмяХоста = "localhost";
	ЗапросВФоновыхЗаданиях = Истина;
	КаталогиСФайлами = Новый Соответствие();
	КаталогиСПриложениями = Новый Соответствие();
КонецПроцедуры

Процедура ПрочитатьИзФайла(ПутьКФайлу) Экспорт

	НастройкиТекстом = СодержимоеФайла(ПутьКФайлу);

	Если Не ЗначениеЗаполнено(НастройкиТекстом) Тогда
		ВызватьИсключение "Файл настроек не существует, или пуст.";
	КонецЕсли;
	
	Настройки = РаспарситьНастройки(НастройкиТекстом);

	Порт = Настройки["Порт"];
	ИмяХоста = Настройки["ИмяХоста"];
	ЗапросВФоновыхЗаданиях = Настройки["ЗапросВФоновыхЗаданиях"];

	Если ТипЗнч(Настройки["КаталогиСФайлами"]) = Тип("Соответствие") Тогда
		Для каждого ФайлыИзНастроек Из Настройки["КаталогиСФайлами"] Цикл
			КаталогиСФайлами.Вставить(ФайлыИзНастроек.Ключ, ФайлыИзНастроек.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Для каждого ПриложенияИзНастроек Из Настройки["КаталогиСПриложениями"] Цикл
		КаталогиСПриложениями.Вставить(ПриложенияИзНастроек.Ключ, ПриложенияИзНастроек.Значение);
	КонецЦикла;

КонецПроцедуры

Процедура СгенерироватьФайлНастроек(ПутьДоНастроек) Экспорт

	СоотвПриложения = Новый Соответствие();
	СоотвПриложения.Вставить("Приложение", "./app/scripts");

	СоотвФайлы = Новый Соответствие();
	СоотвФайлы.Вставить("/files", "./app/files");

	Настройки = Новый Структура();
	Настройки.Вставить("Порт", Порт);
	Настройки.Вставить("ИмяХоста", ИмяХоста);
	Настройки.Вставить("ЗапросВФоновыхЗаданиях", ЗапросВФоновыхЗаданиях);
	Настройки.Вставить("КаталогиСПриложениями", СоотвПриложения);
	Настройки.Вставить("КаталогиСФайлами", СоотвФайлы);

	Парсер = Новый ПарсерJSON();
	НастройкиТекстом = Парсер.ЗаписатьJSON(Настройки);

	ЗаписьТекста = Новый ЗаписьТекста();
	ЗаписьТекста.Открыть(ПутьДоНастроек);
	ЗаписьТекста.Записать(НастройкиТекстом);
	ЗаписьТекста.Закрыть();

КонецПроцедуры

Функция РаспарситьНастройки(НастройкиТекстом)
	
	Парсер = Новый ПарсерJSON();
	Возврат Парсер.ПрочитатьJSON(НастройкиТекстом);

КонецФункции

Функция СодержимоеФайла(ПутьКФайлу)
	
	Если Новый Файл(ПутьКФайлу).Существует() Тогда
		Чтение = Новый ЧтениеТекста();
		Чтение.Открыть(ПутьКФайлу);
		Текст = Чтение.Прочитать();
		Чтение.Закрыть();

		Возврат Текст;

	Иначе
		Возврат "";
	КонецЕсли;

КонецФункции




