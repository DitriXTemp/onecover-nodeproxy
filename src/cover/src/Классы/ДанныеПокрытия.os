Перем Результат Экспорт;


Процедура ПриСозданииОбъекта() Экспорт

	Результат = Новый Соответствие();

КонецПроцедуры	


Процедура РазобратьЛог(Лог, ДанныеКонфигурации, ДанныеОбработок) Экспорт

	Если НЕ ЕстьСвойство(Лог, "request") 
		ИЛИ НЕ ЕстьСвойство(Лог.request, "commandToDbgServer")
		ИЛИ НЕ ЕстьСвойство(Лог.request.commandToDbgServer, "measure") 
		ИЛИ НЕ ЕстьСвойство(Лог.request.commandToDbgServer.measure, "moduleData") Тогда
		Возврат;
	КонецЕсли;	
	
	Данные = Коллекция.ВКоллекцию(Лог.request.commandToDbgServer.measure.moduleData);

	Для каждого Ключ Из Данные Цикл
	
		Если НЕ ЕстьСвойство(Ключ, "moduleId") Тогда
			Возврат;
		КонецЕсли;	

		ЭтоНовый = Ложь;
		Если Ключ.moduleId.Свойство("URL") Тогда
			URL = СтрЗаменить(Ключ.moduleId.URL, "sfile://", "");
			URL = СтрЗаменить(URL, "file://", "");
			Модуль = ДанныеОбработок.ОпределитьМодульПоId(URL, Ключ.moduleId.objectID);
		Иначе	
			Модуль = ДанныеКонфигурации.ОпределитьМодульПоId(Ключ.moduleId.objectID, Ключ.moduleId.propertyID);
		КонецЕсли;

		ДаннныеМодуля = Результат.Получить(Модуль);
		Если ДаннныеМодуля = Неопределено Тогда
			ЭтоНовый = Истина;
			ДаннныеМодуля = Новый Структура("Путь, Строки", "", Новый Массив);
			Если Ключ.moduleId.Свойство("URL") Тогда
				ПутьКФайлуОбработки = СтрЗаменить(Ключ.moduleId.URL, "sfile://", "");
				ПутьКФайлуОбработки = СтрЗаменить(ПутьКФайлуОбработки, "file://", "");

				ДаннныеМодуля.Путь = ДанныеОбработок.ПутьКФайлу(
					ПутьКФайлуОбработки, 
					Ключ.moduleId.objectID, 
					Ключ.moduleId.propertyID
				);
			Иначе	
				ДаннныеМодуля.Путь = ПутиФайловКонфигурации.ПутьКонфигуратора(Модуль);
			КонецЕсли;	
		КонецЕсли;	
	
		lineInfo = Коллекция.ВКоллекцию(Ключ.lineInfo);
		Для Каждого ПокрытаяСтрока Из lineInfo Цикл

			ДанныеСтроки = Новый Структура();
			ДанныеСтроки.Вставить("НомерСтроки", ПокрытаяСтрока.lineNo);
			ДаннныеМодуля.Строки.Добавить(ДанныеСтроки);

		КонецЦикла;	
		
		Если ЭтоНовый Тогда
			Результат.Вставить(Модуль, ДаннныеМодуля);
		КонецЕсли;	

	КонецЦикла;	

КонецПроцедуры	

Функция ЕстьСвойство(Структура, ИмяСвойства)

	ЕстьСвойство = Ложь;

	Если ТипЗнч(Структура) = Тип("Структура") 
		И Структура.Свойство(ИмяСвойства) Тогда

		ЕстьСвойство = Истина;
	КонецЕсли;	

	Возврат ЕстьСвойство;

КонецФункции	