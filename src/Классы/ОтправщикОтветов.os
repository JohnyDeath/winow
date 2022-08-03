Перем Перечисления;

&Желудь
Процедура ПриСозданииОбъекта(&Пластилин("Перечисления") _Перечисления)
	Перечисления = _Перечисления;
КонецПроцедуры

Процедура ОтправитьОтвет(Ответ, Соединение) Экспорт

	МассивОтвета = Новый Массив();

	МассивОтвета.Добавить(ПолучитьШапкуОтвета(Ответ));

	ДобавитьВМассивСоответствиеКакСтроки(МассивОтвета, Ответ.Заголовки);

	Для Каждого Кука из Ответ.Куки.ПолучитьМассивСтрокКук() Цикл
		МассивОтвета.Добавить(Кука);
	КонецЦикла;

	МассивОтвета.Добавить(Перечисления.Разделитель);

	ТекстСтатусИЗаголовки = СтрСоединить(МассивОтвета, Перечисления.Разделитель);
	
	ДвоичныеДанныеТекстСтатусИЗаголовки = ПолучитьДвоичныеДанныеИзСтроки(ТекстСтатусИЗаголовки, "utf-8");

	МассивДвоичныхДанных = Новый Массив();

	МассивДвоичныхДанных.Добавить(ДвоичныеДанныеТекстСтатусИЗаголовки);

	Если ЗначениеЗаполнено(Ответ.ТелоДвоичныеДанные) Тогда
		МассивДвоичныхДанных.Добавить(Ответ.ТелоДвоичныеДанные);

	ИначеЕсли ЗначениеЗаполнено(Ответ.ТелоТекст) Тогда
		МассивДвоичныхДанных.Добавить(ПолучитьДвоичныеДанныеИзСтроки(Ответ.ТелоТекст, "utf-8"));	
		
	КонецЕсли;

	ДвоичныеДанныеОтвета = СоединитьДвоичныеДанные(МассивДвоичныхДанных);
	Соединение.ОтправитьДвоичныеДанные(ДвоичныеДанныеОтвета);
	
КонецПроцедуры

Процедура ДобавитьВМассивСоответствиеКакСтроки(Массив, Соответствие)
	Для Каждого КиЗ Из Соответствие Цикл
		Массив.Добавить(СтрШаблон("%1: %2", КиЗ.Ключ, КиЗ.Значение));	
	КонецЦикла
КонецПроцедуры

Функция ПолучитьШапкуОтвета(Ответ)
	Возврат СтрШаблон("HTTP/1.1 %1 %2", Ответ.СостояниеКод, Ответ.СостояниеТекс);	
КонецФункции
