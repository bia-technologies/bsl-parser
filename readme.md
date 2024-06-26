﻿# Парсер конфигурации 1С

## Информация

Скрипты данной библиотеки используются для разбора конфигурации 1С выгруженной в исходные файлы.

*Под словом **конфигурация** понимается как конфигурация 1С, так и расширение.*

## Установка

1. Склонировать репозиторий
2. Выполнить скрипт `installlocalhost.bat`

## Использование

Библиотека содержит в себе большое количество модулей и классов, часть из них может дорабатываться в процессе развития продукта.
Поэтому рекомендуется использовать только методы модулей входящие в API (модули лежащие в корневом каталоге) для них будет сохранятся обратная совместимость.

### API

Для работы с файлами выгрузки используются модуль-фабрика:

* [РазборКонфигураций](src/Модули/РазборКонфигураций.os) - модуль содержит методы-конструкторы для инициализации объектов.
  Это базовый модуль, основная точка входа API. Он создает объекты позволяющие читать, писать и изменять исходники.
  Модуль содержит следующие методы:
  * ЗагрузитьКонфигурацию() - создает объект для чтения конфигурации
  * ЗагрузитьРасширение() - создает объект для чтения расширения
  * СоздатьНовуюКонфигурацию() - Создает объект для генерации описания конфигурации с нуля.
  * СоздатьНовоеРасширение() - Создает объект для генерации описания расширения с нуля.
  * СоздатьОбъектКонфигурации() - Создает описание объекта конфигурации
* [Конфигурация](src/Классы/Конфигурация.os) - класс, реализует API для работы с конфигураций
* [Расширение](src/Классы/Расширение.os) - класс, реализует API для работы с расширением
* [ДанныеКонфигурации](src/Классы/ДанныеКонфигурации.os) - класс, хранит данные описания конфигурации, список объектов, модулей и тд
* [СтруктураКаталоговКонфигурации](src/Классы/СтруктураКаталоговКонфигурации.os) - класс, для навигации по каталогам выгрузки исходников. Учитывает различия хранения для различных версий.
* Перечисления.* - предопределенные константы.
  * ТипыОбъектовКонфигурации - содержит методы для работы с типами
  * ФорматыВыгрузки - значения поддерживаемых форматов выгрузки
  * ТипыМодуля - значения типов модулей (общий, модуль формы, модуль объекта...)
  * ТипыБлоковМодуля - значения типов блоков модуля (Заголовок функции, комментарий, текст...)
  * ТипыОбласти - значения обязательных областей модуля
* [РедакторОписания](src/Классы/РедакторОписания.os) - класс-помощник, содержит дополнительные методы редактирования описаний

Пример, выводит имена всех объектов конфигурации и имена всех методов

```bsl
    #Использовать bsl-parser

    Парсер = РазборКонфигураций.ЗагрузитьКонфигурацию(КаталогИсходников); // Создаем парсер
    Конфигурация = Парсер.ОписаниеКонфигурации();

    Для Каждого Объект Из Конфигурация.ОбъектыКонфигурации Цикл // Обрабатываем объекты

        // Обработаем объекты
        Сообщить(Объект.Тип + "." + Объект.Наименование);

    КонецЦикла;

    Парсер.НайтиМодулиКонфигурации(); // Находим все модули объектов

    Для Каждого Модуль Из Конфигурация.ОбъектыКонфигурации Цикл

        Для Каждого Блок Из Модуль.БлокиМодуля Цикл

            Если Блок.ТипБлока = ТипыБлоковМодуля.ЗаголовокПроцедуры ИЛИ Блок.ТипБлока = ТипыБлоковМодуля.ЗаголовокФункции Тогда

                Сообщить(ОписаниеБлока.ИмяМетода);

            КонецЕсли;

        КонецЦикла;

    КонецЦикла;
```

Пример включения всех объектов в расширение:

```bsl
    #Использовать bsl-parser

    Расширение = РазборКонфигураций.СоздатьНовоеРасширение(КаталогРасширения, ФорматыВыгрузки.Конфигуратор_8_3_10);
    Конфигурация = РазборКонфигураций.ЗагрузитьКонфигурацию(КаталогКонфигурации);

    СвойстваРасширения = Расширение.ОписаниеКонфигурации().СвойстваКонфигурации;

    СвойстваРасширения.Наименование = "Simple";
    СвойстваРасширения.Синоним = "Простое расширение";
    СвойстваРасширения.ПрефиксИмен = "smpl_";

    Для Каждого Объект Из Конфигурация.ОписаниеКонфигурации().ОбъектыКонфигурации Цикл

        Расширение.ДобавитьОбъектВРасширение(Объект);

    КонецЦикла;

    Расширение.Зафиксировать();

```

Пример добавления нового объекта в конфигурацию:

```bsl
    #Использовать bsl-parser

    Конфигурация = РазборКонфигураций.ЗагрузитьКонфигурацию(КаталогКонфигурации);

    НовыйОбъект = РазборКонфигураций.СоздатьОбъектКонфигурации("Справочник", "ТестовыйСправочник");
    Конфигурация.ДобавитьОбъект("Справочник", НовыйОбъект);

    Конфигурация.Зафиксировать();

```

Пример поиск регистров сведений подчиненных регистратору:

```bsl
    #Использовать bsl-parser

    Конфигурация = РазборКонфигураций.ЗагрузитьКонфигурацию(КаталогКонфигурации);
    КонфигурацияОбъекты = Конфигурация.ОписаниеКонфигурации();

    Для Каждого Регистр Из КонфигурацияОбъекты.НайтиОбъектыПоТипу("РегистрСведений") Цикл

        ЧтениеКонфигурации.ПрочитатьОписание(Регистр);

        Если Регистр.Описание.РежимЗаписи = "RecorderSubordinate" Тогда

            Сообщить(Регистр.ПолноеНаименование);

        КонецЕсли;

    КонецЦикла;

```

## Лицензии и права

* основная лицензия исходного кода продукта - [MIT](LICENSE)
* лицензии стороннего кода - BSDv3, Apache License, Freeware, etc - подробные разъяснения лицензий на исходный код продукта и его документации в том числе содержатся внутри файлов исходного кода
