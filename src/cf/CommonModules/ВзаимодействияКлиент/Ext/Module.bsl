﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму нового документа "Сообщение SMS" с переданными параметрами.
//
// Параметры:
//   ПараметрыФормы - см. ВзаимодействияКлиент.ПараметрыФормыОтправкиSMS.
//   УдалитьТекст                - Строка - не используется.
//   УдалитьПредмет              - ЛюбаяСсылка - не используется.
//   УдалитьОтправлятьВТранслите - Булево - не используется.
//
Процедура ОткрытьФормуОтправкиSMS(Знач ПараметрыФормы = Неопределено,
    Знач УдалитьТекст = "", Знач УдалитьПредмет = Неопределено, Знач УдалитьОтправлятьВТранслите = Ложь) Экспорт
	
	Если ТипЗнч(ПараметрыФормы) <> Тип("Структура") Тогда
		Параметры = ПараметрыФормыОтправкиSMS();
		Параметры.Адресаты = ПараметрыФормы;
		Параметры.Текст = УдалитьТекст;
		Параметры.Предмет = УдалитьПредмет;
		Параметры.ОтправлятьВТранслите = УдалитьОтправлятьВТранслите;
		ПараметрыФормы = Параметры;
	КонецЕсли;								  
	ОткрытьФорму("Документ.СообщениеSMS.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Возвращает параметры для передачи в ВзаимодействияКлиент.ОткрытьФормуОтправкиSMS.
//
// Возвращаемое значение:
//  Структура:
//   * Адресаты             - Строка
//                          - СписокЗначений
//                          - Массив - список получателей письма.
//   * Текст                - Строка - текст письма.
//   * Предмет              - ЛюбаяСсылка - предмет письма.
//   * ОтправлятьВТранслите - Булево - признак того, что сообщение при отправке должно быть преобразовано в латинские
//                                     символы.
//
Функция ПараметрыФормыОтправкиSMS() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Адресаты", Неопределено);
	Результат.Вставить("Текст", "");
	Результат.Вставить("Предмет", Неопределено);
	Результат.Вставить("ОтправлятьВТранслите", Ложь);
	Возврат Результат;
	
КонецФункции

// Обработчик для события формы ПослеЗаписиНаСервере. Вызывается для контакта.
//
// Параметры:
//  Форма                          - ФормаКлиентскогоПриложения - форма, для которой обрабатывается событие.
//  Объект                         - ДанныеФормыКоллекция - данные объекта хранимые в форме.
//  ПараметрыЗаписи                - Структура - структура, в которую добавляются параметры, которые потом будут
//                                               посланы с оповещением.
//  ИмяОбъектаОтправителяСообщения - Строка - имя объекта метаданных, для формы которого обрабатывается событие.
//  ПосылатьОповещение  - Булево   - признак необходимости отправки оповещения из этой процедуры.
//
Процедура КонтактПослеЗаписи(Форма,Объект,ПараметрыЗаписи,ИмяОбъектаОтправителяСообщения,ПосылатьОповещение = Истина) Экспорт
	
	Если Форма.НеобходимоОповещение Тогда
		
		Если ЗначениеЗаполнено(Форма.ОбъектОснование) Тогда
			ПараметрыЗаписи.Вставить("Ссылка",Объект.Ссылка);
			ПараметрыЗаписи.Вставить("Наименование",Объект.Наименование);
			ПараметрыЗаписи.Вставить("Основание",Форма.ОбъектОснование);
			ПараметрыЗаписи.Вставить("ТипОповещения","ЗаписьКонтакта");
		КонецЕсли;
		
		Если ПосылатьОповещение Тогда
			Оповестить("Запись_" + ИмяОбъектаОтправителяСообщения,ПараметрыЗаписи,Объект.Ссылка);
			Форма.НеобходимоОповещение = Ложь
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик для события формы ПослеЗаписиНаСервере. Вызывается для взаимодействия или предмета взаимодействия.
//
// Параметры:
//  Форма                          - ФормаКлиентскогоПриложения - форма, для которой обрабатывается событие.
//  Объект                         - ОпределяемыйТип.ПредметВзаимодействия - данные объекта хранимые в форме.
//  ПараметрыЗаписи                - Структура - структура, в которую добавляются параметры, которые потом будут
//                                               посланы с оповещением.
//  ИмяОбъектаОтправителяСообщения - Строка - имя объекта метаданных, для формы которого обрабатывается событие.
//  ПосылатьОповещение  - Булево   - признак необходимости отправки оповещения из этой процедуры.
// 
Процедура ВзаимодействиеПредметПослеЗаписи(Форма,Объект,ПараметрыЗаписи,ИмяОбъектаОтправителяСообщения = "",ПосылатьОповещение = Истина) Экспорт
		
	Если ЗначениеЗаполнено(Форма.ВзаимодействиеОснование) Тогда
		ПараметрыЗаписи.Вставить("Основание",Форма.ВзаимодействиеОснование);
	Иначе
		ПараметрыЗаписи.Вставить("Основание",Неопределено);
	КонецЕсли;
	
	Если ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(Объект.Ссылка) Тогда
		ПараметрыЗаписи.Вставить("Предмет",Форма.Предмет);
		ПараметрыЗаписи.Вставить("ТипОповещения","ЗаписьВзаимодействия");
	ИначеЕсли ВзаимодействияКлиентСервер.ЯвляетсяПредметом(Объект.Ссылка) Тогда
		ПараметрыЗаписи.Вставить("Предмет",Объект.Ссылка);
		ПараметрыЗаписи.Вставить("ТипОповещения","ЗаписьПредмета");
	КонецЕсли;
	
	Если ПосылатьОповещение Тогда
		Оповестить("Запись_" + ИмяОбъектаОтправителяСообщения,ПараметрыЗаписи,Объект.Ссылка);
		Форма.НеобходимоОповещение = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик для события формы ПроверкаПеретаскивания. Вызывается для списка предметов при перетаскивании в него взаимодействий.
//
// Параметры:
//  Элемент                   - ТаблицаФормы - таблица, для которой обрабатывается событие.
//  ПараметрыПеретаскивания   - ПараметрыПеретаскивания - содержит перетаскиваемое значение, тип действия и возможные
//                                                        действия при перетаскивании.
//  СтандартнаяОбработка      - Булево - признак стандартной обработки события.
//  СтрокаТаблицы             - ДанныеФормыЭлементКоллекции - строка таблицы, над которой находится курсор.
//  Поле                      - Поле - элемент управляемой формы, с которым связана данная колонка таблицы.
//
Процедура СписокПредметПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, СтрокаТаблицы, Поле) Экспорт
	
	Если (СтрокаТаблицы = Неопределено) ИЛИ (ПараметрыПеретаскивания.Значение = Неопределено) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Для каждого ЭлементМассива Из ПараметрыПеретаскивания.Значение Цикл
			Если ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(ЭлементМассива) Тогда
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	
КонецПроцедуры

