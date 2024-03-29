///////////////////////////////////////////////////////////////////////////////
//
// Тестирование основной функциональности пакета
// Проверка на соответствие выгрузки эталону
//
// (с) BIA Technologies, LLC
//
///////////////////////////////////////////////////////////////////////////////

#Использовать ".."
#Использовать logos
#Использовать asserts
#Использовать fs
#Использовать 1testrunner

///////////////////////////////////////////////////////////////////////////////

Перем Лог;

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
///////////////////////////////////////////////////////////////////////////////

Функция ПолучитьСписокТестов(Знач ЮнитТестирование) Экспорт

	Лог = Логирование.ПолучитьЛог("Тест");

	МассивТестов = Новый Массив;
	МассивТестов.Добавить("ТестСоздатьПростоеРасширениеВИерархическомФорматеКонфигуратора");
	МассивТестов.Добавить("ТестСоздатьПростоеРасширениеВФорматеEDT");

	Возврат МассивТестов;

КонецФункции

Процедура ПередЗапускомТеста() Экспорт

КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт

КонецПроцедуры

Процедура ТестСоздатьПростоеРасширениеВИерархическомФорматеКонфигуратора() Экспорт
	
	КаталогРасширения = ОбъединитьПути("ignore", "extension", "designer");
	КаталогКонфигурации = ОбъединитьПути(КаталогФикстур(), "configurations", "Demo_8_3_10");
	
	Конфигурация = РазборКонфигураций.ЗагрузитьКонфигурацию(КаталогКонфигурации);

	Расширение = РазборКонфигураций.СоздатьНовоеРасширение(КаталогРасширения, ФорматыВыгрузки.Конфигуратор_8_3_10);
	СвойстваРасширения = Расширение.ОписаниеКонфигурации().СвойстваКонфигурации;
	СвойстваРасширения.Наименование = "Simple";
	СвойстваРасширения.Синоним = Новый Структура ("ru, en", "Простое расширение", "Simple extension");
	СвойстваРасширения.ПрефиксИмен = "smpl_";
	СвойстваРасширения.РежимСовместимостиРасширенияКонфигурации = "8.3.9";
	Для Каждого Объект Из Конфигурация.ОписаниеКонфигурации().ОбъектыКонфигурации Цикл
		
		Если Объект.Тип = ТипыОбъектовКонфигурации.ИмяТипаПодсистема() ИЛИ Объект.Тип = ТипыОбъектовКонфигурации.ИмяТипаКонфигурации() Тогда

			Продолжить;
			
		КонецЕсли;
		
		Конфигурация.ПрочитатьОписаниеОбъекта(Объект);
		Расширение.ДобавитьОбъектВРасширение(Объект);

	КонецЦикла;

	Расширение.Зафиксировать();

	ТекстОписаниеКонфигурации = Утилиты.ПрочитатьФайл(Расширение.СтруктураКаталогов().ИмяФайлаОписанияКонфигурации());
	
	Ожидаем.Что(ТекстОписаниеКонфигурации, "Файл configuration содержит верный режим совместимости").Содержит("Version8_3_9");

	ТекстКонфигаРасширения = Новый Файл(ОбъединитьПути(КаталогРасширения, "Configuration.xml"));

КонецПроцедуры

Процедура ТестСоздатьПростоеРасширениеВИерархическомФорматеEDT() Экспорт
	
	КаталогРасширения = ОбъединитьПути("ignore", "extension", "edt");
	КаталогКонфигурации = ОбъединитьПути(КаталогФикстур(), "configurations", "Demo_8_3_10");
	
	Конфигурация = РазборКонфигураций.ЗагрузитьКонфигурацию(КаталогКонфигурации);

	Расширение = РазборКонфигураций.СоздатьНовоеРасширение(КаталогРасширения, ФорматыВыгрузки.EDT);
	СвойстваРасширения = Расширение.ОписаниеКонфигурации().СвойстваКонфигурации;
	СвойстваРасширения.Наименование = "Simple";
	СвойстваРасширения.Синоним = "Простое расширение";
	СвойстваРасширения.ПрефиксИмен = "smpl_";
	
	Для Каждого Объект Из Конфигурация.ОписаниеКонфигурации().ОбъектыКонфигурации Цикл
		
		Если Объект.Тип = ТипыОбъектовКонфигурации.ИмяТипаПодсистема() ИЛИ Объект.Тип = ТипыОбъектовКонфигурации.ИмяТипаКонфигурации() Тогда
			
			Продолжить;
			
		КонецЕсли;

		Конфигурация.ПрочитатьОписаниеОбъекта(Объект);
		Расширение.ДобавитьОбъектВРасширение(Объект);

	КонецЦикла;

	Расширение.Зафиксировать();
	
