&Пластилин Перем Поделка;
&Пластилин Перем ОбработчикСоединений;

Перем ПулСоединений;

&Желудь
Процедура ПриСозданииОбъекта()
	Инициализация();
КонецПроцедуры

Процедура Добавить(Соединение, Идентификатор, Топик) Экспорт
	НовоеСоединение = ПулСоединений.Добавить();
	НовоеСоединение.Идентификатор = Идентификатор;
	НовоеСоединение.Топик = Топик;
	НовоеСоединение.Соединение = Соединение;
	НовоеСоединение.Подписка = НоваяПодписка(Соединение, Идентификатор, Топик);
КонецПроцедуры

Процедура Инициализация()
	ПулСоединений = Новый ТаблицаЗначений();
	ПулСоединений.Колонки.Добавить("Идентификатор");
	ПулСоединений.Колонки.Добавить("Топик");
	ПулСоединений.Колонки.Добавить("Соединение");
	ПулСоединений.Колонки.Добавить("Подписка");
КонецПроцедуры

Функция НоваяПодписка(Соединение, Идентификатор, Топик)
	Подписка = Поделка.НайтиЖелудь("ПодпискаНаВебСокет");
	Подписка.Подписатся(Соединение, Идентификатор, Топик);
	Возврат Подписка;
КонецФункции

Функция ПолучитьСоединенияПоТопику(Топик) Экспорт
	Возврат ПолучитьСоединенияСОтбором(Новый Структура("Топик", Топик));
КонецФункции

Функция ПолучитьСоединенияПоТопикуСпискуИдентификаторов(Топик, СписокИдентификаторов) Экспорт
	Соединения = ПолучитьСоединенияПоТопику(Топик);
	Результат = Новый Массив();
	Для Каждого ДанныеСоединения из Соединения Цикл
		Если НЕ СписокИдентификаторов.Найти(ДанныеСоединения.Идентификатор) = Неопределено Тогда
			Результат.Добавить(ДанныеСоединения);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ПолучитьСоединенияПоТопикуКромеСпискаИдентификаторов(Топик, СписокИсключенийИдентификаторов) Экспорт
	Соединения = ПолучитьСоединенияПоТопику(Топик);
	Результат = Новый Массив();
	Для Каждого ДанныеСоединения из Соединения Цикл
		Если СписокИсключенийИдентификаторов.Найти(ДанныеСоединения.Идентификатор) = Неопределено Тогда
			Результат.Добавить(ДанныеСоединения);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ПолучитьСоединениеПоИдентификатору(Топик, Идентификатор) Экспорт

	Соединения = ПолучитьСоединенияСОтбором(Новый Структура("Топик, Идентификатор", Топик, Идентификатор));

	Если Соединения.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат Соединения[0];
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСоединенияСОтбором(Отбор) Экспорт
	Возврат ПулСоединений.НайтиСтроки(Отбор);
КонецФункции

Процедура УдалитьСоединение(Соединение) Экспорт
	Для Каждого СтрокаСоединеия из ПолучитьСоединенияСОтбором(Новый Структура("Соединение", Соединение)) Цикл
		ПулСоединений.Удалить(СтрокаСоединеия);
	КонецЦикла;
КонецПроцедуры

Процедура НайтиИЗакрытьСоединениеПоИдентификаторуИТопику(Топик, Идентификатор) Экспорт
	ДанныеСоединения = ПолучитьСоединениеПоИдентификатору(Топик, Идентификатор);
	Если НЕ ДанныеСоединения = Неопределено Тогда
		ДанныеСоединения.Подписка.Отписаться();
		Если ДанныеСоединения.Соединение.Активно = Истина Тогда 
			ОбработчикСоединений.ЗакрытьСоединениеВПопытке(ДанныеСоединения.Соединение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры