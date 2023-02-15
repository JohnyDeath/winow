&Пластилин Перем ВебСервер;

Перем ТекстовоеОписаниеКоманды Экспорт;
Перем ТекстКоманды Экспорт;

Перем ФайлНастроек;
Перем Порт;
Перем КаталогСПриложениям;
Перем КаталогСФайлами;
Перем ИмяХоста;
Перем ИмяПриложения;
Перем ПутьКФайламНаСайте;

&Желудь
Процедура ПриСозданииОбъекта()
	ТекстКоманды = "start";
	ТекстовоеОписаниеКоманды = "Запуск сервера";	
КонецПроцедуры

Процедура ОписаниеКоманды(Команда) Экспорт
    ФайлНастроек = Команда.Опция("s settings", "" ,"Файл настроек").ТСтрока();

	ИмяХоста = Команда.Опция("h hostname", "" ,"Имя хоста").ТСтрока();
	Порт = Команда.Опция("p port", "" ,"Порт").ТЧисло();

	КаталогСПриложениям = Команда.Опция("app-path", "" ,"Каталог с приложением").ТСтрока();
	ИмяПриложения = Команда.Опция("app-name", "" ,"Имя приложения").ТСтрока();

	КаталогСФайлами = Команда.Опция("files-path", "" ,"Каталог с файлами").ТСтрока();
	ПутьКФайламНаСайте = Команда.Опция("files-site-path", "" ,"Путь до файлов в приложении").ТСтрока();;
КонецПроцедуры

Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт

	Если ЗначениеЗаполнено(ФайлНастроек.Значение) Тогда
		ВебСервер.Настройки.ПрочитатьИзФайла(ФайлНастроек.Значение);
	КонецЕсли;

	Если ЗначениеЗаполнено(Порт.Значение) Тогда
		ВебСервер.Настройки.Порт = Порт.Значение;
	КонецЕсли;

	Если ЗначениеЗаполнено(КаталогСПриложениям.Значение) Тогда
		Если ЗначениеЗаполнено(ИмяПриложения.Значение) Тогда
			_ИмяПриложения= ИмяПриложения.Значение;
		Иначе
			_ИмяПриложения = "Приложение";
		КонецЕсли;
		ВебСервер.Настройки.КаталогиСПриложениями.Вставить(_ИмяПриложения, КаталогСПриложениям.Значение);
	КонецЕсли;

	Если ЗначениеЗаполнено(КаталогСФайлами.Значение) Тогда
		Если ЗначениеЗаполнено(ПутьКФайламНаСайте.Значение) Тогда
			_ПутьКФайламНаСайте = ПутьКФайламНаСайте.Значение;
		Иначе
			_ПутьКФайламНаСайте = "/files";
		КонецЕсли;
		ВебСервер.Настройки.КаталогиСФайлами.Вставить(_ПутьКФайламНаСайте, КаталогСФайлами.Значение);
	КонецЕсли;

	Если ЗначениеЗаполнено(ИмяХоста.Значение) Тогда
		ВебСервер.Настройки.ИмяХоста = ИмяХоста.Значение;
	КонецЕсли;

	ВебСервер.Старт();

КонецПроцедуры