// Обработчик для события формы Перетаскивание. Вызывается для списка предметов при перетаскивании в него взаимодействий.
//
// Параметры:
//  Элемент                   - ТаблицаФормы - таблица, для которой обрабатывается событие.
//  ПараметрыПеретаскивания   - ПараметрыПеретаскивания - содержит перетаскиваемое значение, тип действия и возможные
//                                                        действия при перетаскивании.
//  СтандартнаяОбработка      - Булево - признак стандартной обработки события.
//  СтрокаТаблицы             - ДанныеФормыЭлементКоллекции - строка таблицы, над которой находится курсор.
//  Поле                      - Поле - элемент управляемой формы, с которым связана данная колонка таблицы.
//
Процедура СписокПредметПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, СтрокаТаблицы, Поле) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		ВзаимодействияВызовСервера.УстановитьПредметДляМассиваВзаимодействий(ПараметрыПеретаскивания.Значение,
			СтрокаТаблицы, Истина);
			
	КонецЕсли;
	
	Оповестить("ИзменениеПредметаВзаимодействий");
	
КонецПроцедуры

// Сохраняет письмо на компьютер.
//
// Параметры:
//  Письмо                  - ДокументСсылка.ЭлектронноеПисьмоВходящее
//                          - ДокументСсылка.ЭлектронноеПисьмоИсходящее - письмо, которое будет сохранено.
//  УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор формы, из которой была вызвана команда сохранения.
//
Процедура СохранитьПисьмоНаДиск(Письмо, УникальныйИдентификатор) Экспорт
	
	ДанныеФайла = ВзаимодействияВызовСервера.ДанныеПисьмаДляСохраненияКакФайл(Письмо, УникальныйИдентификатор);
	
	Если ДанныеФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму нового документа "Электронное письмо исходящее"
