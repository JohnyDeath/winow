Перем КонтекстПриложения;
Перем Перечисления;
Перем Парсеры;

&Желудь
Процедура ПриСозданииОбъекта(
							&Пластилин("КонтекстПриложения") _КонтекстПриложения,
							&Пластилин("Перечисления") _Перечисления,
							&Пластилин("Парсеры") _Парсеры
							)
	КонтекстПриложения = _КонтекстПриложения;
	Перечисления = _Перечисления;
	Парсеры = _Парсеры;
КонецПроцедуры

Функция ПолучитьЗапрос(Соединение) Экспорт
	
	Запрос = КонтекстПриложения.ПолучитьЖелудь("ВходящийЗапрос");

	ДанныеЗапроса = Соединение.ПрочитатьДвоичныеДанные();

	РазделенныйЗапрос = Парсеры.РазделитьДвоичныеДанныеРазделителем(ДанныеЗапроса, ПолучитьДвоичныеДанныеИзСтроки(Перечисления.Разделитель + Перечисления.Разделитель));

	ТекстЗапроса = ПолучитьСтрокуИзДвоичныхДанных(РазделенныйЗапрос.Лево, "utf-8");

	СтруктураЗапроса = РазобратьТексЗапроса(ТекстЗапроса);

	Запрос.ТекстЗапроса = ТекстЗапроса;
	Запрос.Соединение = Соединение;
	Запрос.ДвоичныеДанные = ДанныеЗапроса;
	Запрос.ТелоДвоичныеДанные = РазделенныйЗапрос.Право;
	Если Не Запрос.ТелоДвоичныеДанные = Неопределено Тогда
		Запрос.Тело = ПолучитьСтрокуИзДвоичныхДанных(Запрос.ТелоДвоичныеДанные);
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(Запрос, СтруктураЗапроса);

	Возврат Запрос;

КонецФункции

Функция РазобратьТексЗапроса(ТекстЗапроса)
	Результат = Новый Структура();

	МассивСтрок = СтрРазделить(ТекстЗапроса, Символы.ПС, Ложь);

	Если МассивСтрок.Количество() > 0 Тогда
		ПерваяСтрока = СтрРазделить(МассивСтрок[0], " ");
		Результат.Вставить("Метод", ПерваяСтрока[0]);
		Результат.Вставить("ПолныйПуть", РаскодироватьСтроку(ПерваяСтрока[1],СпособКодированияСтроки.КодировкаURL));
		
		ПутьИПараметры = Парсеры.РазделитьСтроку(Результат.ПолныйПуть, "?");

		Результат.Вставить("ПараметрыИменные", Парсеры.ПараметрыИзТекста(ПутьИПараметры.Право));
		Результат.Вставить("Путь", ПутьИПараметры.Лево);
		
		Заголовки = Новый Соответствие();
		Результат.Вставить("Заголовки", Заголовки);

		Результат.Вставить("Куки", КонтекстПриложения.ПолучитьЖелудь("Куки"));

		Для Сч = 1 По МассивСтрок.ВГраница() Цикл
			ДанныеСтроки = РаспарситьСтрокуЗаголовка(МассивСтрок[Сч]);
			Если ДанныеСтроки.Имя = "Cookie" Тогда
				Кука = Парсеры.РазделитьСтроку(ДанныеСтроки.Значение, "=");
				Результат.Куки.Добавить(Кука.Лево, Кука.Право);
			Иначе
				Заголовки.Вставить(ДанныеСтроки.Имя, ДанныеСтроки.Значение);
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;

	Возврат Результат;
КонецФункции

Функция РаспарситьСтрокуЗаголовка(СтрокаЗаголовка)
	РазделеннаяСтрока = Парсеры.РазделитьСтроку(СтрокаЗаголовка, ":");
	Возврат Новый Структура("Имя, Значение", РазделеннаяСтрока.Лево, РазделеннаяСтрока.Право);
КонецФункции