КонецПроцедуры

Процедура ТестВключенияВсехМодулейВРасширениеКонфигуратор() Экспорт
	
	КаталогРасширения = ОбъединитьПути("ignore", "extension", "designer");
	КаталогКонфигурации = ОбъединитьПути(КаталогФикстур(), "configurations", "Demo_8_3_10");
	
	Расширение = РазборКонфигураций.СоздатьНовоеРасширение(КаталогРасширения, ФорматыВыгрузки.Конфигуратор_8_3_10);
	Конфигурация = РазборКонфигураций.ЗагрузитьКонфигурацию(КаталогКонфигурации);

	СоздатьПростоеРасширение(Конфигурация, Расширение);

КонецПроцедуры

Процедура ТестСоздатьПростоеРасширениеВФорматеEDT() Экспорт

	КаталогРасширения = ОбъединитьПути("ignore", "extension", "edt");
	КаталогКонфигурации = ОбъединитьПути(КаталогФикстур(), "edtconfigurations", "Demo_8_3_10", "src");

	Расширение = РазборКонфигураций.СоздатьНовоеРасширение(КаталогРасширения, ФорматыВыгрузки.EDT);
	Конфигурация = РазборКонфигураций.ЗагрузитьКонфигурацию(КаталогКонфигурации);
	
	СоздатьПростоеРасширение(Конфигурация, Расширение);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
///////////////////////////////////////////////////////////////////////////////

Процедура ПроверитьРезультатЧтенияВыгрузки(Парсер, КоличествоОбъектов, КоличествоМодулей)

	Ожидаем.Что(Парсер.ОписаниеКонфигурации().ОбъектыКонфигурации.Количество(), "Количество найденных объектов не соответствует фактическому").Равно(КоличествоОбъектов);
	Ожидаем.Что(Парсер.ОписаниеКонфигурации().МодулиКонфигурации.Количество(), "Количество найденных модулей не соответствует фактическому").Равно(КоличествоМодулей);
	
	Для Каждого Объект Из Парсер.ОписаниеКонфигурации().ОбъектыКонфигурации Цикл
		
		Ожидаем.Что(ФС.ФайлСуществует(Объект.ПутьКФайлу), СтрШаблон("Не существует файл [%2] описания объекта ""%1""", Парсер.ПолноеИмяОбъекта(Объект), Объект.ПутьКФайлу)).ЭтоИстина();

	КонецЦикла;

	Для Каждого Объект Из Парсер.ОписаниеКонфигурации().МодулиКонфигурации Цикл
		
		Ожидаем.Что(ФС.ФайлСуществует(Объект.ПутьКФайлу), СтрШаблон("Не существует файл [%2] модуля объекта ""%1""", Парсер.ПолноеИмяОбъекта(Объект), Объект.ПутьКФайлу)).ЭтоИстина();

	КонецЦикла;

КонецПроцедуры

Процедура СоздатьПростоеРасширение(Конфигурация, Расширение)
	
	СвойстваРасширения = Расширение.ОписаниеКонфигурации().СвойстваКонфигурации;
	
	СвойстваРасширения.Наименование = "Simple";
	СвойстваРасширения.Синоним = "Простое расширение";
	СвойстваРасширения.ПрефиксИмен = "smpl_";
	
	Для Каждого Объект Из Конфигурация.ОписаниеКонфигурации().ОбъектыКонфигурации Цикл
		
		Расширение.ДобавитьОбъектВРасширение(Объект);

	КонецЦикла;

	Расширение.Зафиксировать();	
	
КонецПроцедуры

Функция КаталогФикстур()
	
	Возврат ОбъединитьПути(ТекущийСценарий().Каталог, "common-fixtures");

КонецФункции