// с переданными в процедуру параметрами.
//
// Параметры:
//  ПараметрыПисьма - см. РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма.
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - описание оповещения о закрытии формы письма.
//
Процедура ОткрытьФормуОтправкиПисьма(Знач ПараметрыПисьма = Неопределено, Знач ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	ОткрытьФорму("Документ.ЭлектронноеПисьмоИсходящее.ФормаОбъекта", ПараметрыПисьма, , , , , ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  ИмяФормыОбъекта - Строка - имя формы элемента создаваемого объекта.
//  Основание       - ОпределяемыйТип.КонтактВзаимодействия
//                  - ОпределяемыйТип.ПредметВзаимодействия - объект-основание.
//  Источник        - ФормаКлиентскогоПриложения - форма объекта-основания, содержит:
//    * Элементы - ВсеЭлементыФормы - содержит:
//      ** Участники - ТаблицаФормы - данные о участниках взаимодействия.
//
Процедура СоздатьВзаимодействиеИлиПредмет(ИмяФормыОбъекта, Основание, Источник) Экспорт

	ПараметрыОткрытияФормы = Новый Структура("Основание", Основание);
	Если (ТипЗнч(Основание) = Тип("ДокументСсылка.Встреча") 
	    ИЛИ  ТипЗнч(Основание) = Тип("ДокументСсылка.ЗапланированноеВзаимодействие"))
		И Источник.Элементы.Найти("Участники") <> Неопределено
		И Источник.Элементы.Участники.ТекущиеДанные <> Неопределено Тогда
	
		ДанныеУчастникаИсточник = Источник.Элементы.Участники.ТекущиеДанные;
		ПараметрыОткрытияФормы.Вставить("ДанныеУчастника", ДанныеУчастника(ДанныеУчастникаИсточник));
	
	ИначеЕсли (ТипЗнч(Основание) = Тип("ДокументСсылка.СообщениеSMS") 
		И Источник.Элементы.Найти("Адресаты") <> Неопределено
		И Источник.Элементы.Адресаты.ТекущиеДанные <> Неопределено) Тогда
		
		ДанныеУчастникаИсточник = Источник.Элементы.Адресаты.ТекущиеДанные;
		ПараметрыОткрытияФормы.Вставить("ДанныеУчастника", ДанныеУчастника(ДанныеУчастникаИсточник));
	
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормыОбъекта, ПараметрыОткрытияФормы, Источник);

КонецПроцедуры

Функция ДанныеУчастника(Источник)
	Возврат Новый Структура("Контакт,КакСвязаться,Представление",
		Источник.Контакт,
		Источник.КакСвязаться,
		Источник.ПредставлениеКонтакта);
КонецФункции

// Открывает форму объекта-контакта заполненную по описанию участника взаимодействия.
//
// Параметры:
//  Описание      - Строка           - текстовое описание контакта.
//  Адрес         - Строка           - контактная информация.
//  Основание     - ДокументОбъект   - документ взаимодействия, из которого создается контакт.
//  ТипыКонтактов - СписокЗначений   - список возможных типов контактов.
//
Процедура СоздатьКонтакт(Описание, Адрес, Основание, ТипыКонтактов) Экспорт

	Если ТипыКонтактов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Описание", Описание);
	ДополнительныеПараметры.Вставить("Адрес", Адрес);
	ДополнительныеПараметры.Вставить("Основание", Основание);
	ОбработчикОповещения = Новый ОписаниеОповещения("ВыборТипаКонтактаПриЗавершении", ЭтотОбъект, ДополнительныеПараметры);
	ТипыКонтактов.ПоказатьВыборЭлемента(ОбработчикОповещения, НСтр("ru = 'Выбор типа контакта'"));

КонецПроцедуры

// Обработчик оповещения выбора типа контакта при создании контакта из документов взаимодействий.
//
// Параметры:
//  РезультатВыбора - ЭлементСпискаЗначений - в значение элемента содержится строковое представление типа контакта,
//  ДополнительныеПараметры - Структура - содержит поля "Описание", "Адрес" и "Основание".
//
Процедура ВыборТипаКонтактаПриЗавершении(РезультатВыбора, ДополнительныеПараметры) Экспорт

	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрФормы = Новый Структура("Основание", ДополнительныеПараметры);
	Контакты = ВзаимодействияКлиентСервер.ОписанияКонтактов();
	ИмяФормыНовогоКонтакта = "";
	Для каждого Контакт Из Контакты Цикл
		Если Контакт.Имя = РезультатВыбора.Значение Тогда
			ИмяФормыНовогоКонтакта = Контакт.ИмяФормыНовогоКонтакта; 
		КонецЕсли;
	КонецЦикла;
	
	Если ПустаяСтрока(ИмяФормыНовогоКонтакта) Тогда
		// АПК:222-выкл Для обратной совместимости.
		Если ВзаимодействияКлиентПереопределяемый.СоздатьКонтактНестандартнаяФорма(РезультатВыбора.Значение, ПараметрФормы) Тогда
			Возврат;
		КонецЕсли;
		// АПК:222-вкл
		ИмяФормыНовогоКонтакта = "Справочник." + РезультатВыбора.Значение + ".ФормаОбъекта";
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормыНовогоКонтакта, ПараметрФормы);

