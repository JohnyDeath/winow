Перем Сессии;
Перем Поделка;

&Желудь
Процедура ПриСозданииОбъекта(
							&Пластилин("Поделка") _Поделка
							)
	Поделка = _Поделка;
	Сессии = Новый Соответствие();
КонецПроцедуры

Функция НоваяСессия()

	Возврат Поделка.НайтиЖелудь("СессияПользователя");
	
КонецФункции

Функция ПолучитьСессиюПоИдентификатору(Идентификатор) Экспорт
	ТекСессия = Сессии.Получить(Идентификатор);
	Если ТекСессия = Неопределено Тогда
		ТекСессия = НоваяСессия();
		Сессии.Вставить(ТекСессия.Идентификатор(), ТекСессия);
	КонецЕсли;
	Возврат ТекСессия;
КонецФункции