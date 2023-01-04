Перем КаталогСПриложениями;

Процедура ПриИнициализацииПоделки(Поделка) Экспорт

	ДобавитьЖелудиСервера(Поделка);
	ДобавитьЖелудиПриложений(Поделка);
	
КонецПроцедуры

Процедура ДобавитьЖелудиПриложений(Поделка)
	
	Файлы = НайтиФайлы(КаталогСПриложениями, "*.os", Истина);
	Для Каждого Файл Из Файлы Цикл
		ПодключитьСценарий(Файл.ПолноеИмя, Файл.ИмяБезРасширения);	

		ТипЖелудя = Неопределено;
		Попытка
			ТипЖелудя = Тип(Файл.ИмяБезРасширения);
		Исключение
			Продолжить;
		КонецПопытки;

	КонецЦикла;

	Поделка.ПросканироватьКаталог(КаталогСПриложениями);

КонецПроцедуры

Процедура ДобавитьЖелудиСервера(Поделка)
	КаталогМодуля = ОбъединитьПути(ТекущийСценарий().Каталог, "../Классы");
	Поделка.ПросканироватьКаталог(КаталогМодуля);
КонецПроцедуры

&Заготовка
Процедура ПриСозданииОбъекта(&Деталька(Значение = "winow.КаталогСПриложениями", ЗначениеПоУмолчанию = "./app") _КаталогСПриложениями)
	КаталогСПриложениями = _КаталогСПриложениями;	
КонецПроцедуры