КонецПроцедуры

// Обработчик для события формы ОбработкаОповещения. Вызывается для взаимодействия.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - содержит:
//     * Объект - ДокументОбъект.ТелефонныйЗвонок
//             - ДокументОбъект.ЗапланированноеВзаимодействие
//             - ДокументОбъект.СообщениеSMS
//             - ДокументОбъект.Встреча
//             - ДокументОбъект.ЭлектронноеПисьмоВходящее
//             - ДокументОбъект.ЭлектронноеПисьмоИсходящее - объект, который содержит форма.
//      * Элементы - ВсеЭлементыФормы - содержит:
//        ** Участники      - ТаблицаФормы - информация о контактах взаимодействия.
//        ** СоздатьКонтакт - КнопкаФормы - элемент, выполняющий команду создания взаимодействия.
//  ИмяСобытия - Строка - имя события.
//  Параметр - Структура:
//              * ТипОповещения - Строка - информация о типе оповещения.
//              * Основание - ОпределяемыйТип.КонтактВзаимодействия
//           
//  Источник - Произвольный - источник события.
//
Процедура ОтработатьОповещение(Форма,ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("ТипОповещения") Тогда
		Если (Параметр.ТипОповещения = "ЗаписьВзаимодействия" ИЛИ Параметр.ТипОповещения = "ЗаписьПредмета")
			И Параметр.Основание = Форма.Объект.Ссылка Тогда
			
			Если (Форма.Предмет = Неопределено ИЛИ ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(Форма.Предмет))
				И Форма.Предмет <> Параметр.Предмет Тогда
				Форма.Предмет = Параметр.Предмет;
				Форма.ОтобразитьИзменениеДанных(Форма.Предмет, ВидИзмененияДанных.Изменение);
			КонецЕсли;
			
		ИначеЕсли Параметр.ТипОповещения = "ЗаписьКонтакта" И Параметр.Основание = Форма.Объект.Ссылка Тогда
			
			Если ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда
				Форма.Объект.АбонентКонтакт = Параметр.Ссылка;
				Если ПустаяСтрока(Форма.Объект.АбонентПредставление) Тогда
					Форма.Объект.АбонентПредставление = Параметр.Наименование;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.Встреча") 
				ИЛИ ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.ЗапланированноеВзаимодействие")Тогда
				Форма.Элементы.Участники.ТекущиеДанные.Контакт = Параметр.Ссылка;
				Если ПустаяСтрока(Форма.Элементы.Участники.ТекущиеДанные.ПредставлениеКонтакта) Тогда
					Форма.Элементы.Участники.ТекущиеДанные.ПредставлениеКонтакта = Параметр.Наименование;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.СообщениеSMS") Тогда
				Форма.Элементы.Адресаты.ТекущиеДанные.Контакт = Параметр.Ссылка;
				Если ПустаяСтрока(Форма.Элементы.Адресаты.ТекущиеДанные.ПредставлениеКонтакта) Тогда
					Форма.Элементы.Адресаты.ТекущиеДанные.ПредставлениеКонтакта = Параметр.Наименование;
				КонецЕсли;
			КонецЕсли;
			
			Форма.Элементы.СоздатьКонтакт.Доступность = Ложь;
			Форма.Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ВыбранКонтакт" Тогда
		
		Если Форма.ИмяФормы = "Документ.ЭлектронноеПисьмоИсходящее.Форма.ФормаДокумента" 
			ИЛИ Форма.ИмяФормы = "Документ.ЭлектронноеПисьмоВходящее.Форма.ФормаДокумента" Тогда
			Возврат;
		КонецЕсли;
		
		Если Форма.УникальныйИдентификатор <> Параметр.ИдентификаторФормы Тогда
			Возврат;
		КонецЕсли;
		
		БылИзмененКонтакт = (Параметр.Контакт <> Параметр.ВыбранныйКонтакт) И ЗначениеЗаполнено(Параметр.Контакт);
		Контакт = Параметр.ВыбранныйКонтакт;
		Если Параметр.ТолькоEmail Тогда
			ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты");
		ИначеЕсли Параметр.ТолькоТелефон Тогда
			ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон");
		Иначе
			ТипКонтактнойИнформации = Неопределено;
		КонецЕсли;
		
		Если БылИзмененКонтакт Тогда
			
			Если НЕ Параметр.ДляФормыУточненияКонтактов Тогда
				ВзаимодействияВызовСервера.ПредставлениеИВсяКонтактнаяИнформациюКонтакта(
				             Контакт, Параметр.Представление, Параметр.Адрес, ТипКонтактнойИнформации);
			КонецЕсли;
			
			Адрес         = Параметр.Адрес;
			Представление = Параметр.Представление;
			
		ИначеЕсли Параметр.ЗаменятьПустыеАдресИПредставление И (ПустаяСтрока(Параметр.Адрес) ИЛИ ПустаяСтрока(Параметр.Представление)) Тогда
			
			нПредставление = ""; 
			нАдрес = "";
			ВзаимодействияВызовСервера.ПредставлениеИВсяКонтактнаяИнформациюКонтакта(
			             Контакт, нПредставление, нАдрес, ТипКонтактнойИнформации);
			
			Представление = ?(ПустаяСтрока(Параметр.Представление), нПредставление, Параметр.Представление);
			Адрес         = ?(ПустаяСтрока(Параметр.Адрес), нАдрес, Параметр.Адрес);
			
		Иначе
			
			Адрес         = Параметр.Адрес;
			Представление = Параметр.Представление;
			
		КонецЕсли;
		
		Если Форма.ИмяФормы = "ОбщаяФорма.АдреснаяКнига" Тогда

			ТекущиеДанные = Форма.Элементы.ПолучателиПисьма.ТекущиеДанные;
			Если ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			ТекущиеДанные.Контакт       = Контакт;
			ТекущиеДанные.Адрес         = Адрес;
			ТекущиеДанные.Представление = Представление;
			
			Форма.Модифицированность = Истина;
			
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.СообщениеSMS") Тогда
			ТекущиеДанные = Форма.Элементы.Адресаты.ТекущиеДанные;
			Если ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			Форма.ИзменилисьКонтакты = Истина;
			
			ТекущиеДанные.Контакт               = Контакт;
			ТекущиеДанные.КакСвязаться          = Адрес;
			ТекущиеДанные.ПредставлениеКонтакта = Представление;
			
			ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Форма.Объект,Форма,"СообщениеSMS");
			
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.ЗапланированноеВзаимодействие") Тогда
			ТекущиеДанные = Форма.Элементы.Участники.ТекущиеДанные;
			Если ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			Форма.ИзменилисьКонтакты = Истина;
			
			ТекущиеДанные.Контакт               = Контакт;
			ТекущиеДанные.КакСвязаться          = Адрес;
			ТекущиеДанные.ПредставлениеКонтакта = Представление;
			
			ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Форма.Объект, Форма, "ЗапланированноеВзаимодействие");
			Форма.Модифицированность = Истина;
			
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.Встреча") Тогда
			ТекущиеДанные = Форма.Элементы.Участники.ТекущиеДанные;
			Если ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			Форма.ИзменилисьКонтакты = Истина;
			
			ТекущиеДанные.Контакт               = Контакт;
			ТекущиеДанные.КакСвязаться          = Адрес;
			ТекущиеДанные.ПредставлениеКонтакта = Представление;
			
			ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Форма.Объект, Форма, "Встреча");
			Форма.Модифицированность = Истина;
			
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка)=Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда
			
			Форма.ИзменилисьКонтакты = Истина;
			
			Форма.Объект.АбонентКонтакт       = Контакт;
			Форма.Объект.АбонентКакСвязаться  = Адрес;
			Форма.Объект.АбонентПредставление = Представление;
			
			ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Форма.Объект, Форма, "ТелефонныйЗвонок");
			Форма.Модифицированность = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ЗаписьВзаимодействия"
		И Параметр = Форма.Объект.Ссылка Тогда
		
		Форма.Прочитать();
		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  ТипОбъекта        - Строка - тип создаваемого объекта.
//  ПараметрыСоздания - Структура - параметры создаваемого документа.
//  Форма             - ФормаКлиентскогоПриложения.
//
Процедура СоздатьНовоеВзаимодействие(ТипОбъекта, ПараметрыСоздания = Неопределено, Форма = Неопределено) Экспорт

	ОткрытьФорму("Документ." + ТипОбъекта + ".ФормаОбъекта", ПараметрыСоздания, Форма);

КонецПроцедуры

#Область ОбщиеОбработчикиСобытийДокументовВзаимодействий

// Открывает форму выбора контакта и обрабатывает результат выбора.
//
// Параметры:
//  Предмет        - ОпределяемыйТип.ПредметВзаимодействия - предмет взаимодействия.
//  Адрес          - Строка - адрес контакта.
//  Представление  - Строка - представление контакта.
//  Контакт        - ОпределяемыйТип.КонтактВзаимодействия - контакт.
//  Параметры      - см. ВзаимодействияКлиент.ПараметрыВыбораКонтакта.
//
Процедура ВыбратьКонтакт(Предмет, Адрес, Представление, Контакт, Параметры) Экспорт

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Предмет",                           Предмет);
	ПараметрыОткрытия.Вставить("Адрес",                             Адрес);
	ПараметрыОткрытия.Вставить("Представление",                     Представление);
	ПараметрыОткрытия.Вставить("Контакт",                           Контакт);
	ПараметрыОткрытия.Вставить("ТолькоEmail",                       Параметры.ТолькоEmail);
	ПараметрыОткрытия.Вставить("ТолькоТелефон",                     Параметры.ТолькоТелефон);
	ПараметрыОткрытия.Вставить("ЗаменятьПустыеАдресИПредставление", Параметры.ЗаменятьПустыеАдресИПредставление);
	ПараметрыОткрытия.Вставить("ДляФормыУточненияКонтактов",        Параметры.ДляФормыУточненияКонтактов);
	ПараметрыОткрытия.Вставить("ИдентификаторФормы",                Параметры.ИдентификаторФормы);
	
	ОткрытьФорму("ОбщаяФорма.ВыборКонтакта", ПараметрыОткрытия);

