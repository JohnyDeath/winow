&Пластилин Перем БрокерСообщенийВебСокетов;

&Контроллер("/console")
Процедура ПриСозданииОбъекта()
	
КонецПроцедуры

&ТочкаМаршрута("run")
Процедура ВходящееСообщение(Идентификатор, Топик, Сообщение) Экспорт

	ВывестиСтрокиВБраузере(">" + Сообщение, Топик, Идентификатор);

	ЗапуститьПоцесс(Сообщение, Идентификатор, Топик);

КонецПроцедуры

&Отображение("./hwapp/view/console.html")
&ТочкаМаршрута("")
Процедура Главная() Экспорт
	
КонецПроцедуры

Процедура ЗапуститьПоцесс(ТекстКоманды, Идентификатор, Топик)
	Сообщить("Получена команда " + ТекстКоманды);
	Процесс = СоздатьПроцесс(ТекстКоманды,,Истина);
	Процесс.Запустить();
	Пока НЕ Процесс.Завершен 
		ИЛИ Процесс.ПотокВывода.ЕстьДанные 
		ИЛИ Процесс.ПотокОшибок.ЕстьДанные Цикл
		
		Приостановить(500);
		
		ОчереднаяСтрокаВывода = Процесс.ПотокВывода.Прочитать();
		ОчереднаяСтрокаОшибок = Процесс.ПотокОшибок.Прочитать();
		Если Не ПустаяСтрока(ОчереднаяСтрокаВывода) Тогда
			ВывестиСтрокиВБраузере(ОчереднаяСтрокаВывода, Топик, Идентификатор);
		КонецЕсли;
		
		Если Не ПустаяСтрока(ОчереднаяСтрокаОшибок) Тогда
			ВывестиСтрокиВБраузере(ОчереднаяСтрокаОшибок, Топик, Идентификатор);
		КонецЕсли;

	КонецЦикла;
	Сообщить("Команда обработана " + ТекстКоманды);
КонецПроцедуры

Процедура ВывестиСтрокиВБраузере(Текст, Топик, Идентификатор)
	
	Для Каждого ТекСтрока из СтрРазделить(Текст, Символы.ПС) Цикл
		БрокерСообщенийВебСокетов.ОтправитьСообщение(Топик, ФорматированноеСообщение(ТекСтрока), Идентификатор);
	КонецЦикла;

КонецПроцедуры

Функция ФорматированноеСообщение(ВыводКоманды)

	ОбъектДляПарсинга = Новый Структура("output", ВыводКоманды);

	Запись = новый ЗаписьJSON;
	Запись.УстановитьСтроку();
	ЗаписатьJSON(Запись, ОбъектДляПарсинга);

	Возврат Запись.Закрыть();
КонецФункции