КонецПроцедуры

// Возвращаемое значение: 
//  Структура:
//    * ТолькоEmail   - Булево
//    * ТолькоТелефон - Булево
//    * ЗаменятьПустыеАдресИПредставление - Булево
//    * ДляФормыУточненияКонтактов - Булево
//
Функция ПараметрыВыбораКонтакта(ИдентификаторФормы) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ТолькоEmail",                       Ложь);
	Результат.Вставить("ТолькоТелефон",                     Ложь);
	Результат.Вставить("ЗаменятьПустыеАдресИПредставление", Истина);
	Результат.Вставить("ДляФормыУточненияКонтактов",        Ложь);
	Результат.Вставить("ИдентификаторФормы",                ИдентификаторФормы);
	Возврат Результат;
	
КонецФункции	

// Параметры:
//  ЗначениеПоля         - Дата - значение поля "Отработать после". 
//  ВыбранноеЗначение    - Дата
//                       - Число - либо выбранная дата, либо числовой инкремент от текущей даты.
//  СтандартнаяОбработка - Булево - признак стандартной обработки обработчика события формы.
//  Модифицированность   - Булево - признак модифицированности формы.
//
Процедура ОбработатьВыборВПолеРассмотретьПосле(ЗначениеПоля, ВыбранноеЗначение, СтандартнаяОбработка, Модифицированность) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Модифицированность = Истина;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Число") Тогда
		ЗначениеПоля = ОбщегоНазначенияКлиент.ДатаСеанса() + ВыбранноеЗначение;
	Иначе
		ЗначениеПоля = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает отбор по владельцу в динамическом списке подчиненного справочника, при активизации строки
// динамического списка справочника родителя.
//
// Параметры:
//  Элемент - ТаблицаФормы - таблица в которой произошло событие, содержит:
//   * ТекущиеДанные - СтрокаТаблицыЗначений:
//     ** Ссылка - ОпределяемыйТип.КонтактВзаимодействия - контакт.
//  Форма   - ФормаКлиентскогоПриложения - форма, на которой находятся элементы.
//
Процедура КонтактВладелецПриАктивизацииСтроки(Элемент,Форма) Экспорт
	
	ИмяТаблицыБезПрефикса = Прав(Элемент.Имя,СтрДлина(Элемент.Имя) - СтрДлина(ВзаимодействияКлиентСервер.ПрефиксТаблица()));
	ЗначениеОтбора = ?(Элемент.ТекущиеДанные = Неопределено, Неопределено, Элемент.ТекущиеДанные.Ссылка);
	
	МассивОписанияКонтактов = ВзаимодействияКлиентСервер.ОписанияКонтактов();
	Для каждого ЭлементМассиваОписания Из МассивОписанияКонтактов  Цикл
		Если ЭлементМассиваОписания.ИмяВладельца = ИмяТаблицыБезПрефикса Тогда
			КоллекцияОтборов = Форма["Список_" + ЭлементМассиваОписания.Имя].КомпоновщикНастроек.ФиксированныеНастройки.Отбор; // ОтборКомпоновкиДанных
			КоллекцияОтборов.Элементы[0].ПравоеЗначение = ЗначениеОтбора;
		КонецЕсли;
	КонецЦикла;
 
КонецПроцедуры 

Процедура ВопросПриИзмененииФорматаСообщенияНаОбычныйТекст(Форма, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросПриИзмененииФорматаПриЗакрытии", Форма, ДополнительныеПараметры);
	ТекстСообщения = НСтр("ru = 'При преобразовании этого сообщения в обычный текст будут утеряны все элементы оформления, картинки и прочие вставленные элементы. Продолжить?'");
	ПоказатьВопрос(ОбработчикОповещенияОЗакрытии, ТекстСообщения, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Изменение формата письма'"));
	
КонецПроцедуры

// Параметры:
//  Элемент - ТаблицаФормы - список в который происходит добавление, содержит:
//   * ТекущиеДанные - СтрокаТаблицыЗначений:
//     ** Ссылка - ДокументСсылка.ТелефонныйЗвонок
//               - ДокументСсылка.ЗапланированноеВзаимодействие
//               - ДокументСсылка.СообщениеSMS
//               - ДокументСсылка.Встреча
//               - ДокументСсылка.ЭлектронноеПисьмоВходящее
//               - ДокументСсылка.ЭлектронноеПисьмоИсходящее - ссылка взаимодействие.
//  Отказ  - Булево - признак отказа от добавления.
//  Копирование  - Булево - признак копирования.
//  ТолькоПочта  - Булево - признак того что используются только почтовый клиент.
//  ДокументыДоступныеДляСоздания  - СписокЗначений - список доступных для создания документов.
//  ПараметрыСоздания  - Структура - параметры создания нового документа.
//
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование,ТолькоПочта,ДокументыДоступныеДляСоздания,ПараметрыСоздания = Неопределено) Экспорт
	
	Если Копирование Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если ТипЗнч(ТекущиеДанные.Ссылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") 
			Или ТипЗнч(ТекущиеДанные.Ссылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
			Отказ = Истина;
			Если Не ТолькоПочта Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'Копирование электронных писем запрещено'"));
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  Элемент                        - ПолеФормы - для которой обрабатывается событие.
//  ДанныеСобытия                  - ФиксированнаяСтруктура - данные содержит параметры события.
//  СтандартнаяОбработка           - Булево - признак стандартной обработки события.
//
Процедура ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка) Экспорт
	
	Если ДанныеСобытия.Href <> Неопределено Тогда
		СтандартнаяОбработка = ЛОЖЬ;
		
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ДанныеСобытия.Href);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет проверку правильности заполнения реквизитов ДатаКогдаОтправить и ДатаАктуальностиОтправки в форме
// документа.
//
// Параметры:
//  Объект - ДокументОбъект - документ, в котором выполняется проверка.
//  Отказ  - Булево - устанавливает в истина, если реквизиты заполнены неправильно.
//
Процедура ПроверкаЗаполненностиРеквизитовОтложеннойОтправки(Объект, Отказ) Экспорт
	
	Если Объект.ДатаКогдаОтправить > Объект.ДатаАктуальностиОтправки И (Не Объект.ДатаАктуальностиОтправки = Дата(1,1,1)) Тогда
		
		Отказ = Истина;
		ТекстСообщения= НСтр("ru = 'Дата актуальности отправки меньше чем дата отправки.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ДатаАктуальностиОтправки");
		
	КонецЕсли;
	
	Если НЕ Объект.ДатаАктуальностиОтправки = Дата(1,1,1)
			И Объект.ДатаАктуальностиОтправки < ОбщегоНазначенияКлиент.ДатаСеанса() Тогда
	
		Отказ = Истина;
		ТекстСообщения= НСтр("ru = 'Указанная дата актуальности меньше текущей даты, такое сообщение никогда не будет отправлено'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ДатаАктуальностиОтправки");
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредметНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("ЖурналДокументов.Взаимодействия.Форма.ВыборТипаПредмета", ,Форма);
	
КонецПроцедуры

Процедура ФормаОбработкаВыбора(Форма, ВыбранноеЗначение, ИсточникВыбора, КонтекстВыбора) Экспорт
	
	 Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ЖурналДокументов.Взаимодействия.Форма.ВыборТипаПредмета") Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		
		КонтекстВыбора = "ВыборПредмета";
		
		ОткрытьФорму(ВыбранноеЗначение + ".ФормаВыбора", ПараметрыФормы, Форма);
		
	ИначеЕсли КонтекстВыбора = "ВыборПредмета" Тогда
		
		Если ВзаимодействияКлиентСервер.ЯвляетсяПредметом(ВыбранноеЗначение)
			Или ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(ВыбранноеЗначение) Тогда
		
			Форма.Предмет = ВыбранноеЗначение;
			Форма.Модифицированность = Истина;
		
		КонецЕсли;
		
		КонтекстВыбора = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  Письмо - ДокументСсылка.ЭлектронноеПисьмоВходящее
//         - ДокументСсылка.ЭлектронноеПисьмоИсходящее
//         - СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы
//         - СправочникСсылка.ЭлектронноеПисьмоИсходящееПрисоединенныеФайлы
//  ПараметрыОткрытия - см. ПараметрыПисьмаВложения
//  Форма - ФормаКлиентскогоПриложения
//
Процедура ОткрытьВложениеПисьмо(Письмо, ПараметрыОткрытия, Форма) Экспорт
	
	ОчиститьСообщения();
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Письмо",                       Письмо);
	ПараметрыФормы.Вставить("НеВызыватьКомандуПечати",      ПараметрыОткрытия.НеВызыватьКомандуПечати);
	ПараметрыФормы.Вставить("ИмяПользователяУчетнойЗаписи", ПараметрыОткрытия.ИмяПользователяУчетнойЗаписи);
	ПараметрыФормы.Вставить("ОтображатьВложенияПисьма",     ПараметрыОткрытия.ОтображатьВложенияПисьма);
	ПараметрыФормы.Вставить("ДатаПисьмаОснования",          ПараметрыОткрытия.ДатаПисьмаОснования);
	ПараметрыФормы.Вставить("ПисьмоОснование",              ПараметрыОткрытия.ПисьмоОснование);
	ПараметрыФормы.Вставить("ТемаПисьмаОснования",          ПараметрыОткрытия.ТемаПисьмаОснования);
	
	ОткрытьФорму("ЖурналДокументов.Взаимодействия.Форма.ПечатьЭлектронногоПисьма", ПараметрыФормы, Форма);
	
КонецПроцедуры

// Возвращаемое значение:
//   Структура:
//     * ДатаПисьмаОснования          - Дата - дата письма-основания.
//     * ИмяПользователяУчетнойЗаписи - Строка - имя пользователя почты, которая приняла письмо-основание.
//     * НеВызыватьКомандуПечати      - Булево - признак того, что при открытии формы печати не нужно вызывать команду
//                                               печати ОС.
//     * ПисьмоОснование              - Неопределено
//                                    - Строка
//                                    - ДокументСсылка.ЭлектронноеПисьмоВходящее
//                                    - ДокументСсылка.ЭлектронноеПисьмоИсходящее - ссылка на письмо-основание или
//                                                                                  представление письма.
//     * ТемаПисьмаОснования          - Строка - тема письма-основания.
//
Функция ПараметрыПисьмаВложения() Экспорт

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ДатаПисьмаОснования", Дата(1, 1, 1));
	ПараметрыОткрытия.Вставить("ИмяПользователяУчетнойЗаписи", "");
	ПараметрыОткрытия.Вставить("НеВызыватьКомандуПечати", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьВложенияПисьма", Истина);
	ПараметрыОткрытия.Вставить("ПисьмоОснование", Неопределено);
	ПараметрыОткрытия.Вставить("ТемаПисьмаОснования", "");
	
	Возврат ПараметрыОткрытия;

КонецФункции 

Процедура ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт

	Если НавигационнаяСсылкаФорматированнойСтроки = "ВключитьПолучениеИОтправкуПисем" Тогда
		СтандартнаяОбработка = Ложь;
		ВзаимодействияВызовСервера.ВключитьОтправкуИПолучениеПисем();
		Элемент.Родитель.Видимость = Ложь;
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПерейтиКНастройкеРегламентныхЗаданий" Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
			МодульРегламентныеЗаданияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РегламентныеЗаданияКлиент");
			МодульРегламентныеЗаданияКлиент.ПерейтиКНастройкеРегламентныхЗаданий();
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОпределениеТипаСсылки

// Параметры:
//  ОбъектСсылка - ЛюбаяСсылка - для которой, необходимо выполнить проверку.
//
// Возвращаемое значение:
//   Булево   - Истина, если переданная ссылка является документом взаимодействием.
//
Функция ЯвляетсяЭлектроннымПисьмом(ОбъектСсылка) Экспорт
	
	Возврат ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее");
	
КонецФункции

#КонецОбласти

#КонецОбласти